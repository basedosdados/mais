from google.cloud import bigquery
from google.oauth2 import service_account
import yaml
from jinja2 import Template
from pathlib import Path
import json
import csv

from google.api_core.exceptions import Conflict


class Base:
    def __init__(
        self,
        key_path="secrets/cli-admin.json",
        templates="src/templates",
        bucket="basedosdados",
        metadata_path="bases/",
    ):
        self.templates = Path(templates)
        self.metadata_path = Path(metadata_path)

        credentials = service_account.Credentials.from_service_account_file(
            key_path,
            scopes=["https://www.googleapis.com/auth/cloud-platform"],
        )
        self.client = bigquery.Client(
            credentials=credentials,
            project=credentials.project_id,
        )
        self.uri = f"gs://{bucket}" + "/staging/{dataset}/{table}/*"

    def load_yaml(self, file):

        try:
            return yaml.load(open(file, "r"), Loader=yaml.SafeLoader)
        except FileNotFoundError:
            return None

    def render_template(self, template_file, kargs):

        return Template((self.templates / template_file).open("r").read()).render(
            **kargs
        )


class Dataset(Base):
    def __init__(self, dataset_id, **kwargs):
        super().__init__(**kwargs)

        self.dataset_id = dataset_id
        self.dataset_folder = Path(self.metadata_path / self.dataset_id)
        self.dataset_config = self.load_yaml(
            self.metadata_path / dataset_id / "dataset_config.yaml"
        )

    def init(self, replace=False):

        # Create table folder
        try:
            self.dataset_folder.mkdir(exist_ok=replace)
        except FileExistsError:
            raise FileExistsError(
                f"Dataset {str(dataset_folder.stem)} folder does not exists. "
                "Set replace=True to replace current files."
            )

        for file in (Path(self.templates) / "dataset").glob("*"):

            if file.name in ["dataset_config.yaml"]:

                # Load and fill template
                template = Template(file.open("r").read()).render(
                    dataset_id=self.dataset_id
                )

                # Write file
                (self.dataset_folder / file.name).open("w").write(template)

        return self

    def create_dataset_ids(self, create_staging):

        dataset_ids = [f"{self.client.project}.{self.dataset_config['dataset_id']}"]

        if create_staging:
            dataset_ids.append(
                f"{self.client.project}.staging_{self.dataset_config['dataset_id']}"
            )

        return dataset_ids

    def setup_dataset_object(self, dataset_id):

        dataset = bigquery.Dataset(dataset_id)
        dataset.description = self.render_template(
            "dataset/dataset_description.txt", self.dataset_config
        )

        return dataset

    def create(self, create_staging=True, if_exists="raise"):

        # Set dataset_id to the ID of the dataset to create.
        dataset_ids = self.create_dataset_ids(create_staging)

        for ds_id in dataset_ids:

            # Construct a full Dataset object to send to the API.
            dataset = self.setup_dataset_object(ds_id)

            # Send the dataset to the API for creation, with an explicit timeout.
            # Raises google.api_core.exceptions.Conflict if the Dataset already
            # exists within the project.
            try:
                dataset = self.client.create_dataset(
                    dataset, timeout=30
                )  # Make an API request.

            except Conflict:

                if if_exists == "update":
                    self.update()

                else:
                    raise Exception(f"Dataset {ds_id} already exists.")

    def update(self, update_staging=True):

        # Set dataset_id to the ID of the dataset to create.
        dataset_ids = self.create_dataset_ids(update_staging)

        for ds_id in dataset_ids:

            # Construct a full Dataset object to send to the API.
            dataset = self.setup_dataset_object(ds_id)

            # Send the dataset to the API to update, with an explicit timeout.
            # Raises google.api_core.exceptions.Conflict if the Dataset already
            # exists within the project.
            dataset = self.client.update_dataset(
                dataset, fields=["description"], timeout=30
            )  # Make an API request.


class Table(Base):
    def __init__(self, table_id, dataset_id, **kwargs):
        super().__init__(**kwargs)

        self.table_id = table_id
        self.dataset_id = dataset_id
        self.dataset_folder = Path(self.metadata_path / self.dataset_id)
        self.table_folder = self.dataset_folder / table_id
        self.table_config = self.load_yaml(self.table_folder / "table_config.yaml")
        self.table_full_name = dict(
            staging=f"{self.client.project}.staging_{self.dataset_id}.{self.table_id}",
            prod=f"{self.client.project}.{self.dataset_id}.{self.table_id}",
        )

    def init(self, data_sample_path=None, replace=False):

        if not self.dataset_folder.exists():
            raise FileExistsError(
                f"Dataset folder {dataset_folder} folder does not exists. "
                "Create a dataset before adding tables."
            )

        # Create table folder
        try:
            self.table_folder.mkdir(exist_ok=replace)
        except FileExistsError:
            raise FileExistsError(
                f"Table folder already exists for {self.table_id}. "
                "Add --replace flag to replace current files."
            )

        if isinstance(data_sample_path, str):
            if data_sample_path.split(".")[-1] == "csv":

                columns = next(csv.reader(open(data_sample_path, "r")))

            else:
                raise NotImplementedError(
                    "Data sample just supports comma separated csv files"
                )
        else:
            columns = ["<column-name>"]

        for file in (Path(self.templates) / "table").glob("*"):

            if file.name in ["table_config.yaml", "publish.sql"]:

                # Load and fill template
                template = Template(file.open("r").read()).render(
                    table_id=self.table_id,
                    dataset_id=self.dataset_folder.stem,
                    project_id=self.client.project,
                    columns=columns,
                )

                # Write file
                (self.table_folder / file.name).open("w").write(template)

        return self

    def load_schema(self, mode="staging"):
        """Load schema from table_config.yaml"""

        json_path = self.table_folder / f"schema-{mode}.json"

        columns = self.table_config["columns"]

        if mode == "staging":
            columns = [c for c in columns if c["is_in_staging"]]

        json.dump(columns, (json_path).open("w"))

        return self.client.schema_from_json(str(json_path))

    def create(self, job_config_params=None):
        """
        Creates table in staging dataset
        """

        if job_config_params is None:

            job_config_params = dict(
                write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
                source_format=bigquery.SourceFormat.CSV,
                skip_leading_rows=1,
            )

        if isinstance(job_config_params, dict):

            job_config_params.update(
                dict(
                    schema=self.load_schema(),
                    destination_table_description=self.render_template(
                        "table/table_description.txt", self.table_config
                    ),
                )
            )

            job_config = bigquery.LoadJobConfig(**job_config_params)

        load_job = self.client.load_table_from_uri(
            self.uri.format(
                dataset=self.table_config["dataset_id"],
                table=self.table_config["table_id"],
            ),
            self.table_full_name["staging"],
            job_config=job_config,
        )

        load_job.result()

    def update(self, mode=["staging", "prod"]):

        if isinstance(mode, str):
            mode = [mode]

        for m, table_name in self.table_full_name.items():

            if m in mode:

                table = self.client.get_table(table_name)
                table.description = self.render_template(
                    "table/table_description.txt", self.table_config
                )
                table.schema = self.load_schema(mode)

                self.client.update_table(table, fields=["description", "schema"])

    def publish(self, if_exists="raise"):

        # TODO: check if all required fields are filled

        job_config = bigquery.QueryJobConfig(destination=self.table_full_name["prod"])

        sql = (self.table_folder / "publish.sql").open("r").read()

        if if_exists == "replace":
            self.delete(mode="prod")

        query_job = self.client.query(sql, job_config=job_config)
        query_job.result()  # Wait for the job to complete.

        self.update(mode=["prod"])

    def delete(self, mode):

        self.client.delete_table(self.table_full_name[mode])


if __name__ == "__main__":

    table = Table("test", "test", key_path="as")
    table.publish("replace")
