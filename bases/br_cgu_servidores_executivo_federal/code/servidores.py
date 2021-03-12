#!/usr/bin/env python

#########################################################
## Código escrito por:                                 ##
## Cristiano Froes - https://github.com/CristianoFroes ##
## Henrique Xavier - https://github.com/hsxavier       ##
## Data: 2020-12-10                                    ##
#########################################################

import pandas as pd
import os
import glob
import requests
import zipfile
import io
import numpy as np
import csv
#import utils as xu
from google.cloud import storage
import sys
import re


###### Funções genéricas ######


def remove_accents(string, i=0):
    """
    Input: string
    
    Returns the same string, but without all portuguese-valid accents.
    """
    accent_list = [('Ç','C'),('Ã','A'),('Á','A'),('À','A'),('Â','A'),('É','E'),('Ê','E'),('Í','I'),('Õ','O'),('Ó','O'),
                   ('Ô','O'),('Ú','U'),('Ü','U'),('ç','c'),('ã','a'),('á','a'),('à','a'),('â','a'),('é','e'),('ê','e'),
                   ('í','i'),('õ','o'),('ó','o'),('ô','o'),('ú','u'),('ü','u'),('È','E'),('Ö','O'),('Ñ','N'),('è','e'),
                   ('ö','o'),('ñ','n'),('Ë','E'),('ë','e'),('Ä','A'),('ä','a')]
    if i >= len(accent_list):
        return string
    else:
        string = string.replace(*accent_list[i])
        return remove_accents(string, i + 1)


def gen_filename_list(start_date, end_date, posfix):
    """
    Create a date range from `start_date` to `end_date` 
    (inclusive, with both str in format '%Y-%m') and return 
    a list of strings with each element in the format 
    YYYMM`posfix`, where `posfix` is a string.
    
    Ex.: gen_filename_list('2019-11', '2020-01', '_Servidores.zip') 
    will output:
    ['201911_Servidores.zip', '201912_Servidores.zip', '202001_Servidores.zip']
    """
    daterange = pd.date_range(start_date, pd.to_datetime(end_date) + pd.to_timedelta(31, 'D'), freq='M')
    file_list = [str(date.year) + str(date.month).zfill(2) + posfix for date in daterange]
    
    return file_list


###### Funções de baixar os dados ######


def download_zip_data(url, save_dir, verbose=False):
    """
    Download a zip file at `url` web address, unzip it and save it to `save_dir`.
    """
    # Initialize session:
    session = requests.session()
    session.mount('http://', requests.adapters.HTTPAdapter(max_retries=3))
    
    # Download data:
    if verbose:
        print('Downloading ' + url)
    response = session.get(url, timeout=900)
    
    # Unzip data if download is successful:
    if response.status_code == 200:
        if verbose:
            print('Unzipping data to ' + save_dir)
        z = zipfile.ZipFile(io.BytesIO(response.content))
        z.extractall(save_dir)
    else:
        if verbose:
            print('Failed with status code', response.status_codeatus_code)
    
    return response.status_code



def download_date_range(start_date, end_date, base, save_dir, verbose=False):
    """
    Download data about servidores federais from Portal da Transparência, 
    unzip it and save it locally. Download data in the specified date range.
    
    Input
    -----
    
    start_date : str
        First month of the data downloading process, in
        the format '%Y-%m' (e.g. '2018-04').
        
    end_date : str
        Last month (inclusive) of the data downloading process, 
        in the format '%Y-%m' (e.g. '2018-04').
    
    base : str
        Either 'civis' or 'militares', tells which kind of 
        servidor to download data about.
        
    save_dir : str
        Path to the folder to receive the unzipped files. 
        No folders are created (only those inside the zip file,
        if any).
    
    verbose : bool
        Whether or not to print status messages.
    """

    # Hard-coded:
    root_url = 'http://www.portaltransparencia.gov.br/download-de-dados/servidores/'

    # Generate file list from dates:
    if base == 'civis':
        file_list = gen_filename_list(start_date, end_date, '_Servidores.zip')
    elif base == 'militares':
        file_list = gen_filename_list(start_date, end_date, '_Militares.zip')
    else:
        raise Exception("Unknown `base` '" + base + "'.")
    
    # Loop over files to download:
    for filename in file_list:
        if verbose:
            print('Downloading ' + filename)
        status = download_zip_data(root_url + filename, save_dir)
        if status != 200:
            print('Failed to download ' + filename)


###### Funções genéricas de limpar os dados ######


def filename_to_mes_ano(filename):
    """
    Extract and return month and year (a tuple of str) from filename 
    (str) assuming the structure:

    directory/YYYYMM_whatever.csv

    (the important part is the '/YYYYMM')
    """
    name = filename.split('/')[-1]
    ano = int(name[:4])
    mes = int(name[4:6])
    return mes, ano


def format_col_name(string):
    '''Função para formatar o nome das colunas aplicando a substituição de alguns caracteres'''

    # Lista de caracteres a serem substituídos
    de_para = [(' ', '_'), ('(R$)', 'R'), ('/', '_'),
               ('(U$)', 'U'), ('(*)', ''), ('-', '_')]

    for item in de_para:
        string = string.replace(item[0], item[1])
    return string


###### Funções específicas de limpar os dados ######


def parse_remuneracao(df):
    """
    Parse strings in DataFrame `df` in columns listed in `value_cols`
    as floats, assuming that they are in Brazilian format 
    (e.g. 144.654,56).
    """
    df = df.copy()

    # Substituindo ',' por '.'
    for colum in df.columns[5:]:
        df[colum] = df[colum].str.replace(',', '.')

    # Transformando str para float
    for col in df.columns[5:]:
        #df[col] = df[col].apply(xu.parse_ptbr_number)
        df[col] = df[col].astype(float)

    # Passa ID para int:
    df['Id_SERVIDOR_PORTAL'] = df['Id_SERVIDOR_PORTAL'].astype(int)

    # Remove acentos do nome das colunas:
    df.columns = [remove_accents(s) for s in df.columns]

    # Renomeando as colunas
    df.rename(columns={'ID_SERVIDOR_PORTAL': 'ID SERVIDOR',
                       'ABATE-TETO DA GRATIFICACAO NATALINA (R$)': 'ABATE-TETO DA GRATIF NATALINA (R$)',
                       'ABATE-TETO DA GRATIFICACAO NATALINA (U$)': 'ABATE-TETO DA GRATIF NATALINA (U$)',
                       'OUTRAS REMUNERACOES EVENTUAIS (R$)': 'REMUNERACOES EVENTUAIS (R$)',
                       'OUTRAS REMUNERACOES EVENTUAIS (U$)': 'REMUNERACOES EVENTUAIS (U$)',
                       'TAXA DE OCUPACAO IMOVEL FUNCIONAL (R$)': 'TX DE OCUPACAO IMOVEL (R$)',
                       'TAXA DE OCUPACAO IMOVEL FUNCIONAL (U$)': 'TX DE OCUPACAO IMOVEL (U$)',
                       'REMUNERACAO APOS DEDUCOES OBRIGATORIAS (R$)': 'REMUNERACAO APOS DEDUCOES (R$)',
                       'REMUNERACAO APOS DEDUCOES OBRIGATORIAS (U$)': 'REMUNERACAO APOS DEDUCOES (U$)',
                       'VERBAS INDENIZATORIAS REGISTRADAS EM SISTEMAS DE PESSOAL - CIVIL (R$)(*)': 'VERBAS INDENIZATORIAS CIVIL (R$)(*)',
                       'VERBAS INDENIZATORIAS REGISTRADAS EM SISTEMAS DE PESSOAL - CIVIL (U$)(*)': 'VERBAS INDENIZATORIAS CIVIL (U$)(*)',
                       'VERBAS INDENIZATORIAS REGISTRADAS EM SISTEMAS DE PESSOAL - MILITAR (R$)(*)': 'VERBAS INDENIZATORIAS MILITAR (R$)(*)',
                       'VERBAS INDENIZATORIAS REGISTRADAS EM SISTEMAS DE PESSOAL - MILITAR (U$)(*)': 'VERBAS INDENIZATORIAS MILITAR (U$)(*)',
                       'VERBAS INDENIZATORIAS PROGRAMA DESLIGAMENTO VOLUNTARIO \x96 MP 792/2017 (R$)': 'VERBAS DESLIGAMENTO VOLUNTARIO (R$)',
                       'VERBAS INDENIZATORIAS PROGRAMA DESLIGAMENTO VOLUNTARIO \x96 MP 792/2017 (U$)': 'VERBAS DESLIGAMENTO VOLUNTARIO (U$)'
                       }, inplace=True)

    # Removendo alguns caracteres
    df.columns = [format_col_name(column).lower() for column in df.columns]

    return df


def parse_cadastro(df):
    """
    Parse strings in DataFrame `df` in columns listed in `value_cols`
    as floats, assuming that they are in Brazilian format 
    (e.g. 144.654,56).
    """
    df = df.copy()

    # Passa ID para int:
    df['Id_SERVIDOR_PORTAL'] = df['Id_SERVIDOR_PORTAL'].astype(int)

    # Renomeando as colunas
    df.rename(columns={'Id_SERVIDOR_PORTAL': 'ID_SERVIDOR',
                       'DESCRICAO_CARGO': 'DESC_CARGO',
                       'REFERENCIA_CARGO': 'REF_CARGO',
                       'CODIGO_ATIVIDADE': 'COD_ATIVIDADE',
                       'DATA_INICIO_AFASTAMENTO': 'INICIO_AFASTAMENTO',
                       'DATA_TERMINO_AFASTAMENTO': 'TERMINO_AFASTAMENTO',
                       'DATA_INGRESSO_CARGOFUNCAO': 'INGRESSO_CARGO_FUNCAO',
                       'DATA_NOMEACAO_CARGOFUNCAO': 'NOMEACAO_CARGO_FUNCAO',
                       'DATA_INGRESSO_ORGAO': 'INGRESSO_ORGAO',
                       'DOCUMENTO_INGRESSO_SERVICOPUBLICO': 'DOC_INGRESSO_SERVICO_PUBLICO',
                       'DATA_DIPLOMA_INGRESSO_SERVICOPUBLICO': 'DATA_DIPL_INGRESSO_SERVICO_PUBLICO',
                       'DIPLOMA_INGRESSO_CARGOFUNCAO': 'DIPL_INGRESSO_CARGO_FUNCAO',
                       'DIPLOMA_INGRESSO_ORGAO': 'DIPL_INGRESSO_ORGAO',
                       'DIPLOMA_INGRESSO_SERVICOPUBLICO': 'DIPL_INGRESSO_SERVICO_PUBLICO'
                       }, inplace=True)

    # Remove acentos do nome das colunas:
    df.columns = [remove_accents(s.lower()) for s in df.columns]

    return df


def parse_jetons(df):

    df = df.copy()

    # altera ',' para '.'
    df['VALOR'] = df['VALOR'].str.replace(',', '.')

    # Transformando em float
    df['VALOR'] = df['VALOR'].astype(float)

    # Passa ID para int:
    df['Id_SERVIDOR_PORTAL'] = df['Id_SERVIDOR_PORTAL'].astype(int)

    # renomeia a coluna
    df.rename(columns={'Id_SERVIDOR_PORTAL': 'Id_SERVIDOR'}, inplace=True)

    # Remove acentos do nome das colunas:
    df.columns = [remove_accents(s.lower()) for s in df.columns]

    return df


def parse_observacoes(df):
    
    # Tratando o nome das colunas
    df['Id_SERVIDOR_PORTAL'] = df['Id_SERVIDOR_PORTAL'].astype(int)

    # Alterando o nome da coluna
    df.rename(columns={'Id_SERVIDOR_PORTAL': 'ID_SERVIDOR'}, inplace=True)

    # Remove acentos do nome das colunas:
    df.columns = [remove_accents(s.lower()) for s in df.columns]

    return df


####### Funções diretoras de limpeza de arquivos ######


def clean_data_file(input_file, output_file, parser, verbose=False):
    """
    Clean a CSV file about servidores federais, downloaded
    from Portal da Transparência. Get the brute file from `input_file` and
    save the cleaned file to `output_file`. Use `parser` (function) to 
    clean specific things about this data.
    """
    # Extract the month and year the file corresponds to:
    if verbose:
        print('Extracting month and date from filename...')
    mes, ano = filename_to_mes_ano(input_file)

    # Load data:
    if verbose:
        print('Loading data...')
    df   = pd.read_csv(input_file, sep=';', encoding='latin-1', dtype=str)
    cols = df.columns.values

    # Remove linhas com campos vazios:
    #df.dropna(how='any', inplace=True)

    # Coloca coluna de ano e mês caso inexistente:
    if 'ANO' not in df.columns:
        if verbose:
            print('Adding year column...')
        df['ANO'] = [str(ano)] * len(df)
        cols = np.insert(cols, 0, 'ANO')
    if 'MES' not in df.columns:
        if verbose:
            print('Adding month column...')
        df['MES'] = [str(mes)] * len(df)
        cols = np.insert(cols, 0, 'MES')

    # Remove line with comment about remunerações:
    # (i.e. String in place of year):
    if verbose:
        print('Filtering out non-complient year entries...')
    df = df.loc[~df['ANO'].str.contains('\D')]
    
    # Chamando a função parse_remuneracao
    if verbose:
        print('Parsing data values...')
    df = parser(df[cols])
    
    # Save file
    if verbose:
        print('Saving cleaned file...')    
    df.to_csv(output_file, index=False, encoding='utf-8-sig')


def clean_multiple_files(from_dir, to_dir, start_date, end_date, base, subject, to_posfix='_cleaned', verbose=False):
    """
    Clean multiple CSV files (looping inside the specified date range)
    from Portal da Transparência, about servidores federais.
    
    Input
    -----
    
    from_dir : str
        The directory containing the raw CSV files.
        
    to_dir : str
        The directory where to save the cleaned CSV files.
        
    start_date : str
        First month of the data to be cleaned, in the format '%Y-%m' 
        (e.g. '2018-04'). This is the CSV file prefix, according to 
        Portal da Transparência standards.
        
    end_date : str
        Last month of the data to be cleaned, in the format '%Y-%m' 
        (e.g. '2018-04'). This is the CSV file prefix, according to 
        Portal da Transparência standards.
        
    base : str
        Either 'civis' or 'militares', tells which file to clean 
        (by specifying a term in the filename, following Portal da 
        Transparência standards).
        
    subject : str
        The kind of data to clean (that is, which files to clean). 
        It can be: 'cadastro', 'remuneracao', 'observacoes', 
        'jetons', 'honorarios_advocaticios', 'afastamentos'.
    
    to_posfix : str
        Suffix appended to cleaned CSV files (right before '.csv' 
        extension).
    
    verbose : bool
        Whether or not to print status messages.
    """
    
    # Menu of data cleaner to use (according to the subject of the data):
    parser  = {'cadastro':     parse_cadastro,
               'remuneracao':  parse_remuneracao,
               'observacoes':  parse_observacoes,
               'jetons':       parse_jetons,
               'honorarios_advocaticios': None,
               'afastamentos': None
              }
    
    # Menu of the filename term corresponding to the theme:
    term    = {'cadastro':      '_Cadastro',
               'remuneracao':  '_Remuneracao',
               'observacoes':  '_Observacoes',
               'jetons':       '_Honorarios(Jetons)',
               'honorarios_advocaticios': '_HonorariosAdvocaticios',
               'afastamentos': '_Afastamentos'
              }
    
    # Menu of the filename term corresponding to the servidor kind:
    base_tag = {'civis': '', 'militares': 'Militares'}
    
    if parser[subject] == None:
        raise Exception("No parser is currently specified for '" + subject + "' data.")
    
    # Generate list of files to clean:
    if verbose:
        print('Generating list of files to clean...')
    from_files = gen_filename_list(start_date, end_date, term[subject] + base_tag[base] + '.csv')
    to_files   = gen_filename_list(start_date, end_date, term[subject] + base_tag[base] + to_posfix + '.csv')
    
    # Loop over files to clean:
    for from_file, to_file in zip(from_files, to_files):
        from_path = from_dir + from_file
        if os.path.isfile(from_path):
            if verbose:
                print('Cleaning ' + from_path + ' to ' + to_dir + to_file + ' ...')
            clean_data_file(from_path, to_dir + to_file, parser[subject], True)
        else:
            print('File ' + from_path + ' not found.')


def clean_multiple_dates(from_dir, to_dir, start_date, end_date, base, to_posfix='_cleaned', verbose=False):
    """
    Clean multiple CSV files (looping inside the specified date range and
    over various topics or subjects) from Portal da Transparência, about 
    servidores federais.
    
    Input
    -----
    
    from_dir : str
        The directory containing the raw CSV files.
        
    to_dir : str
        The directory where to save the cleaned CSV files.
        
    start_date : str
        First month of the data to be cleaned, in the format '%Y-%m' 
        (e.g. '2018-04'). This is the CSV file prefix, according to 
        Portal da Transparência standards.
        
    end_date : str
        Last month of the data to be cleaned, in the format '%Y-%m' 
        (e.g. '2018-04'). This is the CSV file prefix, according to 
        Portal da Transparência standards.
        
    base : str
        Either 'civis' or 'militares', tells which file to clean 
        (by specifying a term in the filename, following Portal da 
        Transparência standards).
            
    to_posfix : str
        Suffix appended to cleaned CSV files (right before '.csv' 
        extension).
    
    verbose : bool
        Whether or not to print status messages.
    """

    if base == 'civis':
        for subject in ['cadastro', 'remuneracao', 'observacoes', 'jetons']:
            clean_multiple_files(from_dir, to_dir, start_date, end_date, base, subject, to_posfix, verbose)
    if base == 'militares':
        for subject in ['cadastro', 'remuneracao', 'observacoes', 'jetons']:
            clean_multiple_files(from_dir, to_dir, start_date, end_date, base, subject, to_posfix, verbose)   


###### Funções de subir para a cloud ######


def upload_to_storage_gcp(bucket, key, data):
    """
    Given a data bucket (e.g. 'brutos-publicos') a key (e.g. 
    'executivo/federal/servidores/data/201901_Cadastro.csv'), 
    and 'data' (a string with all the data), write to GCP storage.
    """
    storage_client = storage.Client(project='gabinete-compartilhado')

    bucket = storage_client.get_bucket(bucket)
    blob = bucket.blob(key)

    blob.upload_from_string(data)


def list_blobs_with_prefix(bucket_name, prefix, credentials='gabinete-compartilhado_cristiano.json', delimiter=None):
    """
    Lists all the blobs in the bucket that begin with the prefix.

    This can be used to list all blobs in a "folder", e.g. "public/".

    The delimiter argument can be used to restrict the results to only the
    "files" in the given "folder". Without the delimiter, the entire tree under
    the prefix is returned. For example, given these blobs:

        a/1.txt
        a/b/2.txt

    If you just specify prefix = 'a', you'll get back:

        a/1.txt
        a/b/2.txt

    However, if you specify prefix='a' and delimiter='/', you'll get back:

        a/1.txt

    Additionally, the same request will return blobs.prefixes populated with:

        a/b/
    """

    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = credentials 

    storage_client = storage.Client()

    # Note: Client.list_blobs requires at least package version 1.17.0.
    blobs = storage_client.list_blobs(
        bucket_name, prefix=prefix, delimiter=delimiter
    )

    blob_list = [blob.name for blob in blobs]

    return blob_list


def gcp_key(prefix, filename, date_partitioned=True):
    """
    Return a string with the key for the object in the cloud 
    that will contain data from the file `filename` (str).
    Use the `prefix` and use hive partitioning if requested.
    """
    # Get file name (no dirs):
    basename = os.path.basename(filename)
    
    # Make sure prefix ends in slash:
    if prefix[-1] != '/':
        prefix = prefix + '/'   
        
    # Add hive partitioning if requested:
    if date_partitioned:
        key = prefix + 'data=' + basename[:4] + '-' + basename[4:6] + '-01/' + basename
    else:
        key = prefix + basename
        
    return key


def upload_single_file(filename, bucket, prefix, credentials, date_partitioned=True, verbose=False):
    """
    Upload file `filename` (str) to Google Storage's `bucket`, defining the key with a 
    `prefix` (str), a hive date partitioning (if `date_partitioned` is True) derived from 
    the date in `filename`. Use the JSON file with path `credentials` as GCP credentials.
    """
    
    # Set object key (where to find the file in GCP):
    if verbose:
        print('Generating Storage key...')
    key = gcp_key(prefix, filename)
    
    # Read file:
    if verbose:
        print('Reading file...')
    with open(filename, 'r') as f:
        text = f.read()
    
    # Upload file:
    if verbose:
        print('Uploading data to GCP...')
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = credentials 
    upload_to_storage_gcp(bucket, key, text)


def upload_multiple_files(from_dir, start_date, end_date, base, subject, bucket, prefix, credentials, date_partitioned=True, suffix='_cleaned', verbose=False):

    # Menu of the filename term corresponding to the theme:
    term    = {'cadastro':      '_Cadastro',
               'remuneracao':  '_Remuneracao',
               'observacoes':  '_Observacoes',
               'jetons':       '_Honorarios(Jetons)',
               'honorarios_advocaticios': '_HonorariosAdvocaticios',
               'afastamentos': '_Afastamentos'
              }
    
    # Menu of the filename term corresponding to the servidor kind:
    base_tag = {'civis': '', 'militares': 'Militares'}
    
    # Generate list of files to upload:
    if verbose:
        print('Generating list of files to upload...')
    files       = gen_filename_list(start_date, end_date, term[subject] + base_tag[base] + suffix + '.csv')
    upload_list = [from_dir + file for file in files]
    
    for file in upload_list:
        if os.path.isfile(file):
            if verbose:
                print('Uploading ' + file + ' to ' + bucket + ':' + prefix)
            upload_single_file(file, bucket, prefix, credentials, date_partitioned)
        else:
            print('File ' + file + ' not found.')


def upload_multiple_dates(from_dir, start_date, end_date, base, bucket, prefix, credentials, date_partitioned=True, suffix='_cleaned', verbose=False):
    
    if base == 'civis':
        for subject in ['cadastro', 'remuneracao', 'observacoes', 'jetons']:
            upload_multiple_files(from_dir, start_date, end_date, base, subject, bucket, prefix, credentials, date_partitioned, suffix, verbose)
    
    if base == 'militares':
        for subject in ['cadastro', 'remuneracao', 'observacoes', 'jetons']:
            upload_multiple_files(from_dir, start_date, end_date, base, subject, bucket, prefix, credentials, date_partitioned, suffix, verbose)    
            

####################### Scripts ###########################


def bad_date(date):
    """
    Check if `date` (str) is not in format %Y-%m.
    """
    if re.match('[12]\d{3}\-(?:0[1-9]|1[0-2])', date) != None:
        return False
    else:
        return True
    

def download_script(argv):
    """
    Download data about servidores federais from CGU's Portal da Transparência.

    USAGE:   servidores.py download <START_DATE> <END_DATE> <DATABASE> [<SAVING_DIR>]
    EXAMPLE: servidores.py download 2013-02 2020-02 militares
    EXAMPLE: servidores.py download 2013-02 2020-02 militares ../brutos/militares/

    Will download the data for months <START_DATE> to <END_DATE> (inclusive) from 
    <DATABASE> (which can be 'civis', 'militares' or 'all'). <SAVING_DIR> is optional
    (defaults to ../brutos/<DATABASE>/).
    """
    
    # Docstring output:
    if len(argv) != 2 + 3 and len(argv) != 2 + 4: 
        print(download_script.__doc__)
        sys.exit(1)
    
    # Get input: 
    start_date = argv[2]
    end_date   = argv[3]
    base       = argv[4]
    if len(argv) == 2 + 4:
        save_dir = argv[5]
    else:
        save_dir = None
    
    # Input checks:
    if bad_date(start_date):
        print("`start_date` '{}' is not a valid date.".format(start_date))
        sys.exit(1)
    if bad_date(end_date):
        print("`end_date` '{}' is not a valid date.".format(end_date))
        sys.exit(1)
    if base not in ['civis', 'militares', 'all']:
        print("`database` '{}' should be 'civis', 'militares' or 'all'.".format(base))
        sys.exit(1)

    # Create list of databases to download:
    base_list = {'all':       ['civis', 'militares'],
                 'civis':     ['civis'],
                 'militares': ['militares']
                 }[base]
    # Create list of destination folders:
    if save_dir == None:
        save_list = ['../brutos/' + b + '/' for b in base_list]
    else:
        save_list = [save_dir for b in base_list]

    # Download data:
    for database, folder in zip(base_list, save_list):
        download_date_range(start_date, end_date, database, folder, True)
    

def clean_script(argv):
    """
    Clean data about servidores federais from CGU's Portal da Transparência.

    USAGE:   servidores.py clean <START_DATE> <END_DATE> <DATABASE> [<FROM_DIR> <TO_DIR>]
    EXAMPLE: servidores.py clean 2013-02 2020-02 militares 
    EXAMPLE: servidores.py clean 2013-02 2020-02 militares ../brutos/militares/ ../limpos/militares/

    Will clean the data for months <START_DATE> to <END_DATE> (inclusive) from 
    <DATABASE> (which can be 'civis', 'militares' or 'all'). Input data is read from optional 
    <FROM_DIR> and written to optional <TO_DIR> (they default to ../brutos/<DATABASE>/ and 
    ../limpos/<DATABASE>/ and both must be specified or none can be specified). 
    """
    
    # Docstring output:
    if len(argv) != 2 + 3 and len(argv) != 2 + 5: 
        print(clean_script.__doc__)
        sys.exit(1)
    
    # Get input: 
    start_date = argv[2]
    end_date   = argv[3]
    base       = argv[4]
    if len(argv) == 2 + 5:
        from_dir = argv[5]
        to_dir   = argv[6]
    else:
        from_dir = None
        to_dir   = None

        
    # Input checks:
    if bad_date(start_date):
        print("`start_date` '{}' is not a valid date.".format(start_date))
        sys.exit(1)
    if bad_date(end_date):
        print("`end_date` '{}' is not a valid date.".format(end_date))
        sys.exit(1)
    if base not in ['civis', 'militares', 'all']:
        print("`database` '{}' should be 'civis', 'militares' or 'all'.".format(base))
        sys.exit(1)

    # Create list of databases to download:
    base_list = {'all':       ['civis', 'militares'],
                 'civis':     ['civis'],
                 'militares': ['militares']
                 }[base]
    # Create list of source folders:
    if from_dir == None:
        from_list = ['../brutos/' + b + '/' for b in base_list]
    else:
        from_list = [from_dir for b in base_list]
    # Create list of destination folders:
    if to_dir == None:
        to_list = ['../limpos/' + b + '/' for b in base_list]
    else:
        to_list = [to_dir for b in base_list]

    # Clean data:
    for database, from_folder, to_folder in zip(base_list, from_list, to_list):
        clean_multiple_dates(from_folder, to_folder, start_date, end_date, database, verbose=True)


def upload_script(argv):
    """
    Upload data about servidores federais from CGU's Portal da Transparência to Google Storage.

    USAGE:   servidores.py upload <START_DATE> <END_DATE> <DATABASE> [<PREFIX>] [<FROM_DIR>]
    EXAMPLE: servidores.py upload 2013-02 2020-02 militares
    EXAMPLE: servidores.py upload 2013-02 2020-02 militares executivo/federal/servidores/partitioned/
    EXAMPLE: servidores.py upload 2013-02 2020-02 militares executivo/federal/servidores/partitioned/ ../limpos/militares/

    Will upload to Google Storage the data for months <START_DATE> to <END_DATE> 
    (inclusive) about <DATABASE> (which can be 'civis', 'militares' or 'all'). 
    The bucket is hard-coded to 'brutos-publicos', <PREFIX> is optional and refers to the
    objects' prefix and <FROM_DIR> is also optional and refers to the folder of the 
    local files to be uploaded. To specify <FROM_DIR>, you must specify <PREFIX>. 
    If not specified, <PREFIX> defaults to 'executivo/federal/servidores/partitioned/' 
    and <FROM_DIR> defaults to '../limpos/<DATABASE>'.

    PS: The objects are automatically partitioned by date. The credentials are also hard-coded.
    """

    # Hard-coded:
    credentials = '/home/skems/gabinete/projetos/keys-configs/gabinete-compartilhado.json'
    bucket      = 'brutos-publicos'
    
    
    # Docstring output:
    if len(argv) != 2 + 3 and len(argv) != 2 + 4 and len(argv) != 2 + 5: 
        print(upload_script.__doc__)
        sys.exit(1)
    
    # Get input: 
    start_date = argv[2]
    end_date   = argv[3]
    base       = argv[4]
    if len(argv) == 2 + 4 or len(argv) == 2 + 5:
        prefix = argv[5]
    else:
        prefix = 'executivo/federal/servidores/partitioned/'
    if len(argv) == 2 + 5:
        from_dir = argv[6]
    else:
        from_dir = None
    
    
    # Input checks:
    if bad_date(start_date):
        print("`start_date` '{}' is not a valid date.".format(start_date))
        sys.exit(1)
    if bad_date(end_date):
        print("`end_date` '{}' is not a valid date.".format(end_date))
        sys.exit(1)
    if base not in ['civis', 'militares', 'all']:
        print("`database` '{}' should be 'civis', 'militares' or 'all'.".format(base))
        sys.exit(1)

    # Create list of databases to download:
    base_list = {'all':       ['civis', 'militares'],
                 'civis':     ['civis'],
                 'militares': ['militares']
                 }[base]
    # Create list of destination folders:
    if from_dir == None:
        from_list = ['../limpos/' + b + '/' for b in base_list]
    else:
        from_list = [from_dir for b in base_list]

    # Download data:
    for database, folder in zip(base_list, from_list):
        upload_multiple_dates(folder, start_date, end_date, database, bucket, prefix, credentials, verbose=True)

    
def main(argv):
    """
    Redirect the script to a specific function according to 
    <COMMAND> (first argument after the script's name):

    Download, clean or upload to GCP data about servidores federais,
    extracted from CGU's Portal da Transparência.

    USAGE:   servidores.py <COMMAND> ...
    EXAMPLE: servidores.py download 2013-02 2020-02 militares
    EXAMPLE: servidores.py clean 2013-02 2020-02 militares 
    EXAMPLE: servidores.py upload 2013-02 2020-02 militares

    For more options for each command, just call:
    servidores.py <COMMAND>
    """

    # Docstring output:
    if len(argv) <= 1: 
        print(main.__doc__)
        sys.exit(1)

    
    if argv[1] == 'download':
        download_script(argv)

    elif argv[1] == 'clean':
        clean_script(argv)
        
    elif argv[1] == 'upload':
        upload_script(argv)
    
    else:
        print("Unknown command '{}'.".format(argv[1]))


# If running this code as a script:
if __name__ == '__main__':
    main(sys.argv)
    
