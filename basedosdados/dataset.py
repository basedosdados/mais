from pathlib import Path
from google.cloud import bigquery

from google.api_core.exceptions import Conflict

from basedosdados.base import Base


class Dataset(Base):
    """
    Manage datasets in BigQuery.
    """

    def __init__(self, dataset_id, **kwArgs):
        super().__init__(**kwArgs)

        self.dataset_id = dataset_id.replace("-", "_")
        self.dataset_folder = Path(self.metadata_path / self.dataset_id)

    @property
    def dataset_config(self):

        return self._load_yaml(
            self.metadata_path / self.dataset_id / "dataset_config.yaml"
        )

    def _loop_modes(self, mode="all"):

        if mode == "all":
            mode = ["prod", "staging"]
        else:
            mode = [mode]

        dataset_tag = lambda m: f"_{m}" if m == "staging" else ""

        return (
            {
                "client": self.client[f"bigquery_{m}"],
                "id": f"{self.client[f'bigquery_{m}'].project}.{self.dataset_config['dataset_id']}{dataset_tag(m)}",
            }
            for m in mode
        )

    def _setup_dataset_object(self, dataset_id):

        dataset = bigquery.Dataset(dataset_id)
        dataset.description = self._render_template(
            "dataset/dataset_description.txt", self.dataset_config
        )

        return dataset

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

        for file in (Path(self.templates) / "dataset").glob("*"):

            if file.name in ["dataset_config.yaml", "README.md"]:

                # Load and fill template
                template = self._render_template(
                    f"dataset/{file.name}", dict(dataset_id=self.dataset_id)
                )

                # Write file
                (self.dataset_folder / file.name).open("w").write(template)

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

                * raise : Raises Conflic exception
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
            mode (str): Optional. Which dataset to delete [prod|staging|all]
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
