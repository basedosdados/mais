'''
Importing the module will automatically import the submodules.
'''


import sys
import os

sys.path.append(f"{os.getcwd()}/python-package")

#pylint: disable=C0413

from basedosdados.constants import constants, config
from basedosdados.upload.dataset import Dataset
from basedosdados.upload.storage import Storage
from basedosdados.upload.table import Table
from basedosdados.upload.metadata import Metadata
from basedosdados.download.base import reauth
from basedosdados.download.download import (
    read_sql,
    download,
    read_table,
)
from basedosdados.download.metadata import (
    list_datasets,
    list_dataset_tables,
    get_table_description,
    get_dataset_description,
    get_table_columns,
    get_table_size,
    search,
)
