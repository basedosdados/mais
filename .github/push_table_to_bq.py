import basedosdados as bd
from basedosdados.base import Base
import yaml


def load_configs(dataset_id, table_id):
    configs_path = Base()._load_config()
    metadata_path = configs_path["metadata_path"]
    table_path = f"{metadata_path}/{dataset_id}/{table_id}"
    return yaml.load(
        open(f"{table_path}/table_config.yaml", "r"), Loader=yaml.FullLoader
    )


def is_partitioned(table_config):
    return table_config["partitions"] is not None


def push_table_to_bq(dataset_id, table_id):
    table_config = load_configs(dataset_id, table_id)

    tb = bd.Table(dataset_id, table_id)

    tb.create(
        partitioned=is_partitioned(table_config),
        storage_data=True,
        if_exists="pass",
    )

    tb.publish(if_exists="replace")