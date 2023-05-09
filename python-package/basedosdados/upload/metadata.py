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

        self.url_graphql = base_url or f"{self.base_url}/api/v1/graphql"
        self.dataset_uuid = self._get_dataset_id_from_slug(dataset_slug=dataset_id)
        if table_id is not None:
            self.table_uuid = self._get_table_id_from_slug(
                dataset_slug=dataset_id, table_slug=table_id
            )
        else:
            self.table_uuid = None
