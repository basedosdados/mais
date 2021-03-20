# Base: Leis do Município de Feira de Santana

As leis do município de Feira de Santana são publicadas no
site proprietário [www.leismunicipais.com.br](https://leismunicipais.com.br/legislacao-municipal/328/leis-de-feira-de-santana/).
O projeto Dados Abertos de Feira conseguiu os dados via Lei de Acesso à Informação
através do acesso ao arquivo de todas as leis.

O arquivo de leis foi disponibilizado em arquivos HTML. Criamos
uma [CLI para transformar dados disponibilizados pelo site](https://github.com/DadosAbertosDeFeira/leis-municipais)
em JSON.

A primeira publicação dessa base foi feita no [Kaggle](https://www.kaggle.com/anapaulagomes/leis-do-municpio-de-feira-de-santana)
e tem todas as leis do município até o final de 2019.

## Uso dos dados

Como capturar os dados de `br_ba_feiradesantana_camara_leis`?

1. Para capturar esses dados, basta verificar o link dos dados originais indicado em `dataset_config.yaml` no item `website`.

2. Caso tenha sido utilizado algum código de captura ou tratamento, estes estarão contidos em `code/`.
Se o dado publicado for em sua versão bruta, não existirá a pasta `code/`.

Os dados publicados estão disponíveis em: https://basedosdados.org/dataset/br-ba-feiradesantana-camara-leis

## Formato

Cada linha da base contém uma lei contendo:

> titulo, categoria, resumo, texto

## Download dos dados

O processo para acesso a esses arquivos é manual. A cada novo
pedido de informação, o arquivo atualizado é disponibilizado de
maneira diferente. Para a primeira publicação no Base dos Dados
vamos utilizar o arquivo publicado no Kaggle.

Faça o [download dos dados](https://www.kaggle.com/anapaulagomes/leis-do-municpio-de-feira-de-santana)
e salve o arquivo na pasta `input`. Descompacte-o na mesma pasta (o
resultado deve ser o arquivo `leis.json`).

## Transformação

Por enquanto que os dados não são exportados para JSON na CLI, precisamos
transformá-lo em CSV. Execute o arquivo `prepare.py` para isso:

```bash
python bases/br_ba_feiradesantana_leis/code/prepare.py bases/br_ba_feiradesantana_camara_leis/input/leis.json
```

Consideramos o mesmo que a documentação de contribuição: o script será executado
a partir da raiz do repositório.

## Publicação

Para gerar a tabela no Big Query:

```
basedosdados table create br_ba_feiradesantana_camara_leis microdados -p bases/br_ba_feiradesantana_camara_leis/output/leis.csv
```

Para publicar:

```
basedosdados table publish br_ba_feiradesantana_camara_leis microdados
```