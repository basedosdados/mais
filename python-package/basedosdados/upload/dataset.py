from pathlib import Path
from google.cloud import bigquery

from google.api_core.exceptions import Conflict

from basedosdados.upload.base import Base
from basedosdados.upload.metadata import Metadata


class Dataset(Base):
    """
    Manage datasets in BigQuery.
    """

    def __init__(self, dataset_id, **kwargs):
        super().__init__(**kwargs)

        self.dataset_id = dataset_id.replace("-", "_")
        self.dataset_folder = Path(self.metadata_path / self.dataset_id)
        self.metadata = Metadata(self.dataset_id, **kwargs)

    @property
    def dataset_config(self):

        return self._load_yaml(
            self.metadata_path / self.dataset_id / "dataset_config.yaml"
        )

    def _loop_modes(self, mode="all"):

        mode = ["prod", "staging"] if mode == "all" else [mode]
        dataset_tag = lambda m: f"_{m}" if m == "staging" else ""

        return (
            {
                "client": self.client[f"bigquery_{m}"],
                "id": f"{self.client[f'bigquery_{m}'].project}.{self.dataset_id}{dataset_tag(m)}",
            }
            for m in mode
        )

    def _setup_dataset_object(self, dataset_id):

        dataset = bigquery.Dataset(dataset_id)
        dataset.description = self._render_template(
            Path("dataset/dataset_description.txt"), self.dataset_config
        )

        return dataset
    
    def _write_readme_file(self):
        
        readme_content = (
            f"Como capturar os dados de {self.dataset_id}?\n\nPara cap"
            f"turar esses dados, basta verificar o link dos dados orig"
            f"inais indicado em dataset_config.yaml no item website.\n"
            f"\nCaso tenha sido utilizado algum código de captura ou t"
            f"ratamento, estes estarão contidos em code/. Se o dado pu"
            f"blicado for em sua versão bruta, não existirá a pasta co"
            f"de/.\n\nOs dados publicados estão disponíveis em: https:"
            f"//basedosdados.org/dataset/{self.dataset_id.replace('_','-')}"
        )

        readme_path = Path(
            self.metadata_path / self.dataset_id / 'README.md'
        )

        with open(readme_path, "w") as readmefile:
            readmefile.write(readme_content)
    
    def _build_dataset_description(self):
        
        metadata = self.metadata.local_metadata
        description = (
            f"""{metadata.get('description')}

            Para saber mais acesse:
            Website: {metadata.get('url_ckan')}
            Github: https://github.com/basedosdados/mais/

            Ajude a manter o projeto :)
            Apoia-se: https://apoia.se/basedosdados

            Instituição (Quem mantém os dados oficiais?)
            -----------
            Nome: {metadata.get('organization')}
            """
        )
        
        return description

    def init(self, replace=False):
        """Initialize dataset folder at metadata_path at `metadata_path/<dataset_id>`.

        The folder should contain:

        * `dataset_config.yaml`
        * `README.md`

        Args:
            replace (str): Optional. Whether to replace existing folder.

        Raises:
            FileExistsError: If dataset folder already exists and replace is False
        """

        # Create dataset folder
        try:
            self.dataset_folder.mkdir(exist_ok=replace, parents=True)
        except FileExistsError:
            raise FileExistsError(
                f"Dataset {str(self.dataset_folder.stem)} folder does not exists. "
                "Set replace=True to replace current files."
            )

        # create dataset_config.yaml with metadata
        self.metadata.create(if_exists="replace")

        # create README.md file
        self._write_readme_file()

        # Add code folder
        (self.dataset_folder / "code").mkdir(exist_ok=replace, parents=True)

        return self

    def publicize(self, mode="all"):
        """Changes IAM configuration to turn BigQuery dataset public.

        Args:
            mode (bool): Which dataset to create [prod|staging|all].
        """

        for m in self._loop_modes(mode):

            dataset = m["client"].get_dataset(m["id"])
            entries = dataset.access_entries

            entries.extend(
                [
                    bigquery.AccessEntry(
                        role="roles/bigquery.dataViewer",
                        entity_type="iamMember",
                        entity_id="allUsers",
                    ),
                    bigquery.AccessEntry(
                        role="roles/bigquery.metadataViewer",
                        entity_type="iamMember",
                        entity_id="allUsers",
                    ),
                    bigquery.AccessEntry(
                        role="roles/bigquery.user",
                        entity_type="iamMember",
                        entity_id="allUsers",
                    ),
                ]
            )
            dataset.access_entries = entries

            m["client"].update_dataset(dataset, ["access_entries"])

    def create(self, mode="all", if_exists="raise"):
        """Creates BigQuery datasets given `dataset_id`.

        It can create two datasets:

        * `<dataset_id>` (mode = 'prod')
        * `<dataset_id>_staging` (mode = 'staging')

        If `mode` is all, it creates both.

        Args:
            mode (str): Optional. Which dataset to create [prod|staging|all].
            if_exists (str): Optional. What to do if dataset exists

                * raise : Raises Conflict exception
                * replace : Drop all tables and replace dataset
                * update : Update dataset description
                * pass : Do nothing

        Raises:
            Warning: Dataset already exists and if_exists is set to `raise`
        """

        if if_exists == "replace":
            self.delete(mode)
        elif if_exists == "update":

            self.update()
            return

        # Set dataset_id to the ID of the dataset to create.
        for m in self._loop_modes(mode):

            # Construct a full Dataset object to send to the API.
            dataset_obj = self._setup_dataset_object(m["id"])

            # Send the dataset to the API for creation, with an explicit timeout.
            # Raises google.api_core.exceptions.Conflict if the Dataset already
            # exists within the project.
            try:
                job = m["client"].create_dataset(dataset_obj)  # Make an API request.
            except Conflict:

                if if_exists == "pass":
                    return
                else:
                    raise Conflict(f"Dataset {self.dataset_id} already exists")

        # Make prod dataset public
        self.publicize()

    def delete(self, mode="all"):
        """Deletes dataset in BigQuery. Toogle mode to choose which dataset to delete.

        Args:
            mode (str): Optional.  Which dataset to delete [prod|staging|all]
        """

        for m in self._loop_modes(mode):

            m["client"].delete_dataset(m["id"], delete_contents=True, not_found_ok=True)

    def update(self, mode="all"):
        """Update dataset description. Toogle mode to choose which dataset to update.

        Args:
            mode (str): Optional. Which dataset to update [prod|staging|all]
        """

        for m in self._loop_modes(mode):

            # Send the dataset to the API to update, with an explicit timeout.
            # Raises google.api_core.exceptions.Conflict if the Dataset already
            # exists within the project.
            dataset = m["client"].update_dataset(
                self._setup_dataset_object(m["id"]), fields=["description"]
            )  # Make an API request.
