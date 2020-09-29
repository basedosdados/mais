from src.base import Base


class Downloader(Base):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)

    def download(self, savepath, query=None, dataset_id=None, table_id=None, **kwargs):

        if (dataset_id is not None) and (table_id is not None):
            table = self.read_table(dataset_id, table_id)
        elif query is not None:
            table = self.read_sql(query)
        elif query is None:
            raise Exception("Either table_id, dataset_id or query should be filled.")

        # Set index to False if it isn't passed explicitly
        kwargs["index"] = kwargs.get("index", False)

        table.to_csv(savepath, **kwargs)

    def read_sql(self, query):

        return (
            self.client["bigquery_prod"]
            .query(query)
            .result()
            .to_dataframe(bqstorage_client=self.client["bigquery_prod"])
        )

    def read_table(self, dataset_id, table_id):

        if (dataset_id is not None) and (table_id is not None):
            query = f"""
            SELECT * 
            FROM `{self.client["bigquery_prod"].project}.{dataset_id}.{table_id}`"""
        else:
            raise Exception("Either table_id and dataset_id should be filled.")

        return self.read_sql(query)
