"""
Module for interacting with the backend.
"""
from typing import Any, Dict

from gql import gql, Client
from gql.transport.requests import RequestsHTTPTransport


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
