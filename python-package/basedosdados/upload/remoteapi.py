"""
An interface to make mutations to the remote API.
"""

from datetime import datetime, date
import json
import re
import requests

from pathlib import Path
from tqdm import tqdm


class RemoteAPI:
    """
    Interface to make mutations to the remote API.
    """

    def __init__(self, api_url, token, graphql_path):
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

        data_dict = data_dict.copy()

        return None

    def create_table(self):
        pass

    def update_table(self):
        pass

    def create_dataset(self):
        pass

    def update_dataset(self):
        pass
