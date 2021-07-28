Os dados publicados estão disponíveis em: https://basedosdados.org/dataset/br-ibge-censo-demografico

# Como capturar os dados de br_ibge_censo_demografico?

1. Para capturar esses dados, basta verificar o link dos dados originais indicado em `dataset_config.yaml` no item `website`.

2. Caso tenha sido utilizado algum código de captura ou tratamento, estes estarão contidos em `code/`. Se o dado publicado for em sua versão bruta, não existirá a pasta `code/`.

# Arquivos auxiliares

Os arquivos auxiliares aos microdados (e.g. dicionários, instrumentos de coleta) estão disponíveis [aqui](https://storage.googleapis.com/basedosdados/auxiliary_files/br_ibge_censo_demografico.zip).

----
# Censo 2010 - Setor Censitário

## Captura
 - Os dados foram baixados do [site do ibge](https://www.ibge.gov.br/estatisticas/downloads-estatisticas.html) em censos --> censo_demografico_2010 --> resultados_do_universo --> agregados_por_setores_censitarios.

## Tratamento
 - Os dados passaram por um padronização do nome das colunas, remoção de textos e logos, unificação des bases. Foram removidas colunas redundates e criado uma estrutura que liga o **id_setor_censitario** a uma tabela de referência `basedosdados.br_bd_diretorios_brasil.setor_censitario`. 

## Dicionários
 - As colunas com nomes, v001, v002, etc foram extraidas do pdf que se encontra na pasta dictionaries ou baixadas [aqui](https://storage.googleapis.com/basedosdados/auxiliary_files/br_ibge_censo_demografico_setores_censitarios.zip).

## Código
 - O código de tratamento se encontra na pasta `code`  
----
