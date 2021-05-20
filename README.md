<!-- Header -->
<p align="center">
  <a href="https://basedosdados.org">
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
  <a href="https://twitter.com/intent/tweet?text=Baixe%20e%20faça%20queries%20em%20dados%20publicos,%20tratados%20e%20gratuitos%20com%20a%20Base%20dos%20Dados%20Mais%20🔍%20➕:%20https://basedosdados.github.io/mais/%20via%20@basedosdados" target="_blank">
    <img src="https://img.shields.io/twitter/url/https/github.com/jonsn0w/hyde.svg?style=social" alt="Tweet">
  </a>
<!--   <a href="https://pypi.org/project/basedosdados/" target="_blank">
    <img src="https://img.shields.io/pypi/dm/basedosdados" alt="PyPi">
  </a> -->
  <a href="https://discord.com/invite/ZKCcKf8BTB" target="_blank">
    <img src="https://img.shields.io/discord/787841210433536010" alt="Discord">
  </a>
  <a href="http://https://apoia.se/basedosdados" target="_blank">
    <img src="https://img.shields.io/badge/apoie!%E2%9D%A4%EF%B8%8F-ff69b4" alt="Apoiase">
  </a>
</p>

**Versões atuais do pacote:**

| ***R*** | ***Python*** |
|-----|-----|
| [![CRAN/METACRAN Version](https://www.r-pkg.org/badges/version/basedosdados)](https://CRAN.R-project.org/package=basedosdados) <br />  [![CRAN/METACRAN Total downloads](http://cranlogs.r-pkg.org/badges/grand-total/basedosdados?color=blue)](https://CRAN.R-project.org/package=basedosdados) <br />  [![CRAN/METACRAN downloads per month](http://cranlogs.r-pkg.org/badges/basedosdados)](https://CRAN.R-project.org/package=basedosdados) <br />  ![Lifecycle: stable](https://img.shields.io/github/issues/basedosdados/mais/R) | [![PyPI version](https://badge.fury.io/py/basedosdados.svg)](https://badge.fury.io/py/basedosdados) <br />  [![Downloads](https://pepy.tech/badge/basedosdados)](https://pepy.tech/project/basedosdados) <br />  [![Downloads](https://pepy.tech/badge/basedosdados/month)](https://pepy.tech/project/basedosdados/month)  <br /> ![Lifecycle: stable](https://img.shields.io/github/issues/basedosdados/mais/Python) |

# O que fazemos?

Organizamos, tratamos e disponibilizamos bases de dados públicas difíceis de se manusear e disponibilizamos as mesmas no nosso mecanismo de busca e num *datalake* público de forma fácil e simples para que a única preocupação de quem as utiliza seja qual pergunta fazer aos dados. Uma simples consulta de SQL é o suficiente para cruzamento das bases que você desejar - sem nunca mais precisar procurar, baixar, tratar, comprar um servidor e subir clusters na nuvem.

**Nosso repositório traz acesso, rapidez, escala, facilidade, economia, curadoria, e transparência ao cenário de dados no Brasil.**

<p align="center" display="inline-block">
  <a href="https://console.cloud.google.com/bigquery?p=basedosdados&page=project" target="_blank">
    <img src="docs/images/bq_button.png" alt="" width="300" display="inline-block" margin="200">
  </a>
  <a href="https://basedosdados.github.io/mais" target="_blank" display="inline-block" margin="200">
    <img src="docs/images/docs_button.png" alt="Start" width="300">
  </a>
</p>


# Usando em Python


### Instale
```bash
pip install basedosdados
```

### Crie seu projeto no BigQuery

É necessário criar um projeto para que você possa fazer as queries no
nosso repositório. Ter um projeto é de graça e basta ter uma conta
Google (seu gmail por exemplo). 

Caso não tenha ainda um projeto, [veja aqui como criar um projeto no Google
Cloud](https://basedosdados.github.io/mais/access_data_local/#criando-um-projeto-no-google-cloud).

Se possível, armazene suas credenciais em um arquivo `dotenv`:

```sh

"billing_project_id=<suas_credenciais_do_projeto>" >> .env

```

### Acesse uma tabela

```python
import basedosdados as bd

df = bd.read_table('br_ibge_pib', 'municipios', billing_project_id="<YOUR-PROJECT>")
```

> Caso esteja acessando da primeira vez, vão aparecer alguns passos na tela para autenticar seu projeto - basta segui-los!

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

> Caso esteja acessando da primeira vez, vão aparecer alguns passos na tela para autenticar seu projeto - basta segui-los!

### Veja todos os datasets disponíveis

```python
import basedosdados as bd

bd.list_datasets()
```

Para saber mais, veja os [exemplos](https://github.com/basedosdados/mais/tree/master/examples) ou a [documentação da API](https://basedosdados.github.io/mais/py_reference_api/)

# Usando em R

### Instale
```R
install.packages("basedosdados")

# ou a versão de desenvolvimento

devtools::install_github("basedosdados/mais", subdir = "r-package")
```

### Faça uma consulta

```r
library(basedosdados)

set_billing_id("id do seu projeto aqui") # autenticação para acesso aos dados

pib_per_capita <- " 
SELECT 
    pib.id_municipio ,
    pop.ano, 
    pib.PIB / pop.populacao * 1000 as pib_per_capita
FROM `basedosdados.br_ibge_pib.municipios` as pib
INNER JOIN `basedosdados.br_ibge_populacao.municipios` as pop
ON pib.id_municipio = pop.id_municipio AND pib.ano = pop.ano"

(data <- read_sql(pib_per_capita)) # leia os dados em memória
download(pib_per_capita, "pib_per_capita.csv") # salve os dados em disco
```

# Exemplos

Acesse os códigos de análises produzidas em Workshops, Artigos,
Tutoriais e Redes Sociais todas no nosso repositório de
[analises](http://github.com/basedosdados/analises)

# Contribua! 🔄

**Incentivamos que outras instituições e pessoas contribuam**. [Veja mais
como contribuir aqui](https://basedosdados.github.io/mais/colab_data/).

### [Descubra quem contribui com nosso código!](https://github.com/basedosdados/mais/blob/master/CONTRIBUTORS.md)

# Apoie 💚

A Base dos Dados já poupou horas da sua vida? Ou permitiu coisas antes impossíveis? Nosso trabalho é quase todo voluntário, mas temos vários custos de infraestrutura, equipe, e outros.

[Nos ajude a fazer esse projeto se manter e crescer!](https://apoia.se/basedosdados)

# Como citar o projeto 📝

O projeto está licenciado sob a [Licença Hipocrática](https://firstdonoharm.dev/version/2/1/license.html). Sempre que usar os dados cite a fonte como:

Português:
> Carabetta, João; Dahis, Ricardo; Israel, Fred; Scovino, Fernanda (2020) Base dos Dados: Repositório de Dados Abertos em https://basedosdados.org.

Inglês:
> Carabetta, João; Dahis, Ricardo; Israel, Fred; Scovino, Fernanda (2020) Data Basis: Open Data Repository at https://basedosdados.org.

# Idiomas

Documentação está em português (quando possível), código e configurações
estão em inglês.

# Docs (dev)
Atualize os docs adicionando ou editando `.md` em `docs/`.

Se for adicionar um arquivo novo, adicione ele em `mkdocs.yml` sob a chave `nav`.

Para testar a documentação, rode:

```sh
mkdocs serve 
```
