## Captura
 - Os dados foram baixados do [site do ibge](https://www.ibge.gov.br/estatisticas/downloads-estatisticas.html) em censos --> censo_demografico_2010 --> resultados_do_universo --> agregados_por_setores_censitarios.

## Tratamento
 - Os dados passaram por um padronização do nome das colunas, remoção de textos e logos, unificação des bases. Foram removidas colunas redundates e criado uma estrutura que liga o **id_setor_censitario** a uma tabela de referencia que está no diretorio do basedosdados com o nome de **setores_censitarios**. 

## Dicionários
 - As colunas com nomes, v001, v002, etc foram extraidas do pdf que se encontra na pasta dictionaries.