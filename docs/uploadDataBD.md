# Subindo dados para a BD

- [Subindo dados para a BD](#subindo-dados-para-a-bd)
  * [Extração dos dados](#extra--o-dos-dados)
  * [Upload](#upload)
    + [Table.create](#tablecreate)
      - [Alterações locais](#altera--es-locais)
      - [Alterações no GCloud](#altera--es-no-gcloud)
    + [Table.update_columns](#tableupdate-columns)
      - [Alterações locais](#altera--es-locais-1)
    + [Table.publish](#tablepublish)
- [TL;DR:](#tl-dr-)



Neste tutorial, vamos subir um conjunto de dados para o *Data Lake* da **BD**. Nosso objetivo será discriminar o passo a passo e prover detalhes do que acontece por "trás das cenas", para além da mera aplicação das funções existentes no pacote `basedosdados`. Para este exemplo, vamos usar os dados de inflação do IPCA. Esses dados já existem atualmente em dev e em prod. Por essa razão, para fins de ilustração, vamos criar tabelas e datasets como novos nomes e depois apagá-los. Esse tutorial está dividido em mais duas seções. Na seção seguinte realizamos a extração e limpeza dos dados do IPCA e a seção [Upload](#upload) mostra o passo a passo do *load* dos dados no *Data Lake* da BD. Nosso foco maior será sobre o ciclo de upload, por isso a primeira seção será breve e o código de extração e limpeza não será explicado, o leitor interessado pode consultar o código fonte no arquivo `tutorial.py`.

## Extração dos dados

Todo o processo de ETL apresentado neste tutorial será feito a partir de funções do pacote em python da **BD** e de funções definidas em um módulo local chamado `tutorial.py`. Para extrair e limpar os dados rode o seguinte script no seu computador:

```python
from tutorial import crawler, clean_mes_brasil, clean_mes_rm, clean_mes_municipio, clean_mes_geral

indice= 'ipca'
folder= 'br'

for folder in ["br", "mes", "mun", "rm"]:
    crawler('ipca', folder)


clean_mes_brasil('ipca')
clean_mes_rm('ipca')
clean_mes_municipio('ipca')
clean_mes_geral('ipca')
```

Após o script ter rodado, o terminal irá printar a seguinte estrutura de pastas localizada em `/tmp/data`:

```bash
/tmp/data
├── input
│   ├── br
│   │   ├── ipca_geral.csv
│   │   ├── ipca_grupo.csv
│   │   ├── ipca_item.csv
│   │   ├── ipca_subgrupo.csv
│   │   └── ipca_subitem.csv
│   ├── mes
│   │   └── ipca_geral.csv
│   ├── mun
│   │   ├── ipca_geral.csv
│   │   ├── ipca_grupo.csv
│   │   ├── ipca_item.csv
│   │   ├── ipca_subgrupo.csv
│   │   ├── ipca_subitem_1.csv
│   │   └── ipca_subitem_2.csv
│   └── rm
│       ├── ipca_geral.csv
│       ├── ipca_grupo.csv
│       ├── ipca_item.csv
│       ├── ipca_subgrupo.csv
│       ├── ipca_subitem_1.csv
│       └── ipca_subitem_2.csv
└── output
    ├── inpc
    ├── ip15
    └── ipca
        ├── categoria_brasil.csv
        ├── categoria_municipio.csv
        ├── categoria_rm.csv
        └── mes_brasil.csv
```

Isso finaliza a extração e limpeza dos dados. Na próxima seção vamos detalhar o upload dos dados:

## Upload

O upload dos dados locais para o *Data Lake* da **BD** faz uso de 3 métodos definidos para a classe `Table` no pacote em python. Os métodos são `Table.create`, `Table.update_columns` e `Table.publish`. A seguir, vamos detalhar cada um desses métodos, com enfoque em quais aquivos eles alteram localmente e na nuvem.

### Table.create

Para usar os métodos, precisamos primeiro instanciar um objeto da classe `Table`:

```python
import basedosdados as bd

tb = bd.Table(
    dataset_id="tutorial_ipca",
    table_id="tutorial_cat_brasil",
)
```

O primeiro método que vamos analisar é o `create`:

```python
tb.create(path="/tmp/data/output/ipca/categoria_brasil.csv")
```

#### Alterações locais

Podemos ver os arquivos alterados localmente pelo `create` usando a CLI `find` do GNU/Linux:

```bash
find . -type f -mmin -2
```

Onde pedimos para o computador printar todos os arquivos (`-f`) modificado nos últimos 2 minutos (`-mmin -2`).

```bash
./bases/tutorial_ipca/tutorial_cat_brasil/table_config.yaml
./bases/tutorial_ipca/tutorial_cat_brasil/publish.sql
./bases/tutorial_ipca/tutorial_cat_brasil/schema-staging.json
./bases/tutorial_ipca/README.md
./bases/tutorial_ipca/dataset_config.yaml
```

Vamos examinar cada um desses arquivos. O arquivo `table_config.yaml` é um arquivo de configuração dos metadados da tabela que acabamos de criar (um arquivo análogo chamado `dataset_config.yaml` foi criado para o dataset). Note que esse arquivo é apenas um template, apresentando as chaves a serem preenchidas, mas com a maioria dos valores vazios. Veja, por exemplo, a parte referente à informação de uma das colunas, onde existe o nome (informação extraída do csv), mas as demais informações estão vazias:

```bash
columns:
    - name: ano
      bigquery_type:
      description:
      temporal_coverage:
      covered_by_dictionary:
      directory_column:
          dataset_id:
          table_id:
          column_name:
      measurement_unit:
      has_sensitive_data:
      observations:
      is_in_staging:
      is_partition:
```

Outro arquivo criado pelo `Table.create` foi o `publish.sql`. Este arquivo contém uma query que cria uma `VIEW` para a tabela que criamos. Abaixo replicamos o conteúdo da query:

```sql
CREATE VIEW basedosdados-dev.tutorial_ipca.tutorial_cat_brasil AS
SELECT 
SAFE_CAST(ano AS STRING) ano,
SAFE_CAST(mes AS STRING) mes,
SAFE_CAST(id_categoria AS STRING) id_categoria,
SAFE_CAST(id_categoria_bd AS STRING) id_categoria_bd,
SAFE_CAST(categoria AS STRING) categoria,
SAFE_CAST(peso_mensal AS STRING) peso_mensal,
SAFE_CAST(variacao_mensal AS STRING) variacao_mensal,
SAFE_CAST(variacao_anual AS STRING) variacao_anual,
SAFE_CAST(variacao_doze_meses AS STRING) variacao_doze_meses
FROM basedosdados-dev.tutorial_ipca_staging.tutorial_cat_brasil AS t
```

Três fatos são importantes notar na `VIEW` acima:

1. A `VIEW` é criada a partir de um *dataset* chamado `tutorial_ipca_staging`. Esse *dataset* for criado pelo método `Table.create`
2. A `VIEW` cria uma nova tabela em um *dataset* chamado `tutorial_ipca`.
3. Todas as variáveis são criadas como STRING

O arquivo `schema-staging.json` replica o conteúdo do `yaml`, visto anteriormente, no formato `json`. A seguir, replicamos parte do conteúdo desse arquivo:

```json
[{"name": "ano", "bigquery_type": null, "description": null, "temporal_coverage": null, "covered_by_dictionary": null, "directory_column": {"dataset_id": null, "table_id": null, "column_name": null}, "measurement_unit": null, "has_sensitive_data": null, "observations": null, "is_in_staging": null, "is_partition": null, "type": "STRING"}, {"name": "mes", "bigquery_type": null, "description": null, "temporal_coverage": null, "covered_by_dictionary": null, "directory_column": {"dataset_id": null, "table_id": null, "column_name": null}, "measurement_unit": null, "has_sensitive_data": null, "observations": null, "is_in_staging": null, "is_partition": null, "type": "STRING"},
```
Por fim, um arquivo `README` também foi criado. Esse arquivo tem a função de explicar como os dados foram capturados e indicar ao usuário que ele pode encontrar mais detalhes na pasta `code`. No nosso caso, esta pasta está vazia.

#### Alterações no GCloud

Quando rodamos o método `Table.create` também foram feitas alterações na *Google Cloud Storage* (doravante, GCS) e no *Big Query* (doravante, BQ). É fácil identificar essas alterações usando, novamente, o terminal. Para isso, [instale](https://cloud.google.com/storage/docs/gsutil_install#deb) o `gsutil` no seu computador e rode o seguinte comando:

```bash
gsutil ls gs://basedosdados-dev/staging/
```

O comando acima lista todos os *datasets* em *staging*, você vai notar que o *dataset* que criamos com o método `Table.create` aparece com e endereço `gs://basedosdados-dev/staging/tutorial_ipca/`

Dentro dessa pasta estão contidos os dados em formato bruto. Para ver isso, rode:

```bash
gsutil ls gs://basedosdados-dev/staging/tutorial_ipca/tutorial_cat_brasil/
```
que retorna: 

```
gs://basedosdados-dev/staging/tutorial_ipca/tutorial_cat_brasil/categoria_brasil.csv
```

Além dessa alteração no GCS, mais duas alterações foram feitas no BQ. Em primeiro lugar, em `basedosdados-dev` foram criados dois *datasets* chamados de `tutorial_ipca_staging` e `tutorial_ipca`. O *dataset* `tutorial_ipca_staging.tutorial_cat_brasil` contém a tabela com os dados brutos do arquivo `categoria_brasil.csv`. Enquanto o *dataset* `tutorial_ipca` irá, futuramente, receber a VIEW criada pelo `publish.sql`, visto anteriormente.

### Table.update_columns

Com os *datasets* e os arquivos de configuração criados, podemos agora fazer um *update* dos metadados. Existe mais de uma forma de fazer isso, mas para fins de facilitar a visualização, vamos usar o método `update_columns` que faz o update dos metadados a partir das informações disponíveis em umm *Google Sheet*:

```python
tb.update_columns('https://docs.google.com/spreadsheets/d/1oLkb_Y_pT4WqfkUEyxdA68wpOv2Evlyu/edit#gid=1496168147')
```
#### Alterações locais

Após rodar o método `update_columns`, podemos novamente o usar o `find` para checar quais arquivos foram alterados localmente. No meu computador, esse é o retorno que obtenho de `find . -type f -mmin -2 | egrep bases`:

```bash
./bases/tutorial_ipca/tutorial_cat_brasil/table_config.yaml
./bases/tutorial_ipca/tutorial_cat_brasil/publish.sql
```

Podemos agora examinar quais alterações foram feitas nesses arquivos. Examinando primeiro o `table_config.yaml` podemos notar que, por exemplo, a coluna `variacao_mensal` agora tem os seguintes metadados:

```bash
 name: variacao_mensal
      bigquery_type: float64
      description: Variação percentual mensal
      temporal_coverage:
          - 1994(01)2021
```

Já a `VIEW` criada pela `publish.sql` também foi alterada. Note, em particular, que todas as colunas com informação variação do índice agora são do tipo FLOAT64:

```sql
CREATE VIEW basedosdados-dev.tutorial_ipca.tutorial_cat_brasil AS
SELECT 
SAFE_CAST(ano AS STRING) ano,
SAFE_CAST(mes AS INT64) mes,
SAFE_CAST(id_categoria AS STRING) id_categoria,
SAFE_CAST(id_categoria_bd AS STRING) id_categoria_bd,
SAFE_CAST(categoria AS STRING) categoria,
SAFE_CAST(peso_mensal AS STRING) peso_mensal,
SAFE_CAST(variacao_mensal AS FLOAT64) variacao_mensal,
SAFE_CAST(variacao_anual AS FLOAT64) variacao_anual,
SAFE_CAST(variacao_doze_meses AS FLOAT64) variacao_doze_meses
FROM basedosdados-dev.tutorial_ipca_staging.tutorial_cat_brasil AS t
```

O método `update_columns`, no entanto, faz apenas alterações locais. Para que as alterações sejam efetivadas na no GCloud, precisamos de mais um método: `Table.publish`

### Table.publish

Para implementar as alterações locais no BQ basta rodar:

```python
tb.publish(if_exists='replace')
```

# TL;DR:

A tabela a seguir resume a função de cada um dos métodos que vimos acima e quais arquivos eles alteram:

| Método         | Descrição                                                                                                           | Alteração local                                                                  | Alteração GCloud                                                                                                               |
|----------------|---------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|
| create         | Cria arquivos no GCS na pasta basedosdados-dev/staging e respectiva tabela no BQ                                    | table_config.yaml  publish.sql schema-staging.json README.md dataset_config.yaml | tutorial_ipca_stating/tutorial_cat_brasil/tutorial_cat_brasil.csv  tutorial_ipca/tutorial_cat_brasil / tutorial_cat_brasil.csv |
| update_columns | Faz update de arquivos de configuração locais                                                                       | table_config.yaml publish.sql                                                    |                                                                -                                                               |
| publish        | Usa table_config.yamls e publish.sql e tutorial_ipca_staging.tutorial_cat_brasilpara criar uma VIEW da tabela no BQ |                                         -                                        | Tabela BQ: basedosdados-dev.tutorial_ipca.tutorial_cat_brasil                                                                  |

