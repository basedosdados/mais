# Erros comuns

## 1. `google.api_core.exceptions.BadRequest: 400 POST Field missing name`

Esse erro ocorre pois **a tabela que você deseja subir no BigQuery possui
uma coluna não nomeada**. Verifique o CSV que deseja subir e corrija o erro.

> Para usuários Python, é comum acontecer quando você gera um
CSV com [`pandas.DataFrame.to_csv`](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.to_csv.html) sem `index=False`.