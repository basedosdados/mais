"""
Class to manage the metadata of datasets and tables
"""
# pylint: disable=fixme, invalid-name, redefined-builtin, too-many-arguments, undefined-loop-variable, too-many-lines
from __future__ import annotations

import json

from copy import deepcopy
from datetime import datetime
from functools import lru_cache
from pathlib import Path
from typing import Tuple, Dict, Any, List

from loguru import logger

from ckanapi.errors import NotAuthorized, ValidationError
from ruamel.yaml.comments import CommentedMap
from ruamel.yaml.compat import ordereddict
import ruamel.yaml as ryaml

from basedosdados.exceptions import BaseDosDadosException
from basedosdados.upload.base import Base
from basedosdados.upload.remoteapi import RemoteAPI


class Metadata(Base):
    """
    Manage metadata in CKAN backend.
    """

    def __init__(self, dataset_id, table_id=None, **kwargs):
        super().__init__(**kwargs)

        self.dataset_uuid = self._get_dataset_id_from_slug(dataset_id)
        self.table_uuid = None

        self.table_id = table_id
        self.dataset_id = dataset_id

        if self.table_id:
            self.table_uuid = self._get_table_id_from_slug(dataset_id, table_id)
            self.dataset_metadata_obj = Metadata(self.dataset_id, **kwargs)

        url = "https://basedosdados.org"
        self.CKAN_API_KEY = self.config.get("ckan", {}).get("api_key")
        self.CKAN_URL = self.config.get("ckan", {}).get("url", "") or url

    def _get_nodes_from_edges(
        self,
        key: str,
        edge: Dict[str, Any],
    ) -> List[dict]:
        """
        Helper function to get nodes from edges and return a list
        of nodes with the given key.
        Args:
            key (str): Key to get from nodes.
            edge (Dict[str, Any]): Edge to get nodes from.
        Returns:
            List[dict]: List of nodes with the given key.
        """
        if not edge or not key:
            return []

        return [node["node"].get(key) for _, nodes in edge.items() for node in nodes]

    @property
    def filepath(self) -> Path:
        """Build the dataset or table filepath"""

        filename = "dataset_config.yaml"
        if self.table_id:
            filename = f"{self.table_id}/table_config.yaml"
        return self.metadata_path / self.dataset_id / filename

    @property
    def local_metadata(self) -> dict:
        """Load dataset or table local metadata"""

        if self.filepath.exists():
            with open(self.filepath, "r", encoding="utf-8") as file:
                return ryaml.safe_load(file.read())
        return {}

    @property
    def api_metadata(self) -> dict:
        """Load dataset or table metadata from Base dos Dados API"""

        api_dataset, api_table = self.api_metadata_extended
        if not api_dataset:
            return {}
        api_dataset["organization_id"] = api_dataset["organization"]["_id"]
        api_dataset["organization"] = api_dataset["organization"]["slug"]
        if api_table:
            api_table[
                "update_frequency"
            ] = f"{api_table['update_frequency']['number']} {api_table['update_frequency']['period']['name'].lower()}"
            api_table["partitions"] = [
                partition["name"] for partition in api_table["partitions"]
            ]
            api_table["metadata_modified"] = api_table["metadata_modified"].split("T")[
                0
            ]
            for idx, column in enumerate(api_table["columns"]):
                api_table["columns"][idx]["bigquery_type"] = column["bigquery_type"][
                    "title"
                ].lower()
        else:
            api_dataset["notes"] = api_dataset["description"]
            api_dataset["themes"] = [theme["slug"] for theme in api_dataset["themes"]]
            api_dataset["tags"] = [tag["slug"] for tag in api_dataset["tags"]]
            api_dataset["metadata_modified"] = api_dataset["metadata_modified"]
        return api_table or api_dataset

    @property
    def api_metadata_extended(self) -> Tuple[dict, dict]:
        """Load dataset or table metadata from Base dos Dados API"""

        if not self.dataset_uuid:
            return {}, {}

        with open(
            self.graphql_queries_path / "dataset_table_by_id.graphql",
            "r",
            encoding="utf-8",
        ) as file:
            query = file.read()

        variables = {"id": self.dataset_uuid}
        api_response = self._get_graphql(query, variables)
        dataset = api_response.get("allDataset")
        if not dataset or len(dataset) == 0:
            return {}, {}

        if self.table_uuid:
            for table in dataset[0]["tables"]:
                if table["_id"] == self.table_uuid:
                    return dataset[0], table

        return dataset[0], {}

    @property
    @lru_cache(256)
    def columns_schema(self) -> dict:
        """
        Returns a dictionary with the schema of the columns
        To keep compatibility with the old metadata schema, the schema is
        read from a local file. In the future, this should be read from
        the API endpoint.
        """

        json_path = Path(__file__).parent.parent / "schemas/columns_schema.json"
        with open(json_path, "r", encoding="utf-8") as f:
            schema = json.loads(f.read())

        return schema.get("result")

    @property
    @lru_cache(256)
    def metadata_schema(self) -> dict:
        """
        Returns a dictionary with the schema of the metadata (table or dataset)
        To keep compatibility with the old metadata schema, the schema is
        read from a local file. In the future, this should be read from
        the API endpoint.
        """

        if self.table_id:
            json_path = Path(__file__).parent.parent / "schemas/table_schema.json"
        else:
            json_path = Path(__file__).parent.parent / "schemas/dataset_schema.json"

        with open(json_path, "r", encoding="utf-8") as f:
            schema = json.loads(f.read())

        return schema.get("result")

    def exists(self) -> bool:
        """Check if Metadata object refers to an existing dataset or table.

        The method will fetch the api to check whether the dataset or table exists.

        Returns:
            bool: The existence condition of the metadata in the API. `True` if i
            t exists, `False` otherwise.
        """
        query = """
            query ($dataset_id: String!, $table_id: String) {
              allDataset(slug: $dataset_id) {
                edges {
                  node {
                    id
                    namePt
                    tables (slug: $table_id) {
                      edges {
                        node {
                          id
                        }
                      }
                    }
                  }
                }
              }
            }
        """
        variables = {"dataset_id": self.dataset_id, "table_id": self.table_id}

        response = self._get_graphql(query, variables)

        dataset = response.get("allDataset")
        if not dataset:
            return False

        if self.table_id:
            tables = dataset[0].get("tables")
            if not tables:
                return False

        return True

    def is_updated(self) -> bool:
        """Check if a dataset or table is updated.

        The method will fetch the api to check whether the dataset or table is updated.

        Returns:
            bool: The update condition of local metadata. `True` if it corresp
            onds to the most recent version of the given table or dataset's me
            tadata in API, `False` otherwise.
        """

        api_modified = self.api_metadata.get("metadata_modified")
        local_modified = self.local_metadata.get("metadata_modified")

        return api_modified == local_modified


###############################################################################
# Helper Functions
###############################################################################


def handle_data(k, data, local_default=None):
    """Parse API's response data so that it is used in the YAML configuration
    files.

    Args:
        k (str): a key of the CKAN API's response metadata dictionary.
        data (dict): a dictionary of metadata generated from the API.
        local_default (Any): the default value of the given key in ca
            se its value is set to `None` in CKAN.

    Returns:
        list: a list of metadata values
    """

    # If no data is None then return a empty dict
    data = data if data is not None else {}
    # If no data is found for that key, uses local default
    selected = data.get(k, local_default)

    # In some cases like `tags`, `groups`, `organization`
    # the API default is to return a dict or list[dict] with all info.
    # But, we just use `name` to build the yaml
    _selected = deepcopy(selected)

    if _selected == []:
        return _selected

    if not isinstance(_selected, list):
        _selected = [_selected]

    if isinstance(_selected[0], dict):
        if _selected[0].get("id") is not None:
            return [s.get("name") for s in _selected]

    return selected
