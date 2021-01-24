# Subindo dados na BD+

!!! Info "Essa página expande os passos (6) e (7) do fluxo de trabalho resumido [aqui](/data_start/#fluxo-de-trabalho)."

## Subir os dados no BigQuery

1. Configurar um projeto no Google Cloud e um _bucket_ no Google Storage.
2. Usar nosso CLI `basedosdados`.
    - Instalar com `pip install basedosdados`.
    - Configurar localmente com as credenciais do projeto.
3. Seguir o comando `basedosdados table create`.
    - Consulte nossa [API](/cli_reference_api) para mais detalhes de cada método.
4. Preencher todos os arquivos de configuração.
    - `README.md`: informações básicas da base de dados aparecendo no Github
    - `dataset_config.yaml`: informações específicas da base de dados
    - `/<table_id>/table_config.yaml`: informações específicas da tabela
    - `/<table_id>/publish.sql`: informações da publicação da tabela
	      - Tipos de variáveis no [BigQuery](https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types): STRING, INT64, FLOAT64, DATE.
5. Publicar a versão pronta no seu _bucket_ com o comando `basedosdados table publish`.

## Enviar o código e dados prontos para revisão

- Usar o comando `basedosdados table release`.
