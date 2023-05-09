import pandas as pd
import basedosdados as bd
from basedosdados.upload.base import Base
from basedosdados.backend import Backend

from pathlib import Path
import json

from typing import Any, Dict, List, Optional, Tuple, Union


if __name__ == "__main__":
    # bs = Base()

    bk = Backend("https://staging.api.basedosdados.org/api/v1/graphql")
    # r = bk._get_dataset_id_from_slug(dataset_slug="br_sp_alesp")
    # print(r)
    # r = bk._get_table_id_from_slug(dataset_slug="br_sp_alesp", table_slug="deputado")
    # print(r)
    # r = bk.get_dataset_config(dataset_id="br_sp_alesp")
    # print(r)
    # r = bk.get_table_config(dataset_id="br_sp_alesp", table_id="deputado")
    # print(r)

    ds = bd.Dataset("br_sp_alesp")
    ds.create(if_exists="replace")

    tb = bd.Table(dataset_id="br_sp_alesp", table_id="deputado")
    tb.create(if_exists="replace")
