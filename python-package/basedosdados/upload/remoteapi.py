"""
An interface to make mutations to the remote API.
"""
from pprint import pprint
from typing import Tuple

import requests

from basedosdados.exceptions import BaseDosDadosException
from tqdm import tqdm


class RemoteAPI:
    """
    Interface to make mutations to the remote API.
    """

    def __init__(self, api_url, token):
        self._url = api_url
        self.token = token
        self.header = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {self.token}"
        }

    def call_action(self, action, data_dict):
        """
        Call an action in the API.
        """
        actions = [
            "update_table",
            "create_table",
            "update_dataset",
            "create_dataset",
        ]
        if action not in actions:
            raise ValueError(f"Action must be one of {actions}")

        data = data_dict.copy()
        request_fn = getattr(self, action)
        response = request_fn(data)

        return response

    @staticmethod
    def _prepare_fields(data: dict) -> dict:
        """
        Prepare fields to be sent to the API, removing createdAt and updatedAt
        and including $ in front of the keys, as they are query variables.
        """
        if "createdAt" in data:
            del data["createdAt"]
        if "updatedAt" in data:
            del data["updatedAt"]
        input_dataset = {}
        for key, value in data.items():
            input_dataset.update(
                {
                    f"${key}": value
                }
            )
        return input_dataset

    def get_id(self, query_class: str, slug: str) -> str:
        """
        Gets the ID of an object by its slug.

        Args:
            query_class (str): The class of the object to be queried.
            slug (str): The slug of the object to be queried.
        Returns:
            str: The ID of the object.
        Raises:
            BaseDosDadosException: If the object is not found.
        """
        query = f"""query {{
            {query_class}(slug: "{slug}") {{
                edges {{
                    node {{
                        _id
                    }}
                }}
            }}
        }}"""
        res = requests.post(
            url=self._url,
            json={"query": query},
            headers=self.header,
            timeout=90
        ).json()

        if "data" in res:
            if not res.get("data", {}).get(f"{query_class}", {}).get("edges") or "errors" in res:
                raise BaseDosDadosException(f"Theme {slug} not found")

            id_ = res["data"][f"{query_class}"]["edges"][0]["node"]["_id"]
            return id_

    @staticmethod
    def create_update(
            mutation_class: str,
            mutation_parameters: dict,
    ) -> Tuple[str, dict]:
        """
        Creates the query and parameters for a mutation based on data_dict.
        The ID must not be set when creating a new object.

        Args:
            mutation_class (str): The class of the object to be mutated.
            mutation_parameters (dict): The parameters of the mutation.
        Returns:
            Tuple[str, dict]: The query and parameters for the mutation.
        """
        _classe = mutation_class.replace("CreateUpdate", "").lower()
        query = f"""
                mutation($input:{mutation_class}Input!){{
                    {mutation_class}(input: $input){{
                    errors {{
                        field,
                        messages
                    }},
                    clientMutationId,
                    {_classe} {{
                        id,
                    }}
                }}
                }}
            """
        return query, mutation_parameters

    @staticmethod
    def _perform_mutation(query: str, mutation_parameters: dict) -> dict:
        """
        Performs the mutation with the query and parameters passed
        by the action called by the user.
        TODO: Implement the mutation

        Args:
            query (str): The query to be performed.
            mutation_parameters (dict): The parameters of the mutation.
        Returns:
            dict: The response of the mutation.
        Raises:
            Exception: If the mutation fails.
        """
        response = {}
        response["result"] = "not implemented yet"
        response["message"] = f"""
        Teste com a query:{query}\n
        Teste com os parâmetros:{mutation_parameters}
        """
        response["data"] = "10279a86-53be-4291-986d-9ef1d68c2bda"  # mock a dataset_uuid

        # r = requests.post(
        #     self._url,
        #     json={"query": query, "variables": {"input": mutation_parameters}},
        #     headers=self.header,
        # ).json()
        # r["r"] = "mutation"
        # if "data" in r:
        #     if r.get("data", {}).get(mutation_class, {}).get("errors", []) != []:
        #         print(f"create: not found {mutation_class}", mutation_parameters)
        #         print(
        #             "create: error\n", json.dumps(r, indent=4, ensure_ascii=False), "\n"
        #         )
        #         id = None
        #         raise Exception("create: Error")
        #     else:
        #         id = r["data"][mutation_class][_classe]["id"]
        #         # print(f"create: created {id}")
        #         id = id.split(":")[1]
        #
        #         return r, id
        # else:
        #     print("\n", "create: query\n", query, "\n")
        #     print(
        #         "create: input\n",
        #         json.dumps(mutation_parameters, indent=4, ensure_ascii=False),
        #         "\n",
        #     )
        #     print("create: error\n", json.dumps(r, indent=4, ensure_ascii=False), "\n")
        #     raise Exception("create: Error")
        return response

    def create_dataset(self, data: dict) -> dict:
        """
        Creates the mutation query for a dataset and performs it.
        The ID must not be set when creating a new object.

        Args:
            data (dict): The data to build the query.
        Returns:
            dict: The response of the mutation.
        Raises:
            BaseDosDadosException: If the dataset already exists.
        """
        if "id" in data:
            if data.get("id") is not None:
                raise BaseDosDadosException(
                    "Dataset already exists in API. Use update_dataset instead."
                )
            del data["id"]
        print(f"Creating dataset {data['name']}...")

        # mandatory fields for create_dataset
        if data.get("owner_org") is None:
            raise BaseDosDadosException("Organization is required.")
        data["organization"] = self.get_id("allOrganization", data["owner_org"])

        if data.get("themes") is None:
            raise BaseDosDadosException("Themes are required.")
        themes = [self.get_id("allTheme", theme) for theme in data["themes"]]
        data["themes"] = themes

        if data.get("tags") is None:
            raise BaseDosDadosException("Tags are required.")
        tags = []
        for tag in data["tags"]:
            tag = self.get_id("allTag", tag)
            tags.append(tag)
        data["tags"] = tags

        if data.get("slug") is None:
            raise BaseDosDadosException("Dataset slug is required.")

        if data.get("name") is None:
            raise BaseDosDadosException("Dataset ame is required.")

        fields = self._prepare_fields(data)
        query, mutation_parameters = self.create_update("CreateUpdateDataset", fields)
        response = self._perform_mutation(query, mutation_parameters)

        return response

    def update_dataset(self, data: dict) -> dict:
        """
        Updates the dataset according to the data passed. As the API is the source of truth,
        it is necessary to get the data from the API and only update fields that are blank
        in the database.

        Args:
            data (dict): The data to build the query.
        Returns:
            dict: The response of the mutation.
        Raises:
            BaseDosDadosException: If the dataset does not exist.
        """
        if "id" not in data:
            raise BaseDosDadosException("Dataset id is required.")
        # Tables cannot be updated by dataset metatada update
        if "tables" in data:
            del data["tables"]
        if "name" not in data:
            raise BaseDosDadosException("Dataset name is required.")
        print("Updating dataset...", data["name"])
        print("Data from dict: ", data)

        response = self._perform_mutation("", {})
        return response

    def create_table(self, data: dict) -> dict:
        """
        Creates the dataset according to the data passed and performs it.
        The ID must not be set when creating a new object. Tables must
        belong to a dataset.
        Args:
            data(dict): The data to build the query.

        Returns:
            dict: The response of the mutation.

        """
        pprint(data)
        if "id" in data:
            if data.get("id") is not None:
                raise BaseDosDadosException(
                    "Table already exists in API. Use update_table instead."
                )
            del data["id"]
        print(f"Creating table {data['name']}...")

        # mandatory fields for create_table
        # dataset
        if data.get("dataset_id") is None:
            raise BaseDosDadosException("Dataset is required.")
        # ambas
        # observation_level
        # coverage/area
        # datetime_range

        # somente para table
        # license
        # partner organization
        # update_frequency
        # pipeline
        # slug
        if not data.get("dataset_slug"):
            raise BaseDosDadosException("Dataset slug is required.")
        if not data.get("table_slug"):
            raise BaseDosDadosException("Table slug is required.")
        # name
        if not data.get("name"):
            raise BaseDosDadosException("Table name is required.")

        # somente para colunas
        # table_id
        # bigquery_type
        # name

        fields = self._prepare_fields(data)
        query, mutation_parameters = self.create_update("CreateUpdateTable", fields)
        response = self._perform_mutation(query, mutation_parameters)

        return response

    def update_table(self, data):
        """
        Updates the table according to the data passed. As the API is the source of truth,
        it is necessary to get the data from the API and only update fields that are blank
        in the database.

        Args:
            data(dict): The data to build the query.

        Returns:
            dict: The response of the mutation.

        """
        response = self._perform_mutation("", {})
        return response
