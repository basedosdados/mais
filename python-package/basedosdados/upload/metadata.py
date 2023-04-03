"""
Class to manage the metadata of datasets and tables

"""
# pylint: disable=fixme, invalid-name, redefined-builtin, too-many-arguments, undefined-loop-variable, too-many-lines
from __future__ import annotations

import json

from copy import deepcopy
from functools import lru_cache
from pathlib import Path
from typing import Tuple, Dict, Any, List

from loguru import logger

from basedosdados.upload.base import Base


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
        # self.CKAN_API_KEY = self.config.get("ckan", {}).get("api_key")
        # self.CKAN_URL = self.config.get("ckan", {}).get("url", "") or url

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


# class Metadata:

#     def __init__(self):
#         self.prop2 = 2
#         self.__dict = self.get()
        
#     def __getattr__(self, name):
#         return self.__dict[name]

#     @property
#     def     self):
#         self.__dict['publish_sql']
#         return "olá"
        
#     def get(self):
#         return dict(publish_sql = "oi", prop1 = 1)