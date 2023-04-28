from glob import glob
import pandas as pd
from loguru import logger

csv_filepaths = glob('../input/**/*.csv', recursive=True)

count = 0
for filepath in csv_filepaths:
    logger.info(f"reading {filepath}")
    df = pd.read_csv(filepath, encoding="utf-8", index_col=0)
    size = len(df.index)
    logger.debug(f"{filepath} has {size}")
    count += size

logger.info(f"Total: {count}")
