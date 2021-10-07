# ----------------------------------------------------------
# Partially written by github.com/jptbrandao
# ----------------------------------------------------------

import csv
from pathlib import Path

import arrow
import yaml


def get_next_update(last_updated, update_frequency):
    elements = update_frequency.split(" ")

    if len(elements) < 2:
        qty = 1
        timespan = elements[0].lower()
    else:
        qty = int(elements[0])
        timespan = elements[1].lower()

    if timespan == "hora":
        return last_updated

    if timespan == "dia":
        return last_updated.shift(days=+qty)

    if timespan == "semana":
        return last_updated.shift(weeks=+qty)

    if timespan == "mês" or timespan == "mes":
        return last_updated.shift(months=+qty)

    if timespan == "ano":
        return last_updated.shift(years=+qty)

    if timespan == "recorrente":
        return last_updated.shift(months=+3)  # default value is 3 months

    # shouldn't reach here. Should raise error
    return last_updated.shift(years=+999)


def check_table(yaml_filepath):
    report = {}

    with open(yaml_filepath, "r") as yaml_file:
        yaml_dictionary = yaml.full_load(yaml_file)

        field = yaml_dictionary.get("dataset_id", None)
        if field == None:
            return None
        report["dataset_id"] = field

        field = yaml_dictionary.get("table_id", None)
        if field == None:
            return None
        report["table_id"] = field

        field = yaml_dictionary.get("data_update_frequency", None)
        if field == None:
            return None
        report["frequency"] = field

        field = yaml_dictionary.get("last_updated", None)
        if field == None:
            return None
        last_updated = arrow.get(field)
        report["last_update"] = last_updated.format("YYYY-MM-DD")

        next_update = get_next_update(last_updated, report["frequency"])

        report["next_update"] = next_update.format("YYYY-MM-DD")
        report["flag"] = 1 if next_update <= arrow.now() else 0

    return report


def check_datasets(directory, querystring, outpath):
    directory = Path(directory)

    with open(outpath, "w") as file:
        author = csv.writer(file, delimiter=",")
        author.writerow(
            [
                "dataset_id",
                "table_id",
                "frequency",
                "last_update",
                "next_update",
            ]
        )

        for filepath in directory.glob(querystring):
            datum = check_table(filepath)
            if datum["flag"]:
                author.writerow(list(datum.values())[:-1])


if __name__ == "__main__":
    check_datasets("../../../bases", "**/table_config.yaml", "report.csv")
