# Code that cleans the OECD Public Finance Dataset for Base dos Dados
# Author: Rafael Gabbay

import pandas as pd
import numpy as np

# File path
path = "C:/Users/rafae/OneDrive/Documents/Dados/Public Finance/input"

# Loading the dataset
pub_finance = pd.read_excel(path + "/public-finance-dataset-excel.xlsx", "pf dataset v3")

# Loading architecture table to rename variables
architecture_table = pd.read_excel(path + "/world_oecd_public_finance.country_data.xlsx", "country_data" )

# Creates dictionary mapping old column names to column names redefined in architecture
col_names_dict = dict(zip(pub_finance.columns,architecture_table['name']))

# Create a list of columns to exclude according to the architecture table, these are the columns with only null values
excluded_cols = [k for k,v in col_names_dict.items() if '(excluido)' in v]

# Excludes these columns from the pub_finance dataframe

pub_finance_2 = pub_finance.drop(excluded_cols, axis = 1)

# Excludes these columns from the dictionary

for col in excluded_cols:
    col_names_dict.pop([k for k,v in col_names_dict.items() if '(excluido)' in v][0])

# Now we rename the columns according to the dictionary

pub_finance_3 = pub_finance_2.rename(columns = col_names_dict)

# This code transforms a float into a int type if there are no decimals
#
def float_to_int(x):
    if x.dtype == 'float64' and x.apply(lambda x: x.is_integer() or np.isnan(x)).all():
        y = x.replace(np.nan, -1)
        z = y.astype(int)
        a = z.replace(-1, "")
        return a
    else:
        return x

# We apply this to all columns of the dataframe

pub_finance_4 = pub_finance_3.apply(lambda x: float_to_int(x))

 


