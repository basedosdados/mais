from typing import Optional, Tuple
from dateutil.relativedelta import relativedelta
import pandas as pd
from multiprocessing import Pool
from datetime import datetime
from loguru import logger
from pathlib import Path
from ftputil import FTPHost
from datetime import datetime
from io import BytesIO
import tempfile
import zipfile
from functools import reduce

host = FTPHost('ftp.dadosabertos.ans.gov.br', 'anonymous')

TABLE_NAME = 'informacoes_consolidadas_de_beneficiarios'
FTP_PATH = 'FTP/PDA/informacoes_consolidadas_de_beneficiarios'
RAW_COLLUNS_TYPE = {
    '#ID_CMPT_MOVEL': str,
    'CD_OPERADORA': str,
    'NM_RAZAO_SOCIAL': str,
    'NR_CNPJ': str,
    'MODALIDADE_OPERADORA': str,
    'SG_UF': str,
    'CD_MUNICIPIO': str,
    'NM_MUNICIPIO': str,
    'TP_SEXO': str,
    'DE_FAIXA_ETARIA': str,
    'DE_FAIXA_ETARIA_REAJ': str,
    'CD_PLANO': str,
    'TP_VIGENCIA_PLANO': str,
    'DE_CONTRATACAO_PLANO': str,
    'DE_SEGMENTACAO_PLANO': str,
    'DE_ABRG_GEOGRAFICA_PLANO': str,
    'COBERTURA_ASSIST_PLAN': str,
    'TIPO_VINCULO': str,
    'QT_BENEFICIARIO_ATIVO': int,
    'QT_BENEFICIARIO_ADERIDO': int,
    'QT_BENEFICIARIO_CANCELADO': int,
    'QT_BENEFICIARIO_CANCELADO': int,
    'DT_CARGA': str,
}


def range_year_month(start: datetime, stop = datetime.now(), step = relativedelta(months=1)):
    if (start > stop):
        return

    yield start
    yield from range_year_month(start + step, stop)

def host_months_path():
    for date in range_year_month(datetime(day=1, month=5, year=2014)):
        month_path = date.strftime("%Y%m")
        yield FTP_PATH + '/' + month_path, date



def host_list(basepath: str):
    for path  in  host.listdir(basepath)[::-1]:
        complete_path = host.path.join(basepath, str(path))
        yield complete_path

def host_read(path: str) -> BytesIO:
        filename, file_extension = host.path.splitext(host.path.basename(path))
        with tempfile.NamedTemporaryFile(prefix=filename, suffix=file_extension) as tmp:
            logger.info(f'ftp downloading {path}')
            host.download(path, tmp.name)
            return BytesIO(tmp.read())

def read_csv_zip_to_dataframe(path) -> pd.DataFrame:
        zfile = host_read(path)
        with zipfile.ZipFile(zfile) as zref:
                for filename in zref.namelist():
                    if not filename.endswith('.csv'):
                        continue
                    path = host.path.join(host.path.dirname(path), filename)
                    logger.debug(f"load {path}")

                    filecontent = BytesIO(zref.read(filename))

                    return pd.read_csv(filecontent, sep=';', encoding='cp1252', dtype=RAW_COLLUNS_TYPE)
        raise Exception(f"CSV not foun in {path}")

def process(df: pd.DataFrame):
    time_col = pd.to_datetime(df['#ID_CMPT_MOVEL'], format='%Y%m')
    df['ano'] = time_col.dt.year
    df['mes'] = time_col.dt.month
    del df['#ID_CMPT_MOVEL']
    del df['NM_MUNICIPIO']
    del df['DT_CARGA']

    df.rename(columns={
        'CD_OPERADORA': 'codigo_operadora',
        'NM_RAZAO_SOCIAL': 'razao_social',
        'NR_CNPJ': 'cnpj',
        'MODALIDADE_OPERADORA': 'modalidade_operadora',
        'SG_UF': 'sigla_uf',
        'CD_MUNICIPIO': 'id_municipio_6',
        'TP_SEXO': 'sexo',
        'DE_FAIXA_ETARIA': 'faixa_etaria',
        'DE_FAIXA_ETARIA_REAJ': 'faixa_etaria_reajuste',
        'CD_PLANO': 'codigo_plano',
        'TP_VIGENCIA_PLANO': 'tipo_vigencia_plano',
        'DE_CONTRATACAO_PLANO': 'contratacao_beneficiario',
        'DE_SEGMENTACAO_PLANO': 'segmentacao_beneficiario',
        'DE_ABRG_GEOGRAFICA_PLANO': 'abrangencia_beneficiario',
        'COBERTURA_ASSIST_PLAN': 'cobertura_assistencia_beneficiario',
        'TIPO_VINCULO': 'tipo_vinculo',
        'QT_BENEFICIARIO_ATIVO': 'qtd_beneficiario_ativo',
        'QT_BENEFICIARIO_ADERIDO': 'qtd_beneficiario_aderido',
        'QT_BENEFICIARIO_CANCELADO': 'qtd_beneficiario_cancelado'
    }, inplace=True)

    # df['cnpj'] = df['cnpj'].str.zfill(14)
    # df['cnpj'] = df['cnpj'].str.zfill(14)

    df['tipo_vigencia_plano'].replace({
        'P': 'Posterior à Lei 9656/1998 ou planos adaptados à lei',
        'A': 'Anterior à Lei 9656/1998'
    })

    return df

if __name__ == '__main__':
    for month_path, month_date in host_months_path():
        output_path = Path('../output') / f'ano={month_date.strftime("%Y")}' / f'mes={month_date.strftime("%m")}' / f'ben{month_date.strftime("%Y%m")}.parquet'

        if output_path.exists():
            logger.info(f"Jumping path {output_path}. Already download")
            continue

        dfs = []
        for state_path in host_list(month_path):
            state = state_path.split("_")[-1].split(".")[0]
            input_path = Path('../input') / f'ano={month_date.strftime("%Y")}' / f'mes={month_date.strftime("%m")}' / f'ben{month_date.strftime("%Y%m")}_{state}.csv'

            if input_path.exists():
                logger.debug(f"reading input in {input_path}")
                state_df = pd.read_csv(input_path, encoding="utf-8")
            else:
                state_df = read_csv_zip_to_dataframe(state_path)
                input_path.parent.mkdir(parents=True, exist_ok=True)
                state_df.to_csv(input_path, encoding="utf-8")
            dfs.append(state_df)

        logger.info("Concat states dataframes")
        df = pd.concat(dfs)

        logger.info("Cleaning dataset")
        df = process(df)

        output_path.parent.mkdir(parents=True, exist_ok=True)

        # delete partition columns
        del df['ano']
        del df['mes']

        logger.info(f"Writing to output {output_path.as_posix()}")
        df.to_parquet(output_path)
