import yaml
from pathlib import Path
from google.cloud import bigquery
import basedosdados as bd
import json


bd_standards = ["municipio", "escola", "setor_censitario", "uf"]
BD_STD_COLUMNS = []
for std in bd_standards:
    BD_STD_COLUMNS += yaml.load(
        open(
            Path("..")
            / "bases"
            / "br_bd_diretorios_brasil"
            / std
            / "table_config.yaml",
            "r",
        ),
        Loader=yaml.SafeLoader,
    )["columns"]


def get_changes():
    changes = json.load(Path("/github/workspace/files.json").open("r"))
    print(changes)
    table_folders = []
    for change_file in changes:
        ### get the directory path for a table with changes
        file_dir = Path(change_file).parent
        ### append the table directory if it was not already appended
        if file_dir not in table_folders:
            table_folders.append(file_dir)
    ### construct the iterable for the table_config paths
    table_config_paths = [Path(root / "table_config.yaml") for root in table_folders]

    metadata_files = [
        table_config
        for table_config in table_config_paths
        if Path(table_config).is_file()
    ]

    return metadata_files


def check_no_description(change_path):

    change_file = yaml.load(open(Path(change_path), "r"), Loader=yaml.SafeLoader)

    ### check if any description is empty
    for column in change_file["columns"]:
        try:
            assert column["description"] is not None
        except Exception as e:
            print(column["name"], "have no description")
            raise (e)


def check_table_dataset_id(change_path):

    change_file = yaml.load(open(Path(change_path), "r"), Loader=yaml.SafeLoader)
    ###load table identifiers
    dataset_id = change_file["dataset_id"]
    table_id = change_file["table_id"]
    project_id_prod = change_file["project_id_prod"]
    ### check if table is published with the dataset_id/table_id in table_config.yaml
    try:
        bd.table.Table(table_id, dataset_id).client["bigquery_prod"].get_table(
            f"{project_id_prod}.{dataset_id}.{table_id}"
        )
    except Exception:
        raise FileNotFoundError(
            "dataset_id and table_id don't match a BigQuery table for your project"
        )


def check_standard_columns(change_path):

    change_file = yaml.load(open(Path(change_path), "r"), Loader=yaml.SafeLoader)

    for column in change_file["columns"]:
        for std_column in BD_STD_COLUMNS:
            if column["name"] == std_column["name"]:
                try:
                    assert column["description"] == std_column["description"]
                except Exception:
                    print(column["name"])
                    print(
                        "Your table have a standardized column but description does not match"
                    )


def check_column_names(change_path):

    change_file = yaml.load(open(Path(change_path), "r"), Loader=yaml.SafeLoader)

    for column in change_file["columns"]:
        try:
            assert column["name"].islower()
            assert not " " in column["name"]
        except Exception as e:
            raise e


def check_abbreviation(change_path):

    change_file = yaml.load(open(Path(change_path), "r"), Loader=yaml.SafeLoader)

    not_allowed_abbrev = ["qt", "tp", "cd"]

    for column in change_file["columns"]:
        for abbrev in not_allowed_abbrev:
            try:
                assert not abbrev in column["name"]
            except Exception:
                print(column["name"], "has abbreviation which are not allowed")


def check_update_frequency(change_path):

    change_file = yaml.load(open(Path(change_path), "r"), Loader=yaml.SafeLoader)

    allowed_update_freq = [
        "hora",
        "dia",
        "semana",
        "mês",
        "1 ano",
        "2 anos",
        "5 anos",
        "10 anos",
        "único",
        "recorrente",
    ]

    try:
        assert change_file["data_update_frequency"] in allowed_update_freq
    except Exception as e:
        raise e


def check_coverage(change_path):

    change_file = yaml.load(open(Path(change_path), "r"), Loader=yaml.SafeLoader)

    allowed_upper = [
        "RO",
        "AC",
        "AM",
        "RR",
        "PA",
        "AP",
        "TO",
        "MA",
        "PI",
        "CE",
        "RN",
        "PB",
        "PE",
        "AL",
        "SE",
        "BA",
        "MG",
        "ES",
        "RJ",
        "SP",
        "PR",
        "SC",
    ]

    try:
        for field in change_file["coverage_geo"]:
            if field not in allowed_upper:
                assert str(field).islower()
    except Exception as e:
        raise e


def main():

    metadata_files = get_changes()

    check_files = [file_path for file_path in metadata_files]

    checks = [
        check_abbreviation,
        check_coverage,
        check_no_description,
        check_standard_columns,
        check_column_names,
        check_table_dataset_id,
        check_update_frequency,
    ]

    for file in check_files:
        for check in checks:
            check(file)


if __name__ == "__main__":
    main()
