"""
Module for interacting with the backend.
"""
from typing import Any, Dict

from loguru import logger

try:
    from gql import Client, gql
    from gql.transport.requests import RequestsHTTPTransport

    _backend_dependencies = True
except ImportError:
    _backend_dependencies = False

from basedosdados.exceptions import BaseDosDadosMissingDependencyException


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
    ) -> "Client":
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
        if not _backend_dependencies:
            raise BaseDosDadosMissingDependencyException(
                "Optional dependencies for backend interaction are not installed. "
                'Please install basedosdados with the "upload" extra, such as:'
                "\n\npip install basedosdados[upload]"
            )
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
        client: "Client" = None,
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
        if not _backend_dependencies:
            raise BaseDosDadosMissingDependencyException(
                "Optional dependencies for backend interaction are not installed. "
                'Please install basedosdados with the "upload" extra, such as:'
                "\n\npip install basedosdados[upload]"
            )
        if not client:
            client = self._get_client(
                headers=headers, fetch_schema_from_transport=fetch_schema_from_transport
            )
        try:
            return client.execute(gql(query), variable_values=variables)
        except Exception as e:
            msg = f"The API URL in the config.toml file may be incorrect or the API might be temporarily unavailable!\nError executing query: {e}."
            logger.error(msg)
            return None

    def _get_dataset_id_from_name(self, gcp_dataset_id):
        query = """
            query ($gcp_dataset_id: String!){
                allCloudtable(gcpDatasetId: $gcp_dataset_id) {
                    edges {
                        node {
                                table {
                                    dataset {
                                        _id
                                    }
                            }
                        }
                    }
                }
            }
        """

        variables = {"gcp_dataset_id": gcp_dataset_id}
        response = self._execute_query(query=query, variables=variables)
        r = {} if response is None else self._simplify_graphql_response(response)
        if r.get("allCloudtable", []) != []:
            return r.get("allCloudtable")[0].get("table").get("dataset").get("_id")
        msg = f"{gcp_dataset_id} not found. Please create the metadata first in {self.graphql_url}"
        logger.info(msg)
        return None

    def _get_table_id_from_name(self, gcp_dataset_id, gcp_table_id):
        query = """
            query ($gcp_dataset_id: String!, $gcp_table_id: String!){
                allCloudtable(gcpDatasetId: $gcp_dataset_id, gcpTableId: $gcp_table_id) {
                    edges {
                        node {
                                table {
                                    _id
                            }
                        }
                    }
                }
            }
        """

        if gcp_dataset_id:
            variables = {
                "gcp_dataset_id": gcp_dataset_id,
                "gcp_table_id": gcp_table_id,
            }

            response = self._execute_query(query=query, variables=variables)
            r = {} if response is None else self._simplify_graphql_response(response)
            if r.get("allCloudtable", []) != []:
                return r.get("allCloudtable")[0].get("table").get("_id")
        msg = f"No table {gcp_table_id} found in {gcp_dataset_id}. Please create in {self.graphql_url}"
        logger.info(msg)
        return None

    def get_dataset_config(self, dataset_id: str) -> Dict[str, Any]:
        """
        Get dataset configuration.

        Args:
            dataset_id (str): The ID for the dataset.

        Returns:
            Dict: Dataset configuration.
        """
        query = """
            query ($dataset_id: ID!){
                allDataset(id: $dataset_id) {
                    edges {
                        node {
                            slug
                            name
                            descriptionPt
                            createdAt
                            updatedAt
                            themes {
                                edges {
                                    node {
                                        namePt
                                    }
                                }
                            }
                            tags {
                                edges {
                                    node {
                                        namePt
                                    }
                                }
                            }
                            organization {
                                namePt
                            }
                        }
                    }
                }
            }

        """
        dataset_id = self._get_dataset_id_from_name(dataset_id)
        if dataset_id:
            variables = {"dataset_id": dataset_id}
            response = self._execute_query(query=query, variables=variables)
            return self._simplify_graphql_response(response).get("allDataset")[0]
        else:
            return {}

    def get_table_config(self, dataset_id: str, table_id: str) -> Dict[str, Any]:
        """
        Get table configuration.

        Args:
            dataset_id (str): The ID for the dataset.
            table_id (str): The ID for the table.

        Returns:
            Dict: Table configuration.
        """

        query = """
            query ($table_id: ID!){
                allTable(id: $table_id) {
                    edges {
                        node {
                            slug
                            dataset {
                                slug
                                organization {
                                    slug
                                }
                            }
                            namePt
                            descriptionPt
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
        table_id = self._get_table_id_from_name(
            gcp_dataset_id=dataset_id, gcp_table_id=table_id
        )

        if table_id:
            variables = {"table_id": table_id}
            response = self._execute_query(query=query, variables=variables)
            return self._simplify_graphql_response(response).get("allTable")[0]
        else:
            return {}

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
                    and response[key].get("edges") is not None  # noqa
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
