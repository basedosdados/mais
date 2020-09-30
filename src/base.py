from google.cloud import bigquery, storage
import yaml
from jinja2 import Template
from pathlib import Path
import shutil
import tomlkit
import warnings

from functools import lru_cache

warnings.filterwarnings("ignore")


class Base:
    def __init__(
        self,
        config_path=".basedosdados",
        templates=None,
        bucket_name=None,
        metadata_path=None,
        overwrite_cli_config=False,
    ):

        self.config_path = Path.home() / config_path
        self._init_config(force=overwrite_cli_config)
        self.config = self._load_config()

        self.templates = Path(templates or self.config["templates_path"])
        self.metadata_path = Path(metadata_path or self.config["metadata_path"])
        self.bucket_name = bucket_name or self.config["bucket_name"]
        self.uri = f"gs://{self.bucket_name}" + "/staging/{dataset}/{table}/*"

    @property
    @lru_cache(256)
    def client(self):

        return dict(
            bigquery_prod=bigquery.Client(
                # credentials=self._load_credentials("prod"),
                project=self.config["gcloud-projects"]["prod"],
            ),
            bigquery_staging=bigquery.Client(
                # credentials=self._load_credentials("staging"),
                project=self.config["gcloud-projects"]["staging"],
            ),
            storage_staging=storage.Client(
                # credentials=self._load_credentials("staging"),
                project=self.config["gcloud-projects"]["staging"],
            ),
        )

    @property
    def main_vars(self):

        return dict(
            templates=self.templates,
            metadata_path=self.metadata_path,
            bucket_name=self.bucket_name,
        )

    @staticmethod
    def _input_validator(context, default):

        var = input(context)

        if var:
            return var
        else:
            return default

    def _init_config(self, force):

        # Create config folder
        self.config_path.mkdir(exist_ok=True, parents=True)

        config_file = self.config_path / "config.toml"
        if (not config_file.exists()) or (force):

            input(
                "\n\nApparently, that is the first time that you are using "
                "basedosdados :)\n"
                "Before you go, we need to setup your workspace.\n"
                "It will not take long, I promise!\n"
                "[press enter to continue]"
            )

            c_file = tomlkit.parse(
                (Path(__file__).parent / "configs/config.toml").open("r").read()
            )

            while True:
                res = (
                    input(
                        "\n********* STEP 1 **********\n"
                        "Where are you going to save the configuration files of "
                        "datasets and tables?\n"
                        f"Is it at the current path ({Path.cwd()})? [Y/n]\n"
                    )
                    .lower()
                    .strip()
                )

                if res == "y":

                    metadata_path = Path.cwd()
                    break
                elif res == "n":
                    metadata_path = input("\nWhere would you like to save it:\n")

                    break
                else:
                    print(f"{res} is not accepted as an awnser. Try y or n.\n")

            # print(f"\nMetadata path is set to {metadata_path}!")
            c_file["metadata_path"] = str(metadata_path / "bases")

            input(
                "\n********* STEP 2 **********\n"
                "Make sure that you have gsutil intalled in your computer.\n"
                "Instructions to install it: https://cloud.google.com/storage/docs/gsutil_install\n"
                "[press enter to continue]"
            )

            input(
                "\n********* STEP 3 **********\n"
                "Once gsutil is installed, run the command: \n"
                "`gcloud auth application-default login` \n"
                "[press enter to continue]"
            )

            project_staging = self._input_validator(
                "\n********* STEP 4 **********\n"
                "What is the Google Cloud Project that you are going to be using "
                "to upload and treat data? It might be something with 'staging'"
                "in the name. If you just have one project, put its name.\n"
                "Project id [basedosdados-staging]: ",
                "basedosdados-staging",
            )

            res = (
                input(
                    "\n********* STEP 5 **********\n"
                    "Is your production project the same as the staging? [y/n]\n"
                )
                .strip()
                .lower()
            )

            while True:
                if res == "y":
                    print("Great!")
                    project_prod = project_staging
                    break
                elif res == "n":
                    project_prod = self._input_validator(
                        "What is the production Google Cloud Project then?\n"
                        "Project id [basedosdados]: ",
                        "basedosdados",
                    )
                    break
                else:
                    print(f"{res} is not accepted as an awnser. Try y or n.\n")

            bucket_name = self._input_validator(
                "\n********* STEP 6 **********\n"
                "What is the Storage Bucket that you are going to be using to save the data?\n"
                "Bucket name [basedosdados]: ",
                "basedosdados",
            )

            c_file["gcloud-projects"]["staging"] = project_staging
            c_file["gcloud-projects"]["prod"] = project_prod
            c_file["bucket_name"] = project_prod
            c_file["templates_path"] = str(self.config_path / "templates")

            config_file.open("w").write(tomlkit.dumps(c_file))

    def _load_config(self):

        return tomlkit.parse(
            (Path.home() / ".basedosdados" / "config.toml").open("r").read()
        )

    def _load_yaml(self, file):

        try:
            return yaml.load(open(file, "r"), Loader=yaml.SafeLoader)
        except FileNotFoundError:
            return None

    def _render_template(self, template_file, kargs):

        return Template((self.templates / template_file).open("r").read()).render(
            **kargs
        )

    def _check_mode(self, mode):
        ACCEPTED_MODES = ["all", "staging", "prod"]
        if mode in ACCEPTED_MODES:
            return True
        else:
            raise Exception(
                f"Argument {mode} not supported. "
                f"Enter one of the following: "
                f'{",".join(ACCEPTED_MODES)}'
            )

    def _refresh_templates(self):
        shutil.rmtree((self.config_path / "templates"))
        shutil.copytree(
            (Path(__file__).parent / "configs" / "templates"),
            (self.config_path / "templates"),
        )