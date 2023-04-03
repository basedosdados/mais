import basedosdados as bd
import pandas as pd

#corrigir 36 id_municipio_bcb faltantes no diretório de municipios

#1 - criar dicionário com valores br_municipio_bcb faltantes
dicionario = {
    '1504752': '58416',
    '1706001' : '34980',
    '1720499' : '44059',
    '2108504' : '12050',
    '2402709' : '24770',
    '2405306' : '58265',
    '2408409' : '39143',
    '2410306' : '26503',
    '2513968' : '56195',
    '2516409' : '28044',
    '2601607' : '33778',
    '2608503' : '37877',
    '2802601' : '4233',
    '2804201' : '35044',
    '2922250' : '46150',
    '3102506' : '12469',
    '3122900' : '12809',
    '3147808' : '19503',
    '3150539' : '53507',
    '3153806' : '9805',
    '3165206' : '33431',
    '3303807' : '24574',
    '3305901' : '9300',
    '3515004' : '34650',
    '3516101' : '3306',
    '3530706' : '39507',
    '3530805' : '3636',
    '4123303' : '1157',
    '4212650' : '58382',
    '4213906' : '22208',
    '4217204' : '5122',
    '4220000' : '58399',
    '4306932' : '45292',
    '4314548' : '58409',
    '4317103' : '1566',
    '5006275' : '58423'
}

#2. baixar base do bq

municipio = bd.read_table(
    dataset_id= 'br_bd_diretorios_brasil',
    table_id= 'municipio',
    billing_project_id= "pisagab-staging"
)

#3. mapear valores faltantes
municipio['id_municipio_bcb'] = municipio.apply(lambda x: dicionario.get(x['id_municipio'], x['id_municipio_bcb']), axis=1)

#4. salvar base
municipio.to_csv('municipio.csv', 
    index=False, 
    encoding='utf-8',
    na_rep=''
)
