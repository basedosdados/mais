
<!-- Header -->
<p align="center">
  <a href="https://basedosdados.github.io/mais/">
    <img src="docs/images/bdmais_logo.png" width="340" alt="Base dos Dados Mais">
  </a>
</p>


<p align="center">
    <em>Mecanismo de busca e <b>repositório</b> de bases de dados brasileiras e internacionais.</em>
</p>

---

# Base dos Dados Mais

Uma simples consulta de SQL é o suficiente para cruzamento de bases que
você desejar. Sem precisar procurar, baixar, tratar, comprar um servidor
e subir clusters.

Nosso repositório traz acesso, rapidez, escala, facilidade, economia, 
curadoria, e transparência ao cenário de dados no Brasil.


[![Whatch](https://img.shields.io/github/watchers/jonsn0w/hyde.svg?style=social)](https://github.com/basedosdados/mais/subscription)
[![Star](https://img.shields.io/github/stars/jonsn0w/hyde.svg?style=social)](https://github.com/basedosdados/mais/stargazers)
[![Tweet](https://img.shields.io/twitter/url/https/github.com/jonsn0w/hyde.svg?style=social)](https://twitter.com/intent/tweet?text=Baixe%20e%20faça%20queries%20em%20dados%20publicos,%20tratados%20e%20gratuitos%20com%20a%20Base%20dos%20Dados%20Mais%20🔍%20➕:%20https://basedosdados.github.io/mais/%20via%20@basedosdados)

<!-- <p float="left">
  <img src="docs/images/bq_button.png" href="https://console.cloud.google.com/bigquery?p=basedosdados&page=project" width="300" />
  <img src="docs/images/docs_button.png" href="basedosdados.github.io/mais" width="300" />
</p> -->

## Quick Start

<div class="row" style="margin:400px;display:flex;flex-direction:row;justify-content:center;align-content:stretch;flex-flow: column wrap;">


  [![](docs/images/bq_button.png)](https://console.cloud.google.com/bigquery?p=basedosdados&page=project)

  [![](docs/images/docs_button.png)](https://basedosdados.github.io/mais)
  
</div>

### Por que o BigQuery?

- **Acesso**: É possível deixar os dados públicos, i.e., qualquer
  pessoa com uma conta no Google Cloud pode fazer uma query na base,
  quando quiser.
- **Rapidez**: Uma query muito longa não demora menos de minutos para
  ser processada.
- **Escala**: O BigQuery escala magicamente para hexabytes se necessário.
- **Facilidade**: Você pode cruzar tabelas tratadas e atualizadas num só lugar.
- **Economia**: O custo é praticamente zero para usuários - **1
  TB gratuito por mês para usar como quiser**. Depois disso, são cobrados
  somente 5 dólares por TB de dados que sua query percorrer.

---

### Instale nosso CLI

[![](docs/images/bdd_install.png)](basedosdados.github.io/mais)

## Contribua! 💚

**Incentivamos que outras instituições e pessoas contribuam**. Veja mais
como contribuir [aqui](https://basedosdados.github.io/mais/github/).

---

## Como citar o projeto 📝

O projeto está licenciado sob a [Licença Hipocrática](https://firstdonoharm.dev/version/2/1/license.html). Sempre que usar os dados cite a fonte como:

> Carabetta, J.; Dahis, R.; Israel, F.; Scovino, F. (2020) Base dos Dados Mais: Repositório de Dados. Github - https://github.com/basedosdados/mais.

## Idiomas

Documentação está em português (quando possível), código e configurações
estão em inglês.

-----

## Desenvolvimento

#### CLI

Suba o CLI localmente

```sh
make create-env
. .bases/bin/activate
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
