import yaml
import sys
from pathlib import Path
from google.cloud import bigquery
import basedosdados as bd
import json
from cerberus import Validator

bd_standards = ["municipio", "escola", "setor_censitario", "uf"]
BD_STD_COLUMNS = []
### LOADS STANDARD COLUMNS FROM br_bd_diretorios_brasil
for std in bd_standards:
    with open(
        Path("/home")
        / "caio"
        / "base"
        / "bases"
        / "br_bd_diretorios_brasil"
        / std
        / "table_config.yaml",
        "r",
    ) as f:
        BD_STD_COLUMNS += yaml.load(f, Loader=yaml.SafeLoader)["columns"]

### Custom extensions to Cerberus Validator class
class MyValidator(Validator):
    ### Checks must be prefixed with _check_with for using it within the check_with schema keyword
    def _check_with_lowercase(self, field, value):
        if not value.islower():
            self._error(field, "Must be named all lowercase")

    def _check_with_nospaces(self, field, value):
        if " " in value:
            self._error(field, "Cannot have spaces")

    def _check_with_abbreviation(self, field, value):
        not_allowed_abbrev = ["qt", "tp", "cd"]
        for a in not_allowed_abbrev:
            if a in value:
                self._error(field, f"cannot contain abbreviations {not_allowed_abbrev}")

    def _check_with_coverage_geo(self, field, value):
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
        if not value.islower() and value not in allowed_upper:
            self._error(field, "Only allow uppercase for UF initials")

    def _check_with_update_frequency(self, field, value):
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
        if value not in allowed_update_freq:
            self._error(
                field, f"value not allowed. Allowed values are {allowed_update_freq}"
            )

    def _check_with_standard_columns(self, field, value):
        doc = self.root_document
        for st_col in BD_STD_COLUMNS:
            if doc["name"] == st_col["name"]:
                if value != st_col["description"]:
                    self._error(
                        field, "Standard column does not have standard description"
                    )


def validate_columns(path_to_yaml):
    schema = yaml.load(open("validation_schema.yaml", "r"), Loader=yaml.SafeLoader)
    config = yaml.load(open(Path(path_to_yaml), "r"), Loader=yaml.SafeLoader)
    columns = config["columns"]
    v = MyValidator(document=config, schema=schema)
    for column in columns:
        if not v.validate(column):
            print(column)
            print(v.errors)


if __name__ == "__main__":
    validate_columns(path_to_yaml=sys.argv[1])
