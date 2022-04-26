#--------------------#
# setup
#--------------------#

import os.path
import pandas as pd
import numpy as np
import basedosdados

dir = os.path.dirname(__file__)
path = os.path.abspath(os.path.join(dir, '..', 'input'))
path_data = os.path.join(path, 'pwt100.xlsx')
if (not os.path.isdir(path)):
    os.mkdir(path)
df = pd.read_excel(path_data, sheet_name='Data', na_filter=False)

#--------------------#
# tratamento e output
#--------------------#

# tabela de arquitetura
out_dir = os.path.abspath(os.path.join(dir, '..', 'extra\\architecture'))
arq_data_path = os.path.join(out_dir, 'microdados.xlsx')
if (not os.path.isdir(out_dir)):
    os.mkdir(out_dir)
arq_data = pd.read_excel(arq_data_path, sheet_name='microdados')

# listas com novos nomes das variáveis e nova ordenação
new_name_variable = arq_data.name.tolist()
old_name_variable = arq_data.original_name.tolist()
rename = dict(zip(old_name_variable, new_name_variable))
order = new_name_variable

# lista com variáveis a serem transformadas
variables_to_transform = arq_data[arq_data['observations'].str.contains(
    'millions', na=False)]
variables_to_transform = variables_to_transform["name"].tolist()

# renomeação, reordenamento e transformação
df = df.rename(columns=rename)
df = df[order]
df[variables_to_transform] = df[variables_to_transform].mul(1000000)

# output
path_out = os.path.abspath(os.path.join(dir, '..', 'output'))
path_data_out = os.path.join(path_out, 'microdados.csv')
if (not os.path.isdir(path_out)):
    os.mkdir(path_out)
df.to_csv(path_data_out, index=False, encoding='utf-8', na_rep='')
