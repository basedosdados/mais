"""
Module for manage dataset to the server.
"""
# pylint: disable=line-too-long, fixme, invalid-name,line-too-long,unnecessary-lambda-assignment
from pathlib import Path
from loguru import logger

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
        """
        Dataset config file.
        """

        return self._load_yaml(
            self.metadata_path / self.dataset_id / "dataset_config.yaml"
        )

    def _loop_modes(self, mode="all"):
        """
        Loop modes.
        """

        mode = ["prod", "staging"] if mode == "all" else [mode]
        dataset_tag = lambda m: f"_{m}" if m == "staging" else ""

        return (
            {
                "client": self.client[f"bigquery_{m}"],
                "id": f"{self.client[f'bigquery_{m}'].project}.{self.dataset_id}{dataset_tag(m)}",
            }
            for m in mode
        )

    @staticmethod
    def _setup_dataset_object(dataset_id, location=None):
        """
        Setup dataset object.
        """

        dataset = bigquery.Dataset(dataset_id)

        ## TODO: not being used since 1.6.0 - need to redo the description tha goes to bigquery
        dataset.description = "Para saber mais acesse https://basedosdados.org/"
        # dataset.description = self._render_template(
        #     Path("dataset/dataset_description.txt"), self.dataset_config
        # )

        dataset.location = location

        return dataset

    def _write_readme_file(self):
        """
        Write README.md file.
        """

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

        readme_path = Path(self.metadata_path / self.dataset_id / "README.md")

        with open(readme_path, "w", encoding="utf-8") as readmefile:
            readmefile.write(readme_content)

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
        except FileExistsError as e:
            raise FileExistsError(
                f"Dataset {str(self.dataset_folder.stem)} folder does not exists. "
                "Set replace=True to replace current files."
            ) from e

        # create dataset_config.yaml with metadata
        self.metadata.create(if_exists="replace")

        # create README.md file
        self._write_readme_file()

        # Add code folder
        (self.dataset_folder / "code").mkdir(exist_ok=replace, parents=True)

        return self

    def publicize(self, mode="all", dataset_is_public=True):
        """Changes IAM configuration to turn BigQuery dataset public.

        Args:
            mode (bool): Which dataset to create [prod|staging|all].
            dataset_is_public (bool): Control if prod dataset is public or not. By default staging datasets like `dataset_id_staging` are not public.
        """

        for m in self._loop_modes(mode):

            dataset = m["client"].get_dataset(m["id"])
            entries = dataset.access_entries
            # TODO https://github.com/basedosdados/mais/pull/1020
            # TODO if staging dataset is private, the prod view can't acess it: if dataset_is_public and "staging" not in dataset.dataset_id:
            if dataset_is_public:
                if "staging" not in dataset.dataset_id:
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
                else:
                    entries.extend(
                        [
                            bigquery.AccessEntry(
                                role="roles/bigquery.dataViewer",
                                entity_type="iamMember",
                                entity_id="allUsers",
                            ),
                        ]
                    )
                dataset.access_entries = entries
            m["client"].update_dataset(dataset, ["access_entries"])
        logger.success(
            " {object} {object_id}_{mode} was {action}!",
            object_id=self.dataset_id,
            mode=mode,
            object="Dataset",
            action="publicized",
        )

    def create(
        self, mode="all", if_exists="raise", dataset_is_public=True, location=None
    ):
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

            dataset_is_public (bool): Control if prod dataset is public or not. By default staging datasets like `dataset_id_staging` are not public.

            location (str): Optional. Location of dataset data.
                List of possible region names locations: https://cloud.google.com/bigquery/docs/locations


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
            dataset_obj = self._setup_dataset_object(m["id"], location=location)

            # Send the dataset to the API for creation, with an explicit timeout.
            # Raises google.api_core.exceptions.Conflict if the Dataset already
            # exists within the project.
            try:
                m["client"].create_dataset(dataset_obj)  # Make an API request.
                logger.success(
                    " {object} {object_id}_{mode} was {action}!",
                    object_id=self.dataset_id,
                    mode=mode,
                    object="Dataset",
                    action="created",
                )

            except Conflict as e:
                if if_exists == "pass":
                    return
                raise Conflict(f"Dataset {self.dataset_id} already exists") from e

        # Make prod dataset public
        self.publicize(dataset_is_public=dataset_is_public)

    def delete(self, mode="all"):
        """Deletes dataset in BigQuery. Toogle mode to choose which dataset to delete.

        Args:
            mode (str): Optional.  Which dataset to delete [prod|staging|all]
        """

        for m in self._loop_modes(mode):

            m["client"].delete_dataset(m["id"], delete_contents=True, not_found_ok=True)
        logger.info(
            " {object} {object_id}_{mode} was {action}!",
            object_id=self.dataset_id,
            mode=mode,
            object="Dataset",
            action="deleted",
        )

    def update(self, mode="all", location=None):
        """Update dataset description. Toogle mode to choose which dataset to update.

        Args:
            mode (str): Optional. Which dataset to update [prod|staging|all]
            location (str): Optional. Location of dataset data.
                List of possible region names locations: https://cloud.google.com/bigquery/docs/locations

        """

        for m in self._loop_modes(mode):

            # Send the dataset to the API to update, with an explicit timeout.
            # Raises google.api_core.exceptions.Conflict if the Dataset already
            # exists within the project.
            m["client"].update_dataset(
                self._setup_dataset_object(
                    m["id"],
                    location=location,
                ),
                fields=["description"],
            )  # Make an API request.

        logger.success(
            " {object} {object_id}_{mode} was {action}!",
            object_id=self.dataset_id,
            mode=mode,
            object="Dataset",
            action="updated",
        )
