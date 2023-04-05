"""
Class to manage the metadata of datasets and tables

"""
# pylint: disable=fixme, invalid-name, redefined-builtin, too-many-arguments, undefined-loop-variable, too-many-lines
from __future__ import annotations

import json
import requests
from typing import Dict, Any, List

from loguru import logger

from basedosdados.exceptions import BaseDosDadosException
from basedosdados.upload.base import Base
import pwinput


class Metadata(Base):
    """
    Manage metadata in CKAN backend.
    """

    def __init__(self, dataset_id, table_id=None, base_url=None, **kwargs):
        super().__init__(**kwargs)

        self.table_id = table_id
        self.dataset_id = dataset_id

        self.url_graphql = base_url or f"{self.base_url}/api/v1/graphql"
        self.dataset_uuid = self._get_dataset_id_from_slug(dataset_slug=dataset_id)
        if table_id is not None:
            self.table_uuid = self._get_table_id_from_slug(
                dataset_slug=dataset_id, table_slug=table_id
            )
        else:
            self.table_uuid = None

    def _get_graphql(self, query: str, variables: dict, headers: dict = None) -> dict:
        if headers is None:
            headers = {}
        graphql_json = {"query": query, "variables": variables}
        response = requests.post(
            self.url_graphql, headers=headers, json=graphql_json, timeout=90
        ).json()

        if "errors" in response:
            logger.error(response["errors"])

        return response.get("data", {})

    def _get_id_from_slug(self, query, variables):
        response = self._get_graphql(query, variables)
        dataset_edges = response["allDataset"]["edges"]

        if not dataset_edges:
            raise BaseDosDadosException(f"Dataset {variables['slug']} not found")

        dataset_node = dataset_edges[0]["node"]

        if not variables.get("table_slug", None):
            return dataset_node["_id"]

        table_edges = dataset_node["tables"]["edges"]

        if not table_edges:
            raise BaseDosDadosException(
                f"Table {variables['table_slug']} not found in dataset {variables['dataset_slug']}"
            )

        return table_edges[0]["node"]["_id"]

    def _get_dataset_id_from_slug(self, dataset_slug):
        query = """
            query ($slug: String!){
              allDataset(slug: $slug) {
                edges {
                  node {
                    _id,
                  }
                }
              }
            }
        """
        variables = {"slug": dataset_slug}
        return self._get_id_from_slug(query, variables)

    def _get_table_id_from_slug(self, dataset_slug, table_slug):
        query = """
            query ($dataset_slug: String!, $table_slug: String!){
                allDataset(slug: $dataset_slug) {
                    edges {
                        node {
                            _id,
                            tables(slug: $table_slug) {
                                edges {
                                    node {
                                        _id,
                                    }
                                }
                            }
                        }
                    }
                }
            }
        """
        variables = {"dataset_slug": dataset_slug, "table_slug": table_slug}
        return self._get_id_from_slug(query, variables)

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
