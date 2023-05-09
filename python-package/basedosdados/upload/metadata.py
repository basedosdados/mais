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
from basedosdados.backend import Backend

import pwinput


class Metadata(Base):
    """
    Manage metadata in CKAN backend.
    """

    def __init__(self, dataset_id, table_id=None, base_url=None, **kwargs):
        super().__init__(**kwargs)

        self.table_id = table_id
        self.dataset_id = dataset_id

        # self.url_graphql = base_url or f"{self.base_url}/api/v1/graphql"
        # self.dataset_uuid = self._get_dataset_id_from_slug(dataset_slug=dataset_id)
        # if table_id is not None:
        #     self.table_uuid = self._get_table_id_from_slug(
        #         dataset_slug=dataset_id, table_slug=table_id
        #     )
        # else:
        #     self.table_uuid = None

    def create(
        self,
        if_exists: str = "raise",
        columns: list = None,
        partition_columns: list = None,
        force_columns: bool = False,
        table_only: bool = True,
    ) -> Metadata:
        """Create metadata based on the current version saved to CKAN database

        Args:
            if_exists (str): Optional. What to do if config exists
                * raise : Raises Conflict exception
                * replace : Replaces config file with most recent
                * pass : Do nothing
            columns (list): Optional.
                A `list` with the table columns' names.
            partition_columns(list): Optional.
                A `list` with the name of the table columns that partition the
                data.
            force_columns (bool): Optional.
                If set to `True`, overwrite CKAN's columns with the ones provi
                ded.
                If set to `False`, keep CKAN's columns instead of the ones pro
                vided.
            table_only (bool): Optional. If set to `True`, only `table_config.
                yaml` is created, even if there is no `dataset_config.yaml` fo
                r the correspondent dataset metadata. If set to `False`, both
                files are created if `dataset_config.yaml` doesn't exist yet.
                Defaults to `True`.

        Returns:
            Metadata: An instance of the `Metadata` class.

        Raises:
            FileExistsError: If the correspodent YAML configuration file alrea
            dy exists and `if_exists` is set to `"raise"`.
        """
        raise NotImplementedError()
