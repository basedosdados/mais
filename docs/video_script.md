Alô, vou mostar como usar o CLI do basedosdados para adicionar uma tabela nova.

Vamos começar pelo diretório dos municípios, nosso pilar central :)

1. Já temos ele salvo no storage:

basedosdados/staging/br_suporte/diretorio_municipios

onde 
- br_suporte é o dataset
- diretorio_municipios é a tabela

2. O primeiro passo é criar os metadados do nosso dataset

`basedosdados dataset init br_suporte`

Isso cria um folder e arquivos de configuração em /bases

3. Uma vez preenchidos os arquivos, podemos criar o dataset no BigQuery

`basedosdados dataset create br_suporte`

Isso cria dois datasets, o staging para preparar os dados e o de produção
que será compartilhado

4. Agora podemos criar os arquivos de config da tabela. Podemos usar os dados
para preencher as colunas do arquivo :)

`basedosdados table init br_suporte diretorio_municipios --data_sample_path=data/br_suporte/municipios.csv`

Isso cria um folder dentro da pasta do dataset com os arquivos de config

table_config.yaml tem toda a metada informação
publish.sql é o último tratamento antes de publicar a tabela

5. Uma vez com tudo preenchido, podemos criar a tabela no staging

`basedosdados table create br_suporte diretorio_municipios`

A tabela já vem com todas as configurações e só faltam os últimos ajustes e tratamentos 
que podemos adicionar em publish.sql

6. Finalmente, basta publicar os dados

`basedosdados table publish br_suporte diretorio_municipios`

Tcharam!