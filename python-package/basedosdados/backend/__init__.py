"""
Module for interacting with the backend.
"""
from typing import Any, Dict
from loguru import logger

from gql import gql, Client
from gql.transport.requests import RequestsHTTPTransport

from basedosdados.exceptions import BaseDosDadosException


class Backend:
    def __init__(self, graphql_url: str):
        """
        Backend class for interacting with the backend.

        Args:
            graphql_url (str): URL of the GraphQL endpoint.
        """
        self._graphql_url: str = graphql_url

    @property
    def graphql_url(self) -> str:
        """
        GraphQL endpoint URL.
        """
        return self._graphql_url

    def _get_client(
        self, headers: Dict[str, str] = None, fetch_schema_from_transport: bool = False
    ) -> Client:
        """
        Get a GraphQL client.

        Args:
            headers (Dict[str, str], optional): Headers to be passed to the client. Defaults to
                None.
            fetch_schema_from_transport (bool, optional): Whether to fetch the schema from the
                transport. Defaults to False.

        Returns:
            Client: GraphQL client.
        """
        transport = RequestsHTTPTransport(
            url=self.graphql_url, headers=headers, use_json=True
        )
        return Client(
            transport=transport, fetch_schema_from_transport=fetch_schema_from_transport
        )

    def _execute_query(
        self,
        query: str,
        variables: Dict[str, str] = None,
        client: Client = None,
        headers: Dict[str, str] = None,
        fetch_schema_from_transport: bool = False,
    ) -> Dict[str, Any]:
        """
        Execute a GraphQL query.

        Args:
            query (str): GraphQL query.
            variables (Dict[str, str], optional): Variables to be passed to the query. Defaults
                to None.
            client (Client, optional): GraphQL client. Defaults to None.
            headers (Dict[str, str], optional): Headers to be passed to the client. Defaults to
                None.
            fetch_schema_from_transport (bool, optional): Whether to fetch the schema from the
                transport. Defaults to False.

        Returns:
            Dict: GraphQL response.
        """
        if not client:
            client = self._get_client(
                headers=headers, fetch_schema_from_transport=fetch_schema_from_transport
            )
        return client.execute(gql(query), variable_values=variables)

    def get_dataset_config(dataset_id: str) -> Dict[str, Any]:
        """
        Get dataset configuration.

        Args:
            dataset_id (str): The ID for the dataset.

        Returns:
            Dict: Dataset configuration in the following format:
                {
                    "name": "dataset-name",
                    "title": "Dataset Title",
                    "organization": [
                        "organization-name",
                    ],
                    "notes": "Dataset description",
                    "groups": [
                        "group-name",
                    ],
                    "tags": [
                        "tag-name",
                    ],
                    "metadata_modified": "2020-01-01T00:00:00.000000",
                }
        """
        raise NotImplementedError()

    def get_table_config(self, dataset_id: str, table_id: str) -> Dict[str, Any]:
        """
        Get table configuration.

        Args:
            dataset_id (str): The ID for the dataset.
            table_id (str): The ID for the table.

        Returns:
            Dict: Table configuration in the following format:
                {
                    "dataset_id": "dataset-name",
                    "table_id": "table-name",
                    "title": "Table Title",
                    "description": "Table description",
                    "spatial_coverage": [
                        "sa.br",
                    ],
                    "temporal_coverage": [
                        "2010(1)2019
                    ],
                    "update_frequency": "1 year",
                    "observation_level": [
                        {
                            "country": "br",
                            "entity": "municipality",
                            "column": [
                                "column-name",
                            ]
                        }
                    ],
                    "last_updated": {
                        "metadata": "2020-01-01",
                        "data": "2020-01-01 00:00:00",
                        "release": "",
                    },
                    "version": "v2.0",
                    "published_by": {
                        "name": "Name",
                        "email": "mail@example.com",
                        "github_user": "github-user",
                        "website": "https://example.com",
                    },
                    "data_cleaned_by": {
                        "name": "Name",
                        "email": "mail@example.com",
                        "github_user": "github-user",
                        "website": "https://example.com",
                    },
                    "data_cleaning_description": "Data cleaning description",
                    "data_cleaning_code_url": "https://example.com",
                    "partner_organization": {
                        "name": "Name",
                        "organization_id": "organization-id",
                    },
                    "raw_files_url": "https://example.com",
                    "auxiliary_files_url": "https://example.com",
                    "architecture_url": "https://example.com",
                    "source_bucket_name": "bucket-name",
                    "project_id_prod": "project-id",
                    "project_id_staging": "project-id",
                    "partitions": [
                        "column-name",
                    ],
                    "columns": [
                        {
                            "name": "column-name",
                            "bigquery_type": "STRING",
                            "description": "Column description",
                            "temporal_coverage": [
                                "2010(1)2019
                            ],
                            "covered_by_dictionary": True,
                            "directory_column": {
                                "dataset_id": "dataset-name",
                                "table_id": "table-name",
                                "column_name": "column-name",
                            },
                            "measurement_unit": "unit",
                            "has_sensitive_data": True,
                            "observations": "observations",
                            "is_in_staging": True,
                            "is_partition": True,
                        }
                    ],
                    "metadata_modified": "2020-01-01T00:00:00.000000",
                }
        """
        raise NotImplementedError()

    def _simplify_graphql_response(self, response: dict) -> dict:
        """
        Simplify the graphql response
        Args:
            response: the graphql response
        Returns:
            dict: the simplified graphql response
        """
        if response == {}:  # pragma: no cover
            return {}

        output_ = {}

        for key in response:
            try:
                if (
                    isinstance(response[key], dict)
                    and response[key].get("edges") is not None
                ):
                    output_[key] = [
                        v.get("node")
                        for v in list(
                            map(self._simplify_graphql_response, response[key]["edges"])
                        )
                    ]
                elif isinstance(response[key], dict):
                    output_[key] = self._simplify_graphql_response(response[key])
                else:
                    output_[key] = response[key]
            except TypeError as e:
                logger.error(f"Erro({e}): {key} - {response[key]}")
        return output_

    def _get_id_from_slug(self, query, variables):
        response = self._get_graphql(query, variables)
        dataset_edges = response["allDataset"]["edges"]

        if not dataset_edges:
            print("refireciona para formulario do front: dataset")
            raise BaseDosDadosException(f"Dataset {variables['slug']} not found")

        dataset_node = dataset_edges[0]["node"]

        if not variables.get("table_slug", None):
            return dataset_node["_id"]

        table_edges = dataset_node["tables"]["edges"]

        if not table_edges:
            print("refireciona para formulario do front: table")
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

    def publish_sql(self):
        query = """
            query{
                allTable (id:"3b65f9c8-c50c-4e89-9c41-3a42eb357fd0"){
                    edges {
                    node {
                        id
                        slug
                        dataset {
                                    id
                        slug
                        }
                        columns {
                        edges {
                            node {
                            name
                            isInStaging
                            isPartition
                            descriptionPt
                            observations
                            bigqueryType {
                                name
                            }
                            }
                        }
                        }
                    }
                    }
                }
            }
        """
        variables = {"table_uuid": self.table_uuid}
        return self._simplify_graphql_response(self._get_graphql(query, variables))

    def dataset_description(self):
        return True

    def table_description_bq(self):
        return True

    def schema_prod_bq(self):
        return True

    def schema_staging_bq(self):
        return True
