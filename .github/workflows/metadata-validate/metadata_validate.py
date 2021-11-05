import json
import os
import traceback
from pathlib import Path
from pprint import pprint

import basedosdados as bd
import yaml
from basedosdados import Dataset, Storage
from basedosdados.upload.base import Base
from basedosdados.upload.metadata import Metadata


def tprint(title=""):
    if not len(title):
        print(
            "\n",
            "#" * 80,
            "\n",
        )
    else:
        size = 38 - int(len(title) / 2)
        print("\n\n\n", "#" * size, title, "#" * size, "\n")


def load_configs(dataset_id, table_id):
    # get the config file in .basedosdados/config.toml
    configs_path = Base()._load_config()

    # get the path to metadata_path, where the folder bases with metadata information
    metadata_path = configs_path["metadata_path"]

    # get the path to table_config.yaml
    table_path = f"{metadata_path}/{dataset_id}/{table_id}"

    return (
        # load the table_config.yaml
        yaml.load(open(f"{table_path}/table_config.yaml", "r"), Loader=yaml.FullLoader),
        # return the path to .basedosdados configs
        configs_path,
    )


def get_table_dataset_id():
    # load the change files in PR || diff between PR and master
    changes = Path("files.json").open("r")
    changes = json.load(changes)

    # create a dict to save the dataset and source_bucket related to each table_id
    dataset_table_ids = {}

    # create a list to save the table folder path, for each table changed in the commit
    table_folders = []
    for change_file in changes:
        # get the directory path for a table with changes
        file_dir = Path(change_file).parent

        # append the table directory if it was not already appended
        if file_dir not in table_folders:
            table_folders.append(file_dir)

    # construct the iterable for the table_config paths
    table_config_paths = [Path(root / "table_config.yaml") for root in table_folders]

    # iterate through each config path
    for filepath in table_config_paths:

        # check if the table_config.yaml exists in the changed folder
        if filepath.is_file():

            # load the found table_config.yaml
            table_config = yaml.load(open(filepath, "r"), Loader=yaml.SafeLoader)

            # add the dataset and source_bucket for each table_id
            dataset_table_ids[table_config["table_id"]] = {
                "dataset_id": table_config["dataset_id"],
                "source_bucket_name": table_config["source_bucket_name"],
            }

    return dataset_table_ids


def metadata_validate():
    # find the dataset and tables of the PR
    dataset_table_ids = get_table_dataset_id()

    # print dataset tables info
    tprint("TABLES FOUND")
    pprint(dataset_table_ids)
    tprint()

    # iterate over each table in dataset of the PR
    for table_id in dataset_table_ids.keys():
        dataset_id = dataset_table_ids[table_id]["dataset_id"]
        source_bucket_name = dataset_table_ids[table_id]["source_bucket_name"]

        try:
            # push the table to bigquery
            md = Metadata(dataset_id=dataset_id, table_id=table_id)

            md.validate()
            tprint(f"SUCESS VALIDATE {dataset_id}.{table_id}")
            tprint()

        except Exception as error:
            tprint(f"ERROR ON {dataset_id}.{table_id}")
            traceback.print_exc()
            tprint()


if __name__ == "__main__":
    metadata_validate()
