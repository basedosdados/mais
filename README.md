
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-5-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->
<!-- Header -->
<p align="center">
  <a href="https://basedosdados.github.io/mais/">
    <img src="docs/images/bdmais_logo.png" width="340" alt="Base dos Dados Mais">
  </a>
</p>


<p align="center">
    <em>Mecanismo de busca e <b>repositório</b> de bases de dados brasileiras e internacionais.</em>
</p>

<p align="center">
  <a href="https://github.com/basedosdados/mais/subscription" target="_blank">
    <img src="https://img.shields.io/github/watchers/basedosdados/mais.svg?style=social" alt="Watch">
  </a>
  <a href="https://github.com/basedosdados/mais/stargazers" target="_blank">
    <img src="https://img.shields.io/github/stars/basedosdados/mais.svg?style=social" alt="Start">
  </a>
  <a href="https://apoia.se/basedosdados" target="_blank">
    <img src="http://img.shields.io/badge/%E2%9D%A4%20Contribua!%EF%B8%8F%20-%20-ff69b4?style=social" alt="Contribua">
  </a>
  </div>
  <a href="https://twitter.com/intent/tweet?text=Baixe%20e%20faça%20queries%20em%20dados%20publicos,%20tratados%20e%20gratuitos%20com%20a%20Base%20dos%20Dados%20Mais%20🔍%20➕:%20https://basedosdados.github.io/mais/%20via%20@basedosdados" target="_blank">
    <img src="https://img.shields.io/twitter/url/https/github.com/jonsn0w/hyde.svg?style=social" alt="Tweet">
  </a>
</p>

---

## Base dos Dados Mais

Uma simples consulta de SQL é o suficiente para cruzamento de bases que
você desejar. Sem precisar procurar, baixar, tratar, comprar um servidor
e subir clusters.

Nosso repositório traz acesso, rapidez, escala, facilidade, economia,
curadoria, e transparência ao cenário de dados no Brasil.


<p align="center" display="inline-block">
  <a href="https://console.cloud.google.com/bigquery?p=basedosdados&page=project" target="_blank">
    <img src="docs/images/bq_button.png" alt="" width="300" display="inline-block" margin="200">
  </a>
  <a href="https://basedosdados.github.io/mais" target="_blank" display="inline-block" margin="200">
    <img src="docs/images/docs_button.png" alt="Start" width="300">
  </a>
</p>


## Usando em Python


### Instale
`pip install basedosdados`

### Acesse uma tabela

```python
import basedosdados as bd

df = bd.read_table('br_ibge_pib', 'municipios', billing_project_id="<YOUR-PROJECT>")
```

### Faça uma consulta

```python
import basedosdados as bd

# Bens dos candidatos de Tocantins em 2020
query = """
SELECT *
FROM `basedosdados.br_tse_eleicoes.bens_candidato` 
WHERE ano = 2020
AND sigla_uf = 'TO'
"""

df = bd.read_sql(query, billing_project_id="<YOUR-PROJECT>")
```

### Veja todos os datasets disponíveis

```python
import basedosdados as bd

bd.list_datasets()
```

Para saber mais, veja os [exemplos](https://github.com/basedosdados/mais/tree/master/examples) ou a [documentação da API](https://basedosdados.github.io/mais/py_reference_api/)

## Usando em R


### Instale
`install.packages("bigrquery")`

### Faça uma consulta

```r
library("bigrquery")

billing_project_id = "<YOUR_PROJECT_ID>"

pib_per_capita = "SELECT 
    pib.id_municipio ,
    pop.ano, 
    pib.PIB / pop.populacao * 1000 as pib_per_capita
FROM `basedosdados.br_ibge_pib.municipios` as pib
INNER JOIN `basedosdados.br_ibge_populacao.municipios` as pop
ON pib.id_municipio = pop.id_municipio AND pib.ano = pop.ano"

d <- bq_table_download(bq_project_query(billing_project_id, pib_per_capita), page_size=500, bigint="integer64")
```


## Por que o BigQuery?

- **Acesso**: É possível deixar os dados públicos, i.e., qualquer
  pessoa com uma conta no Google Cloud pode fazer uma query na base,
  quando quiser.
- **Rapidez**: Mesmo queries muito longas demoram apenas minutos para
  serem processadas.
- **Escala**: O BigQuery escala magicamente para hexabytes se necessário.
- **Facilidade**: Você pode cruzar tabelas tratadas e atualizadas num só lugar. 
- **Economia**: O custo é praticamente zero para usuários - **1
  TB gratuito por mês para usar como quiser**. Depois disso, são cobrados
  somente 5 dólares por TB de dados que sua query percorrer.

## Contribua! 💚

**Incentivamos que outras instituições e pessoas contribuam**. Veja mais
como contribuir [aqui](https://basedosdados.github.io/mais/colab_data/).

## Como citar o projeto 📝

O projeto está licenciado sob a [Licença Hipocrática](https://firstdonoharm.dev/version/2/1/license.html). Sempre que usar os dados cite a fonte como:

Português:
> Carabetta, João; Dahis, Ricardo; Israel, Fred; Scovino, Fernanda (2020) Base dos Dados: Repositório de Dados Abertos em https://basedosdados.org.

Inglês:
> Carabetta, João; Dahis, Ricardo; Israel, Fred; Scovino, Fernanda (2020) Data Basis: Open Data Repository at https://basedosdados.org.

## Idiomas

Documentação está em português (quando possível), código e configurações
estão em inglês.

## Tutorial

Temos disponível um jupyter notebook com exemplos de uso em `examples/`

## Desenvolvimento

#### CLI

Suba o CLI localmente

```sh
make create-env
. .mais/bin/activate
python setup.py develop
```

#### Versionamento

Publique nova versão

```sh
poetry version [patch|minor|major]
poetry publish --build
```

#### Docs
Atualize os docs adicionando ou editando `.md` em `docs/`.

Se for adicionar um arquivo novo, adicione ele em `mkdocs.yml` sob a chave `nav`.

Para testar a documentação, rode:

```sh
mkdocs serve 
```

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="http://www.ricardodahis.com"><img src="https://avatars0.githubusercontent.com/u/6617207?v=4" width="100px;" alt=""/><br /><sub><b>Ricardo Dahis</b></sub></a><br /><a href="#ideas-rdahis" title="Ideas, Planning, & Feedback">🤔</a> <a href="#blog-rdahis" title="Blogposts">📝</a> <a href="https://github.com/basedosdados/mais/pulls?q=is%3Apr+reviewed-by%3Ardahis" title="Reviewed Pull Requests">👀</a> <a href="#projectManagement-rdahis" title="Project Management">📆</a> <a href="https://github.com/basedosdados/mais/issues?q=author%3Ardahis" title="Bug reports">🐛</a> <a href="#maintenance-rdahis" title="Maintenance">🚧</a> <a href="#question-rdahis" title="Answering Questions">💬</a></td>
    <td align="center"><a href="https://fernandascovino.github.io/"><img src="https://avatars2.githubusercontent.com/u/20743819?v=4" width="100px;" alt=""/><br /><sub><b>Fernanda Scovino</b></sub></a><br /><a href="#ideas-fernandascovino" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/basedosdados/mais/commits?author=fernandascovino" title="Documentation">📖</a> <a href="https://github.com/basedosdados/mais/pulls?q=is%3Apr+reviewed-by%3Afernandascovino" title="Reviewed Pull Requests">👀</a></td>
    <td align="center"><a href="https://github.com/JoaoCarabetta"><img src="https://avatars1.githubusercontent.com/u/19963732?v=4" width="100px;" alt=""/><br /><sub><b>João Carabetta</b></sub></a><br /><a href="#ideas-JoaoCarabetta" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/basedosdados/mais/commits?author=JoaoCarabetta" title="Code">💻</a> <a href="https://github.com/basedosdados/mais/pulls?q=is%3Apr+reviewed-by%3AJoaoCarabetta" title="Reviewed Pull Requests">👀</a> <a href="#projectManagement-JoaoCarabetta" title="Project Management">📆</a> <a href="https://github.com/basedosdados/mais/issues?q=author%3AJoaoCarabetta" title="Bug reports">🐛</a> <a href="#maintenance-JoaoCarabetta" title="Maintenance">🚧</a> <a href="#question-JoaoCarabetta" title="Answering Questions">💬</a></td>
    <td align="center"><a href="https://github.com/polvoazul"><img src="https://avatars2.githubusercontent.com/u/1513181?v=4" width="100px;" alt=""/><br /><sub><b>polvoazul</b></sub></a><br /><a href="#ideas-polvoazul" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/basedosdados/mais/commits?author=polvoazul" title="Code">💻</a> <a href="https://github.com/basedosdados/mais/pulls?q=is%3Apr+reviewed-by%3Apolvoazul" title="Reviewed Pull Requests">👀</a> <a href="#infra-polvoazul" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
    <td align="center"><a href="https://github.com/d116626"><img src="https://avatars2.githubusercontent.com/u/8954716?v=4" width="100px;" alt=""/><br /><sub><b>Diego Oliveira</b></sub></a><br /><a href="#ideas-d116626" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/basedosdados/mais/commits?author=d116626" title="Code">💻</a> <a href="#userTesting-d116626" title="User Testing">📓</a> <a href="https://github.com/basedosdados/mais/pulls?q=is%3Apr+reviewed-by%3Ad116626" title="Reviewed Pull Requests">👀</a> <a href="https://github.com/basedosdados/mais/issues?q=author%3Ad116626" title="Bug reports">🐛</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
