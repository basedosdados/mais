from google.cloud import bigquery, storage
from google.oauth2 import service_account
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

    def _load_credentials(self, mode):

        return service_account.Credentials.from_service_account_file(
            self.config["gcloud-projects"][mode]["credentials_path"] + f"/{mode}.json",
            scopes=["https://www.googleapis.com/auth/cloud-platform"],
        )

    @property
    @lru_cache(256)
    def client(self):

        return dict(
            bigquery_prod=bigquery.Client(
                credentials=self._load_credentials("prod"),
                project=self.config["gcloud-projects"]["prod"]["name"],
            ),
            bigquery_staging=bigquery.Client(
                credentials=self._load_credentials("staging"),
                project=self.config["gcloud-projects"]["staging"]["name"],
            ),
            storage_staging=storage.Client(
                credentials=self._load_credentials("staging"),
                project=self.config["gcloud-projects"]["staging"]["name"],
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

        # Create credentials folder
        credentials_folder = Path.home() / self.config_path / "credentials"
        credentials_folder.mkdir(exist_ok=True, parents=True)

        # Create template folder
        self._refresh_templates()

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
                if res == "":
                    res = "y"

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

            while True:
                credential_path_staging = f"{Path.home()}/.basedosdados/credentials"
                credentials_url_staging = f"https://console.cloud.google.com/apis/credentials/serviceaccountkey?project={project_staging}"
                res = (
                    input(
                        "\n********* STEP 5 **********\n"
                        f"Save the JSON credential with the name staging.json from the link {credentials_url_staging}"
                        " in the path of your choice. "
                        f"Is it at the current path ({credential_path_staging})? [Y/n]\n"
                    )
                    .lower()
                    .strip()
                )

                if res == "":
                    res = "y"

                if res == "y":
                    credential_path_staging = credential_path_staging
                    break
                elif res == "n":
                    credential_path_staging = input(
                        "\nWhere would you like to save it:\n"
                    )

                    break
                else:
                    print(f"{res} is not accepted as an awnser. Try y or n.\n")

            c_file["gcloud-projects"]["staging"]["credentials_path"] = str(
                credential_path_staging
            )

            res = (
                input(
                    "\n********* STEP 6 **********\n"
                    "Is your production project the same as the staging? [y/N]\n"
                )
                .strip()
                .lower()
            )

            if res == "":
                res = "n"

            bucket_name = self._input_validator(
                "\n********* STEP 7 **********\n"
                "What is the Storage Bucket that you are going to be using to save the data?\n"
                "Bucket name [basedosdados]: ",
                "basedosdados",
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

            while True:
                credential_path_prod = f"{Path.home()}/.basedosdados/credentials"
                credentials_url_prod = f"https://console.cloud.google.com/apis/credentials/serviceaccountkey?project={project_prod}"
                res = (
                    input(
                        "\n********* STEP 8 **********\n"
                        f"Save the JSON credential with the name prod.json from the link {credentials_url_prod}"
                        " in the path of your choice. "
                        f"Is it at the current path ({credential_path_prod})? [Y/n]\n"
                    )
                    .lower()
                    .strip()
                )

                if res == "":
                    res = "y"

                if res == "y":
                    credential_path_prod = credential_path_prod
                    break
                elif res == "n":
                    credential_path_prod = input("\nWhere would you like to save it:\n")

                    break
                else:
                    print(f"{res} is not accepted as an awnser. Try y or n.\n")

            c_file["gcloud-projects"]["prod"]["credentials_path"] = str(
                credential_path_prod
            )

            c_file["gcloud-projects"]["staging"]["name"] = project_staging
            c_file["gcloud-projects"]["prod"]["name"] = project_prod
            c_file["bucket_name"] = project_prod
            c_file["templates_path"] = f"{Path.home()}/.basedosdados/templates"

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
        shutil.rmtree((self.config_path / "templates"), ignore_errors=True)
        shutil.copytree(
            (Path(__file__).parent / "configs" / "templates"),
            (self.config_path / "templates"),
        )
