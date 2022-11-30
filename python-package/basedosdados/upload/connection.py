"""
Module for managing BigQuery Connections.
"""
# pylint: disable=line-too-long, fixme, invalid-name,line-too-long,unnecessary-lambda-assignment

from typing import Union

import google.auth
from google.cloud import bigquery_connection_v1
from google.cloud.bigquery_connection_v1.types import CloudResourceProperties
from google.cloud.bigquery_connection_v1.types.connection import Connection

from basedosdados.upload.base import Base

class Connection(Base):
    """
    Manages BigQuery Connections.
    """

    def __init__ (
        self,
        name: str,
        location: str = None,
        mode: str = "staging",
        friendly_name: str = None,
        description: str = None,
        **kwargs
    ):
        super().__init__(**kwargs)
        self._name = name
        self._location = location or "US"
        self._mode = mode
        self._friendly_name = friendly_name
        self._description = description
        self._project = self.config['gcloud-projects'][self._mode]['name']
        self._parent = f"projects/{self._project}/locations/{self._location}"

    @property
    def exists(self) -> bool:
        """
        Checks if connection exists.
        """
        if self.connection:
            return True
        return False

    @property
    def connection(self) -> Union[Connection, None]:
        """
        Returns connection object.
        """
        client = self.client[f"bigquery_connection_{self._mode}"]
        request = bigquery_connection_v1.GetConnectionRequest(
            name=f"{self._parent}/connections/{self._name}"
        )
        try:
            return client.get_connection(request=request)
        except google.api_core.exceptions.NotFound:
            return None
        except Exception as e:
            raise e

    @property
    def connection_id(self) -> str:
        """
        Returns the connection id. The format is:
        <project_number>.<location>.<connection_name>
        """
        project_number = self._get_project_number(self._mode)
        return f"{project_number}.{self._location.lower()}.{self._name}"

    def create(self):
        """
        Creates a new connection.
        """
        client = self.client[f"bigquery_connection_{self._mode}"]
        request = bigquery_connection_v1.CreateConnectionRequest(
            parent=self._parent,
            connection_id=self._name,
            connection=bigquery_connection_v1.Connection(
                name=self._name,
                friendly_name=self._friendly_name or self._name,
                description=self._description or self._name,
                cloud_resource=CloudResourceProperties(),
            )
        )
        client.create_connection(request=request)
    
    def delete(self):
        """
        Deletes a connection.
        """
        client = self.client[f"bigquery_connection_{self._mode}"]
        request = bigquery_connection_v1.DeleteConnectionRequest(
            name=f"{self._parent}/connections/{self._name}"
        )
        client.delete_connection(request=request)