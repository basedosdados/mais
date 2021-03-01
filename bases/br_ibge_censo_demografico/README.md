# Como capturar os dados de br_ibge_censo_demografico?

1. Para capturar esses dados, basta verificar o link dos dados originais indicado em `dataset_config.yaml` no item `website`.

2. Caso tenha sido utilizado algum código de captura ou tratamento, estes estarão contidos em `code/`. Se o dado publicado for em sua versão bruta, não existirá a pasta `code/`.

Os dados publicados estão disponíveis em: https://basedosdados.org/dataset/br-ibge-censo-demografico

----
# Censo 2010

## Captura
 - Os dados foram baixados do [site do ibge](https://www.ibge.gov.br/estatisticas/downloads-estatisticas.html) em censos --> censo_demografico_2010 --> resultados_do_universo --> agregados_por_setores_censitarios.

## Tratamento
 - Os dados passaram por um padronização do nome das colunas, remoção de textos e logos, unificação des bases. Foram removidas colunas redundates e criado uma estrutura que liga o **id_setor_censitario** a uma tabela de referencia que está no diretorio do basedosdados com o nome de **setores_censitarios**. 

## Dicionários
 - As colunas com nomes, v001, v002, etc foram extraidas do pdf que se encontra na pasta dictionaries.

## Código
 - O código de tratamento se encontra na pasta `code`  
----