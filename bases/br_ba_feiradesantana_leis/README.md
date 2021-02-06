# Base: Leis do Município de Feira de Santana

As leis do município de Feira de Santana são publicadas no
site proprietário [www.leismunicipais.com.br](). O projeto
Dados Abertos de Feira conseguiu via Lei de Acesso à Informação
acesso ao arquivo de todas as leis.

O arquivo de leis foi disponibilizado em arquivos HTML. Criamos
uma [CLI para transformar dados disponibilizados pelo site](https://github.com/DadosAbertosDeFeira/leis-municipais)
em JSON.

A primeira publicação dessa base foi feita no [Kaggle](https://www.kaggle.com/anapaulagomes/leis-do-municpio-de-feira-de-santana)
e tem todas as leis do município até o final de 2019.

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
python bases/br_ba_feiradesantana_leis/code/prepare.py bases/br_ba_feiradesantana_leis/input/leis.json
```

Consideramos o mesmo que a documentação de contribuição: o script será executado
a partir da raiz do repositório.

## Publicação
