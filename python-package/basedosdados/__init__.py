"""
Importing the module will automatically import the submodules.
"""
# flake8: noqa
import os
import sys

from basedosdados._version import __version__
from basedosdados._warnings import show_warnings

show_warnings()

sys.path.append(f"{os.getcwd()}/python-package")

# pylint: disable=C0413

from basedosdados.backend import Backend
from basedosdados.constants import config, constants
from basedosdados.download.base import reauth
from basedosdados.download.download import download, read_sql, read_table
from basedosdados.download.metadata import (
    get_dataset_description,
    get_table_columns,
    get_table_description,
    get_table_size,
    list_dataset_tables,
    list_datasets,
    search,
)
from basedosdados.upload.connection import Connection
from basedosdados.upload.dataset import Dataset
from basedosdados.upload.storage import Storage
from basedosdados.upload.table import Table
