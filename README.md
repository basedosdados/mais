<!-- Header -->
<p align="center">
  <a href="https://basedosdados.org">
    <img src="docs/images/bdmais_logo.png" width="340" alt="Base dos Dados Mais">
  </a>
</p>


<p align="center">
    <em>Universalizando o acesso a dados de qualidade no Brasil.</em>
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
  <a href="https://discord.gg/huKWpsVYx4" target="_blank">
    <img src="https://img.shields.io/discord/787841210433536010" alt="Discord">
  </a>
  <a href="https://apoia.se/basedosdados" target="_blank">
    <img src="https://img.shields.io/badge/apoie!%E2%9D%A4%EF%B8%8F-ff69b4" alt="Apoiase">
  </a>
</p>

**Versões atuais do pacote:**

| ***R*** | ***Python*** |
|-----|-----|
| [![CRAN/METACRAN Version](https://www.r-pkg.org/badges/version/basedosdados)](https://CRAN.R-project.org/package=basedosdados) <br/>  [![CRAN/METACRAN Total downloads](http://cranlogs.r-pkg.org/badges/grand-total/basedosdados?color=blue)](https://CRAN.R-project.org/package=basedosdados) <br/>  [![CRAN/METACRAN downloads per month](http://cranlogs.r-pkg.org/badges/basedosdados)](https://CRAN.R-project.org/package=basedosdados) <br/>  ![Lifecycle: stable](https://img.shields.io/github/issues/basedosdados/mais/R) | [![PyPI version](https://badge.fury.io/py/basedosdados.svg)](https://badge.fury.io/py/basedosdados) <br/> ![PyPI - Downloads](https://img.shields.io/pypi/dm/basedosdados?color=blue) <br/> [![Coverage Status](https://coveralls.io/repos/github/basedosdados/mais/badge.svg?branch=master)](https://coveralls.io/github/basedosdados/mais?branch=master)  <br/> ![Lifecycle: stable](https://img.shields.io/github/issues/basedosdados/mais/Python) |

# O que fazemos?

Tratamos, padronizamos e disponibilizamos bases de dados públicas de
várias fontes como PNAD, RAIS, Censo e DataSUS. A Base dos Dados Mais
(BD+) é um datalake público no Google BigQuery e uma consulta escrita em
SQL é o suficiente para começar a sua análise. 

O datalake com bases padronizadas permite cruzamento de dados oficiais de alta qualidade, que manualmente pode demorar dezenas de horas, com algumas poucas linhas de SQL. Temos bibliotecas em [Python](#usando-em-python) e [R](#usando-em-r) para facilitar o acesso e estamos sempre adicionando novas bases. 

O projeto faz parte da [Base dos Dados](http://basedosdados.org), uma organização sem fins lucrativos com a
missão e universalizar o acesso a dados de qualidade para todes. Veja
mais [quem contribui e como você também pode contribuir](#contribua-).

### [Acesse o projeto no BigQuery ↗️](https://console.cloud.google.com/bigquery?p=basedosdados&page=project)

### [Leia a documentação 📖](https://basedosdados.github.io/mais)

### [Confira exemplos e tutoriais 📊](#exemplos-e-tutoriais)

# Usando em Python


## Instale
```bash
pip install basedosdados
```

## Acesse uma tabela

```python
import basedosdados as bd

df = bd.read_table('br_ibge_pib', 'municipio', billing_project_id="<YOUR-PROJECT>")
```

> Caso esteja acessando da primeira vez, vão aparecer alguns passos na tela para autenticar seu projeto - basta segui-los!
>
> É necessário criar um projeto para que você possa fazer as queries no nosso repositório. Ter um projeto é de graça e basta ter uma conta Google (seu gmail por exemplo). [Veja aqui como criar um projeto no Google Cloud](https://basedosdados.github.io/mais/access_data_local/#criando-um-projeto-no-google-cloud).
> 
> Se possível, armazene suas credenciais em um arquivo `dotenv`: `"billing_project_id=<suas_credenciais_do_projeto>" >> .env`


## Faça uma consulta

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

## Veja todos os datasets disponíveis

```python
import basedosdados as bd

bd.list_datasets()
```

Para saber mais, veja os [exemplos](https://github.com/basedosdados/analises/tree/main/artigos) ou a [documentação da API](https://basedosdados.github.io/mais/reference_api_py/)

# Usando em R

## Instalação

```R
install.packages("basedosdados")

# ou a versão de desenvolvimento

devtools::install_github("basedosdados/mais", subdir = "r-package")
```
## Consultas

`read_sql` executa queries no banco e as devolve em dataframes (sempre na classe `tibble`), `download` escreve o resultado da query em um arquivo `.csv` no disco.

```r
library(basedosdados)

set_billing_id("id do seu projeto aqui") # autenticação para acesso aos dados

pib_per_capita <- " 
SELECT 
    pib.id_municipio ,
    pop.ano, 
    pib.PIB / pop.populacao as pib_per_capita
FROM `basedosdados.br_ibge_pib.municipio` as pib
  INNER JOIN `basedosdados.br_ibge_populacao.municipio` as pop
  ON pib.id_municipio = pop.id_municipio AND pib.ano = pop.ano"

(data <- read_sql(pib_per_capita)) # leia os dados em memória
download(pib_per_capita, "pib_per_capita.csv") # salve os dados em disco
```

Ou use o nosso backend para o `dplyr` e faça queries com código, sem SQL. 

```r
  query <- basedosdados::bdplyr("br_inep_ideb.municipio") %>% 
    dplyr::select(ano, id_municipio, sigla_uf, ideb) %>% 
    dplyr::filter(sigla_uf == "AC", ano < 2021) %>% 
    dplyr::group_by(ano) %>% 
    dplyr::summarise(ideb_medio = mean(ideb, na.rm = TRUE)) 

  basedosdados::bd_collect(query) # retorne como um tibble
  basedosdados::bd_write_csv(query, "ideb_medio.csv") 
  basedosdados::bd_write_rds(query, "ideb_medio.rds") 
```

`bd_write` é uma extensão para formatos customizados. 

```r
  basedosdados::bd_write(query, .write_fn = writexl::write_xlsx, "ideb_medio.xlsx")
  basedosdados::bd_write(query, .write_fn = jsonlite::write_json, "ideb_medio.json")
  basedosdados::bd_write(query, .write_fn = haven::write_dta, "ideb_medio.dta")
```

O argumento `.write_fn` espera uma função que receba como argumento um tibble e um endereço de escrita, compatível com a interface convencional da língua para escrever arquivos em disco. A princípio, _toda_ função `write_*` disponível no CRAN deve funcionar. 

Caso encontre algum problema no pacote e queira ajudar, basta documentar o problema em um [exemplo mínimo reprodutível](https://pt.stackoverflow.com/questions/264168/quais-as-principais-fun%C3%A7%C3%B5es-para-se-criar-um-exemplo-m%C3%ADnimo-reproduz%C3%ADvel-em-r) e abrir uma issue. 

## Atenção

> Caso esteja acessando da primeira vez, vão aparecer alguns passos na tela para autenticar seu projeto com sua conta google e possivelmente na [Tidyverse API](https://www.tidyverse.org/google_privacy_policy/) - basta segui-los! As credenciais ficam armazenadas no computador então usuários com mais de uma máquina talvez precisem autenticar mais de uma vez.
> É necessário criar um projeto para que você possa fazer as queries no nosso repositório. Ter um projeto é de graça e basta ter uma conta Google (seu gmail por exemplo). [Veja aqui como criar um projeto no Google Cloud](https://basedosdados.github.io/mais/access_data_local/#criando-um-projeto-no-google-cloud).
> Se possível, armazene suas credenciais em um arquivo `dotenv`, em bash o comando é `"billing_project_id=<suas_credenciais_do_projeto>" >> .env`. [Veja aqui como criar um arquivo dotenv](https://towardsdatascience.com/using-dotenv-to-hide-sensitive-information-in-r-8b878fa72020).

# Exemplos e tutoriais

Acesse os códigos de análises produzidas em Workshops, Artigos,
Tutoriais e Redes Sociais todas no nosso repositório de
[analises](http://github.com/basedosdados/analises).

Você pode conferir também tutoriais de como utilizar nossa plataforma no
[Youtube](https://www.youtube.com/c/BasedosDados) e no [blog](http://dev.to/basedosdados).

# Contribua! 🔄

Você pode contribuir de várias maneiras:
- Subindo novos conjuntos de dados
- Melhorando a documentação
- Criando tutoriais e workshops
- Melhorando nossa API em Python
- Melhorando nossa API em R
- Criando checagens automáticas de qualidade de [dados](https://basedosdados.github.io/mais/colab_checks/) e metadados (em Python)
- Melhorando nosso o UX do nosso site (React, CSS, HTML)
- Contribuindo com nossa comunicação e mídias
- Reportando bugs
- Ajudando na captação de recursos
- Nos chamando para aprensetações, simpósios e conferências
- Corrigindo [links quebrados](https://docs.google.com/spreadsheets/d/1vcrf2JGiJfu5_NuiB358mkHZh1sPSyeXOLVHKQMFSMc/edit#gid=1075131026) no site

**Incentivamos que outras instituições e pessoas contribuam**. [Veja mais
como contribuir](https://basedosdados.github.io/mais/colab_data/) e
[descubra quem contribui com nosso
código!](https://github.com/basedosdados/mais/blob/master/CONTRIBUTORS.md)

## Apoie 💚

A Base dos Dados já poupou horas da sua vida? Permitiu coisas antes impossíveis? Nosso trabalho é quase todo voluntário, mas temos vários custos de infraestrutura, equipe, e outros.

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
