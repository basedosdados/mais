import argparse
import csv
import json
import pathlib


def from_json_to_csv(filepath):
    laws = json.load(open(filepath))

    with open(
        "bases/br_ba_feiradesantana_leis/output/leis.csv", "w", newline=""
    ) as csvfile:
        fieldnames = list(laws[0].keys())
        # remove `documento` porque essa url não é acessível publicamente
        fieldnames.remove("documento")

        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()

        for law in laws:
            # remove `documento` porque essa url não é acessível publicamente
            del law["documento"]
            writer.writerow(law)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Transforma leis.json em leis.csv.")
    parser.add_argument("filepath", type=pathlib.Path)

    args = parser.parse_args()
    from_json_to_csv(args.filepath)