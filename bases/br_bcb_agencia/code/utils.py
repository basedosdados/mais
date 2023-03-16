import requests
from lxml import html
from io import BytesIO
from zipfile import ZipFile
from urllib.request import urlopen
import basedosdados as pd
import os
import pandas as pd
import re
import numpy as np
import unicodedata



#---- functions to download data
def extract_download_links(url, xpath):
    """extract all download links from bcb agencias website

    Args:
        url (str): bcb url https://www.bcb.gov.br/fis/info/agencias.asp?frame=1
        xpath (str): xpath which contais donwload links

    Returns:
        list: a list of file links
    """
    # Send a GET request to the URL
    response = requests.get(url)

    # Parse the HTML content of the response using lxml
    tree = html.fromstring(response.content)

    # Extract all the values from the given XPath
    values = tree.xpath(xpath + '/option/@value')

    return values

def download_and_unzip(url, extract_to):  

    """download and unzip a zip file

    Args:
        url (str): a url
        extract_to (str): path to download data
    
    Returns:
        list: unziped files in a given folder
    """
    http_response = urlopen(url)
    zipfile = ZipFile(BytesIO(http_response.read()))
    zipfile.extractall(path=extract_to)

#---- functions to read data and make previous analysis on column names change across the years and mothns

def find_cnpj_row_number(file_path: str)-> int:
    """find the row number of the first occurrence of the CNPJ value (which is always in the first column)
    and returns the row number as an index to further read the file

    Args:
        file_path (str): the path of the files

    Returns:
        int: an index that identifies the row number of the column names
    """
    df = pd.read_excel(file_path,  nrows=20)
    cnpj_row_number = df[df.iloc[:, 0] == 'CNPJ'].index.tolist()[0]
    print(cnpj_row_number)
    return cnpj_row_number



def get_column_names(folder_path: str)-> dict:
    """
    Reads multiple XLSX files in a folder, extracts all column names in each file,
    and returns a dictionary where the keys are the file names and the values are the
    lists of column names.

    Parameters:
    folder_path (str): Path of the folder containing XLSX files.

    Returns:
    dict: Dictionary of file names and column names.
    """
    files_column_names = {}
    for file in os.listdir(folder_path):
        # the files format change across the year
        if file.endswith('.xls') or file.endswith('.xlsx'):
            file_path = os.path.join(folder_path, file)
            try:
                # skip all rows before the row containing the CNPJ value
                skiprows = find_cnpj_row_number(file_path = file_path)+1
                 #parece que retprma sempre 2 linhas acima
                df = pd.read_excel(file_path,  skiprows=skiprows)
                df = clean_column_names(df)
            except:
                df = pd.read_excel(file_path,  skiprows=9)
                df = clean_column_names(df)


            column_names = list(df.columns)
            files_column_names[file] = column_names
            print(f'o arquivo {file}: {column_names}')
    return files_column_names

def count_list_values(dictionary:dict)-> dict:
    """
    Counts the frequency of lists across keys in a dictionary. This function is used to
    find out the different patterns of col names and its repetitions

    Args:
        dictionary (dict): The dictionary to count the lists in.

    Returns:
        dict: A new dictionary containing the count of how many times each list appears.
    """
    count_dict = {}
    for key, value in dictionary.items():
        value_tuple = tuple(value)
        if value_tuple in count_dict:
            count_dict[value_tuple] += 1
        else:
            count_dict[value_tuple] = 1
    return count_dict


def get_conv_names(file_path: str,skiprows: str)-> dict:
    """get column names from a file to be used as a converter

    Args:
        file_path (str): file path
        skiprows (int): Rows to skip given by find_cnpj_row_number function

    Returns:
        dict: A dict that maps the column names to the str type
    """
    df = pd.read_excel(file_path,  nrows=20, skiprows=skiprows)
    cols = df.columns
    conv = dict(zip(cols ,[str] * len(cols)))
    
    return conv


def get_files_path(folder_path: str)-> list:
    """Find files in a folder and returns a list with the files path

    Args:
        folder_path (str): a path to a folder

    Returns:
        list: list with files path
    """
    for file in os.listdir(folder_path):
            # the files format change across the year
        files_list = []
        if file.endswith('.xls') or file.endswith('.xlsx'):
            file_path = os.path.join(folder_path, file)
            files_list.append(file_path)  
    
    return files_list    

def read_file(file_path: str,file_name:str)-> pd.DataFrame:
    """Read files from a folder and returns a dataframe

    Args:
        file_path (str): a path to a file
        file_name (str): Name of the file to be read, also used as input to create_year_month_cols function

    Returns:
        pd.DataFrame: a dataframe with the file content (agencias)
    """
    try:
        # skip all rows before the row containing the CNPJ value
        skiprows = find_cnpj_row_number(file_path=file_path)+1
        #parece que retprma sempre 2 linhas acima
        conv = get_conv_names(file_path = file_path, skiprows = skiprows)
        df = pd.read_excel(file_path,  skiprows=skiprows, converters= conv)
        # todo: rethink logic. file_name param feeds another function create_year_month_cols
        df = create_year_month_cols(df = df, file = file_name)
    except:
        conv = get_conv_names(file_path = file_path, skiprows = 9)
        df = pd.read_excel(file_path,  skiprows=9,dtype= object)
        df = create_year_month_cols(df = df, file = file_name)
    return df

def clean_column_names(df: pd.DataFrame)-> pd.DataFrame:
    """This function perfom general cleaning operations with DataFrame
    columns.

    Args:
        df (pd.DataFrame): a dataframe

    Returns:
        DataFrame: a dataframe with cleaned columns
    """
    # Remove leading and trailing whitespaces from column names
    df.columns = df.columns.str.strip()
    print('colnames striped')
    # Remove accents and special characters from column names
    df.columns = df.columns.map(lambda x: unicodedata.normalize('NFKD', x).encode('ascii', 'ignore').decode('utf-8'))
    print('colnames cleaned 1')
    # Replace remaining special characters with underscores
    df.columns = df.columns.str.replace(r'[^\w\s]+', '_', regex=True)
    print('colnames cleaned 2')
    # Lowercase all column names
    df.columns = df.columns.str.lower()
    print('colnames to lower')
    return df


#---- functions to wrang data

def create_year_month_cols(df: pd.DataFrame,file: str)-> pd.DataFrame:
    """This function creates two new columns in the dataframe, one for the year and another for the month.


    Args:
        df (pd.DataFrame): _description_
        file (str): it refers to the file name, which contains the year and month information. 
        The year is the first 4 digits and the month is the next 2 digits.

    Returns:
        pd.DataFrame: a dataframe with month and year columns
    """
    print(f'{file}')
    df['ano'] = file[0:4]
    df['mes'] = file[4:6]
    print(f'year {file[0:4]} and month {file[4:6]} cols created')
    return df



def check_and_create_column(df: pd.DataFrame, col_name:str)-> pd.DataFrame:
    """
    Check if a column exists in a Pandas DataFrame. If it doesn't, create a new column with the given name
    and fill it with NaN values. If it does exist, do nothing.
    
    Parameters:
    df (Pandas DataFrame): The DataFrame to check.
    col_name (str): The name of the column to check for or create.
    
    Returns:
    Pandas DataFrame: The modified DataFrame.
    """
    if col_name not in df.columns:
        df[col_name] = np.nan
    return df

def rename_cols():
    """Rename columns to a standard format"""
    rename_dict  = {
                    'cnpj' : 'cnpj',      
                    'sequencial do cnpj': 'sequencial_cnpj',
                    'dv do cnpj': 'dv_do_cnpj',
                    'nome instituicao':  'instituicao',                                                                                                                                                                                  
                    'segmento':   'segmento',  
                    'segmentos': 'segmento',                                            
                    'cod compe ag':'id_compe_bcb_agencia',
                    'cod compe bco': 'id_compe_bcb_instituicao',
                    'nome da agencia': 'nome_agencia',
                    'nome agencia' : 'nome_agencia' ,                                 
                    'endereco':   'endereco',                       
                    'numero': 'numero',
                    'complemento':  'complemento',                              
                    'bairro':'bairro',                 
                    'cep': 'cep',
                    'municipio':   'nome', 
                    'estado' : 'sigla_uf',                                                
                    'uf': 'sigla_uf',
                    'data inicio': 'data_inicio' ,
                    'ddd': 'ddd',
                    'fone' :  'fone',
                    'id instalacao': 'id_instalacao',
                    'municipio ibge':  'id_municipio'
                }

    return rename_dict
 
def order_cols():
    """Reorder columns to a standard format"""

    cols_order = [
            'data_inicio',
            'cnpj',
            'nome_agencia',
            'instituicao',
            'segmento',
            'id_compe_bcb_agencia',
            'id_compe_bcb_instituicao',
            
            'sigla_uf',
            'id_municipio',
            'cep',
            'endereco',
            'complemento',
            'bairro',
            'ddd',
            'fone',
            'id_instalacao'
    ]
    return cols_order

def clean_nome_municipio(df: pd.DataFrame) -> pd.DataFrame:
    """perform cleaning operations on the municipio column

    Args:
        df (pd.DataFrame): dataframe with municipio column

    Returns:
        pd.DataFrame: dataframe with municipio cleaned column
    """    
    df['nome'] = df['nome'].apply(lambda x: unicodedata.normalize('NFKD', str(x)).encode('ascii', 'ignore').decode('utf-8'))
    df['nome'] = df['nome'].apply(lambda x: re.sub(r'[^\w\s]', '', x))
    df['nome'] = df['nome'].str.lower()
    df['nome'] = df['nome'].str.strip()
    return df

def read_brazilian_municipallity_ids_from_base_dos_dados(billing_id: str)-> pd.DataFrame:
    """Download municipio table from base dos dados

    Args:
        billing_id (str): BQ billing project id

    Returns:
        pd.DataFrame:  municipio table from base dos dados
    """    
    municipio = bd.read_table(dataset_id= 'br_bd_diretorios_brasil',
                           table_id= 'municipio',
                           billing_project_id= billing_id)
    return municipio

# this output a series object df['cep'], to apply functions to it its necessary to use apply method.
# define a function to remove non-numeric characters
def remove_non_numeric_chars(s):
    """Remove non numeric chars from a pd.dataframe column"""
    return re.sub(r'\D', '', s)

def remove_empty_spaces(s):
    """Remove empty spaces from a pd.dataframe column"""
    return re.sub(r'\s', '', s)

def create_cnpj_col(df: pd.DataFrame)-> pd.DataFrame:
    """Takes an dataframe with cnpj, sequencial_cnpj and dv_do_cnpj columns 
    and create a new column with the cnpj

    Args:
        df (pd.DataFrame): a dataframe with cnpj formatted column
    """
    #concat cnpj

    df['sequencial_cnpj'] =  df['sequencial_cnpj'].astype(str)
    df['dv_do_cnpj'] =  df['dv_do_cnpj'].astype(str)
    df['cnpj'] =  df['cnpj'].astype(str)

    df['cnpj'] = df['cnpj'] + df['sequencial_cnpj'] + df['dv_do_cnpj']
    print('cnpj built')
    
    return df
   

def str_to_title(df: pd.DataFrame, column_name:str)-> pd.DataFrame:
    df[column_name] = df[column_name].str.title()
    return df

def strip_dataframe_columns(df: pd.DataFrame)-> pd.DataFrame:
    """
    Strips whitespace from all column values in a Pandas DataFrame.
    
    Parameters:
        df (pandas.DataFrame): The input DataFrame to be processed.
        
    Returns:
        pandas.DataFrame: The processed DataFrame with stripped column values.
    """
    # Use applymap to apply the strip method to all values in the DataFrame
    # Note: applymap applies a function to each element of a DataFrame
    stripped_df = df.applymap(lambda x: x.strip() if isinstance(x, str) else x)
    
    return stripped_df

def format_date(date_str):
    """Change random date format to a standard format and, if it doesnt work,
    fill the results with NaN values.
    Args:
        date_str (str): a column with dates

    Returns:
        _type_: _description_
    """    
    try:
        date_obj = pd.to_datetime(date_str)
        formatted_date = date_obj.strftime('%Y/%m/%d')
    # ! they are random numbers in date column that breaks the code
    except ValueError:
        formatted_date = np.nan
    return formatted_date
