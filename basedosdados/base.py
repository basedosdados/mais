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
            self.config["gcloud-projects"][mode]["credentials_path"],
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
    def _input_validator(context, default=""):

        var = input(context)

        if var:
            return var.lower().strip()
        else:
            return default.lower().strip()

    def _selection_yn(
        self, first_question, default_yn, default_return, no_question, default_no=""
    ):

        while True:

            res = self._input_validator(first_question, default_yn)

            if res == "y":
                return default_return
            elif res == "n":
                return self._input_validator(no_question, default_no)
            else:
                print(f"{res} is not accepted as an awnser. Try y or n.\n")

    def _check_credentials(
        self,
        project_id,
        mode,
        credentials_path,
        credentials_url="https://console.cloud.google.com/apis/credentials/serviceaccountkey?project=",
    ):

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
            else:
                input(
                    "\nWe couldn't find it :( \nMake sure that the file has the following name:"
                    f"\n\n{mode} filename: {credentials_path}/{mode}.json"
                    "\n\n[Press enter to check if data is correctly saved]"
                )

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

            # Load config file
            c_file = tomlkit.parse(
                (Path(__file__).parent / "configs/config.toml").open("r").read()
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
            )

            c_file["metadata_path"] = str(Path(metadata_path) / "bases")

            ############# STEP 2 - CREDENTIALS PATH #######################

            credentials_path = Path.home() / ".basedosdados/credentials"
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

            ############# STEP 5 - PROD CREDS. #######################

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
