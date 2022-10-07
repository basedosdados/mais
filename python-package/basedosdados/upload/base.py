"""
Module for manage dataset using local credentials and config files
"""
# pylint: disable=line-too-long, invalid-name, too-many-arguments, invalid-envvar-value,line-too-long
from pathlib import Path
import sys
from os import getenv
import shutil
import warnings
import base64
import json
from functools import lru_cache

from google.cloud import bigquery, storage
from google.oauth2 import service_account
from loguru import logger
import yaml
from jinja2 import Template
import tomlkit

from basedosdados.constants import config, constants

warnings.filterwarnings("ignore")


class Base:
    """
    Base class for all datasets
    """

    def __init__(
        self,
        config_path=".basedosdados",
        templates=None,
        bucket_name=None,
        metadata_path=None,
        overwrite_cli_config=False,
    ):
        """
        Initialize the class
        """
        # standard config_path configuration
        config_path = (
            Path(config.project_config_path)
            if config.project_config_path is not None
            else Path.home() / config_path
        )

        self.config_path =  config_path
        self._init_config(force=overwrite_cli_config)
        self.config = self._load_config()
        self._config_log(config.verbose)

        self.templates = Path(templates or self.config["templates_path"])
        self.metadata_path = Path(metadata_path or self.config["metadata_path"])
        self.bucket_name = bucket_name or self.config["bucket_name"]
        self.uri = f"gs://{self.bucket_name}" + "/staging/{dataset}/{table}/*"

    @staticmethod
    def _decode_env(env: str) -> str:
        """
        Decode environment variable
        """
        return base64.b64decode(getenv(env).encode("utf-8")).decode("utf-8")

    def _load_credentials(self, mode: str):
        """
        Load credentials from config file
        """

        if getenv(f"{constants.ENV_CREDENTIALS_PREFIX.value}{mode.upper()}"):
            info = json.loads(
                self._decode_env(
                    f"{constants.ENV_CREDENTIALS_PREFIX.value}{mode.upper()}"
                )
            )
            return service_account.Credentials.from_service_account_info(
                info, scopes=["https://www.googleapis.com/auth/cloud-platform"]
            )

        return service_account.Credentials.from_service_account_file(
            self.config["gcloud-projects"][mode]["credentials_path"],
            scopes=["https://www.googleapis.com/auth/cloud-platform"],
        )

    @property
    @lru_cache(256)
    def client(self):
        """
        Client for BigQuery
        """

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
        """
        Variables for main templates
        """
        return dict(
            templates=self.templates,
            metadata_path=self.metadata_path,
            bucket_name=self.bucket_name,
        )

    @staticmethod
    def _input_validator(context, default="", with_lower=True):
        """
        Validate input
        """

        var = input(context)

        def to_lower(x):
            return x.lower() if with_lower else x

        if var:
            return to_lower(var.strip())

        return to_lower(default.strip())

    def _selection_yn(
        self,
        first_question,
        default_yn,
        default_return,
        no_question,
        default_no="",
        with_lower=True,
    ):
        """
        Selection with yes/no
        """

        while True:

            res = self._input_validator(first_question, default_yn, with_lower)

            if res == "y":
                return default_return

            if res == "n":
                return self._input_validator(no_question, default_no, with_lower)

            print(f"{res} is not accepted as an awnser. Try y or n.\n")

    @staticmethod
    def _check_credentials(
        project_id,
        mode,
        credentials_path,
        credentials_url="https://console.cloud.google.com/apis/credentials/serviceaccountkey?project=",
    ):
        """
        Check if credentials are valid
        """

        input(
            f"1. Go to the following link: {credentials_url}{project_id}\n"
            "2. Create a service account\n"
            "3. Select the Key type as JSON\n"
            "4. Hit CREATE\n"
            f"5. Now, save the json file in {credentials_path} as {mode}.json\n\n"
            f"{mode} filename: {credentials_path}/{mode}.json"
            "\n\n[Press enter to check if data is correctly saved]"
        )

        while True:
            if (credentials_path / f"{mode}.json").exists():
                print("We found it :)")
                break
            input(
                "\nWe couldn't find it :( \nMake sure that the file has the following name:"
                f"\n\n{mode} filename: {credentials_path}/{mode}.json"
                "\n\n[Press enter to check if data is correctly saved]"
            )

    def _init_config(self, force):
        """
        Initialize config file
        """

        # Create config folder
        self.config_path.mkdir(exist_ok=True, parents=True)

        config_file = self.config_path / "config.toml"

        # Create credentials folder
        credentials_folder = self.config_path / "credentials"
        credentials_folder.mkdir(exist_ok=True, parents=True)

        # Create template folder
        self._refresh_templates()

        # If environments are set but no files exist
        if (
            (not config_file.exists())
            and (getenv(constants.ENV_CONFIG.value))
            and (getenv(constants.ENV_CREDENTIALS_PROD.value))
            and (getenv(constants.ENV_CREDENTIALS_STAGING.value))
        ):
            # Create basedosdados files from envs
            with open(config_file, "w", encoding="utf-8") as f:
                f.write(self._decode_env(constants.ENV_CONFIG.value))
                f.close()
            with open(credentials_folder / "prod.json", "w", encoding="utf-8") as f:
                f.write(self._decode_env(constants.ENV_CREDENTIALS_PROD.value))
                f.close()
            with open(credentials_folder / "staging.json", "w", encoding="utf-8") as f:
                f.write(self._decode_env(constants.ENV_CREDENTIALS_STAGING.value))
                f.close()

        if (not config_file.exists()) or (force):

            # Load config file
            c_file = tomlkit.parse(
                (Path(__file__).resolve().parents[1] / "configs" / "config.toml")
                .open("r", encoding="utf-8")
                .read()
            )

            input(
                "\n\nApparently, that is the first time that you are using "
                "basedosdados :)\n"
                "Before you go, we need to setup your workspace.\n"
                "It will not take long, I promise!\n"
                "[press enter to continue]"
            )

            ############# STEP 1 - METADATA PATH #######################

            metadata_path = self._selection_yn(
                first_question=(
                    "\n********* STEP 1 **********\n"
                    "Where are you going to save the metadata files of "
                    "datasets and tables?\n"
                    f"Is it at the current path ({Path.cwd()})? [Y/n]\n"
                ),
                default_yn="y",
                default_return=Path.cwd(),
                no_question=("\nWhere would you like to save it?\n" "metadata path: "),
                with_lower=False,
            )

            c_file["metadata_path"] = str(Path(metadata_path) / "bases")

            ############# STEP 2 - CREDENTIALS PATH ######################

            credentials_path = self.config_path / "credentials"
            credentials_path = Path(
                self._selection_yn(
                    first_question=(
                        "\n********* STEP 2 **********\n"
                        "Where do you want to save your Google Cloud credentials?\n"
                        f"Is it at the {credentials_path}? [Y/n]\n"
                    ),
                    default_yn="y",
                    default_return=credentials_path,
                    no_question=(
                        "\nWhere would you like to save it?\n" "credentials path: "
                    ),
                    with_lower=False,
                )
            )

            ############# STEP 3 - STAGING CREDS. #######################
            project_staging = self._input_validator(
                "\n********* STEP 3 **********\n"
                "What is the Google Cloud Project that you are going to use "
                "to upload and treat data?\nIt might be something with 'staging'"
                "in the name. If you just have one project, put its name.\n"
                "Project id [basedosdados-staging]: ",
                "basedosdados-staging",
            )

            self._check_credentials(project_staging, "staging", credentials_path)

            c_file["gcloud-projects"]["staging"]["credentials_path"] = str(
                credentials_path / "staging.json"
            )
            c_file["gcloud-projects"]["staging"]["name"] = project_staging

            ############# STEP 4 - PROD CREDS. #######################

            project_prod = self._selection_yn(
                first_question=(
                    "\n********* STEP 4 **********\n"
                    "Is your production project the same as the staging? [y/N]\n"
                ),
                default_yn="n",
                default_return=project_staging,
                no_question=(
                    "What is the production Google Cloud Project then?\n"
                    "Project id [basedosdados]: "
                ),
                default_no="basedosdados",
            )
            # skip credentials with project staging is the same
            if project_prod == project_staging:
                shutil.copy(
                    (credentials_path / "staging.json"),
                    (credentials_path / "prod.json"),
                )
            else:
                self._check_credentials(project_prod, "prod", credentials_path)

            c_file["gcloud-projects"]["prod"]["credentials_path"] = str(
                credentials_path / "prod.json"
            )
            c_file["gcloud-projects"]["prod"]["name"] = project_prod

            ############# STEP 5 - BUCKET NAME #######################

            bucket_name = self._input_validator(
                "\n********* STEP 5 **********\n"
                "What is the Storage Bucket that you are going to be using to save the data?\n"
                "Bucket name [basedosdados]: ",
                "basedosdados",
            )

            c_file["bucket_name"] = bucket_name

            ############# STEP 6 - SET TEMPLATES #######################

            c_file["templates_path"] = str(self.config_path / "templates")

            config_file.open("w", encoding="utf-8").write(tomlkit.dumps(c_file))

    @staticmethod
    def _config_log(verbose: bool):
        """
        Logging configuration
        """
        logger.remove()  # remove o default handler
        logger_level = "INFO" if verbose else "ERROR"
        logger.add(
            sys.stderr,
            level=logger_level,
            format="<green>{time:YYYY-MM-DD HH:mm:ss.SSS}</green> | <level>{level: <8}</level> | <cyan>{name}</cyan>:<cyan>{function}</cyan>:<cyan>{line}</cyan> - <level>{message}</level>",
        )

    def _load_config(self):
        """
        Loads the configuration file
        """

        if getenv(constants.ENV_CONFIG.value):
            return tomlkit.parse(self._decode_env(constants.ENV_CONFIG.value))
        return tomlkit.parse(
            (self.config_path / "config.toml")
            .open("r", encoding="utf-8")
            .read()
        )

    @staticmethod
    def _load_yaml(file):
        """
        Loads a yaml file
        """

        try:
            return yaml.load(open(file, "r", encoding="utf-8"), Loader=yaml.SafeLoader)
        except FileNotFoundError:
            return None

    def _render_template(self, template_file, kargs):
        """
        Render a template file
        """

        return Template(
            (self.templates / template_file).open("r", encoding="utf-8").read()
        ).render(**kargs)

    @staticmethod
    def _check_mode(mode):
        """
        Checks if the mode is valid
        """
        ACCEPTED_MODES = [
            "all",
            "staging",
            "prod",
            "raw",
            "header",
            "auxiliary_files",
            "architecture",
        ]
        if mode in ACCEPTED_MODES:
            return True

        raise Exception(
            f"Argument {mode} not supported. "
            f"Enter one of the following: "
            f'{",".join(ACCEPTED_MODES)}'
        )

    def _refresh_templates(self):
        """
        Refreshes the templates
        """
        shutil.rmtree((self.config_path / "templates"), ignore_errors=True)
        shutil.copytree(
            (Path(__file__).resolve().parents[1] / "configs" / "templates"),
            (self.config_path / "templates"),
        )
