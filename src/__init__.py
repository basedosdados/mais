from src.dataset import Dataset
from src.storage import Storage
from src.table import Table
from src.download import Downloader

d = Downloader()
download = d.download
read_sql = d.read_sql
read_table = d.read_table