#A partir dos metadados da pasta bases e do bigquery gerar um .csv com os seguintes campos:
#dataset_id	table_id	frequencia_	ultima_atualizacao	proxima_atualizacao	flag_atualizacao

import os
import yaml
from pprint import pprint
import arrow
import pandas as pd


def get_next_update(last_updated, update_frequency):

    # Opções: hora | dia | semana | mês | 1 ano | 2 anos | 5 anos | 10 anos | único | recorrente
    elements = update_frequency.split(' ')
    qty = 0
    if len(elements) == 2:
        qty = int(elements[0])
        timespan = elements[1].lower()
    else:
        timespan = elements[0].lower()
        qty = 1


    if timespan == 'hora':
        return last_updated

    if timespan == 'dia':
        return last_updated.shift(days=+qty)

    if timespan == 'semana':
        return last_updated.shift(weeks=+qty)

    if timespan == 'mês' or timespan == 'mes':
        return last_updated.shift(months=+qty)

    if 'ano' in timespan:
        return last_updated.shift(years=+qty)

    if timespan == 'recorrente':
        # DEFAULT VALUE IS 3 MONTHS
        return last_updated.shift(months=+3)
 
    # Shouldn't reach here. Should raise error
    return last_updated.shift(years=+999)

def get_flag_update(next_update):
    today = arrow.now()
    if next_update <= today:
        return 'Vermelho (Desatualizado)'

    if next_update <= today.shift(months=+2):
        return 'Amarelo (Atualização Caducando)'

    return 'Verde (Atualizado)'


def check(yaml_filepath):
    relatorio = {}
    with open(yaml_filepath, 'r') as yaml_file:
        yaml_dictionary = yaml.full_load(yaml_file)

        field = yaml_dictionary.get('dataset_id', None)
        if field == None:
            return None
        relatorio['dataset_id'] = field


        field = yaml_dictionary.get('table_id', None)
        if field == None:
            return None
        relatorio['table_id'] = field

        field = yaml_dictionary.get('data_update_frequency', None)
        if field == None:
            return None
        relatorio['frequencia_'] = field

        field = yaml_dictionary.get('last_updated', None)
        if field == None:
            return None
        last_updated = arrow.get(field)
        relatorio['ultima_atualizacao'] = last_updated.format('YYYY-MM-DD')

        next_update = get_next_update(last_updated, relatorio['frequencia_'])
        relatorio['proxima_atualizacao'] = next_update.format('YYYY-MM-DD')
        relatorio['flag_atualizacao']    = get_flag_update(next_update)

    return relatorio

def write_report(filepath, dataframe):
    if len(dataframe) == 0:
        return None

    dataframe.to_csv(filepath, index=False)
    return None

def walk(directory, output_path):
    keys = ['dataset_id', 'table_id', 'frequencia_', 'ultima_atualizacao', 'proxima_atualizacao', 'flag_atualizacao']
    dados = {}
    for key in keys:
        dados[key] = []
    dataframe = pd.DataFrame(dados)

    for root, dir, files in os.walk(directory, topdown=True):
        if files == []:
            continue
        for filename in files:
            if filename.endswith('.yaml') and filename != 'dataset_config.yaml':
                dado = check(os.path.join(root, filename))
                if dado != None:
                    dataframe = dataframe.append(dado, ignore_index=True)

    write_report(output_path, dataframe)
    return None


DIR = '../bases/'
output = 'relatorio frequencia de atualizações.csv'
walk(DIR, output)

