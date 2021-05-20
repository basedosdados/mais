from pydantic.class_validators import root_validator
import yaml
import sys
from pathlib import Path
from google.cloud import bigquery
import basedosdados as bd
import json
from cerberus import Validator
from pydantic import BaseModel, ValidationError, validator
from typing import List

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
BD_STD_COLUMNS_BY_NAME = {column["name"]: column for column in BD_STD_COLUMNS}

INV_FIELD = []


class Column_Model(BaseModel):
    name: str
    description: str
    is_in_staging: bool
    is_partition: bool

    @validator("name")
    def name_is_lower(cls, value, values):
        if not value.islower():
            INV_FIELD.append({"name": value})
            raise ValueError("should be all lower case")
        return value

    @validator("name")
    def no_spaces(cls, value, values):
        if " " in value:
            INV_FIELD.append({"name": value})
            raise ValueError("should not have spaces")
        return value

    @validator("description")
    def validate_std_description(cls, value, values):
        if INV_FIELD:
            values.update(INV_FIELD[-1])
            INV_FIELD.clear()
        is_std_col = BD_STD_COLUMNS_BY_NAME.get(values["name"])
        if is_std_col and value != is_std_col["description"]:
            raise ValueError("Standard column does not have standard descritpion")


class Columns(BaseModel):
    columns: List[Column_Model]


def validate_columns(yaml_path):
    with open(Path(yaml_path), "r") as f:
        config = yaml.load(f, Loader=yaml.SafeLoader)
    print(type(config["columns"]))
    columns = config["columns"]
    # columns = [
    #     {
    #         "name": "id_municipio",
    #         "description": "id do municipio",
    #         "is_in_staging": True,
    #         "is_partition": False,
    #     },
    #     {
    #         "name": "col1",
    #         "description": "col1 description",
    #         "is_in_staging": True,
    #         "is_partition": False,
    #     },
    # ]

    try:
        Columns(columns=columns)
    except ValidationError as e:
        print("Error: ", e)


# assert len(BD_STD_COLUMNS_BY_NAME) == len(BD_STD_COLUMNS), "duplicated columns defined as standard columns"
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
        std_col = BD_STD_COLUMNS_BY_NAME.get(self.document["name"])
        if std_col and value != std_col["description"]:
            self._error(field, "Standard column does not have standard description")


def validate_columns_from_str(path_to_yaml):
    schema = yaml.load(open("validation_schema.yaml", "r"), Loader=yaml.SafeLoader)
    config = yaml.load(open(Path(path_to_yaml), "r"), Loader=yaml.SafeLoader)
    config["columns"] = yaml.dump(
        config["columns"],
        line_break=False,
        sort_keys=False,
        default_flow_style=False,
        allow_unicode=True,
    )
    columns = config["columns"]
    v = MyValidator(schema=schema)

    if not v.validate({"columns": columns}):
        # print(columns)
        print(v.errors["columns"])


if __name__ == "__main__":
    validate_columns(yaml_path=sys.argv[1])
