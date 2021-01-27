<!-- Header -->
<p align="center">
  <a href="https://basedosdados.github.io/mais/">
    <img src="images/bdmais_logo.png" width="340" alt="Base dos Dados Mais">
  </a>
</p>

<p align="center">
    <em>Trabalhando pela universalização do uso de dados no Brasil</em>
</p>

---

# Base dos Dados Mais

A missão da [Base dos Dados](https://basedosdados.org/) é **universalizar o uso de dados** no Brasil. Acreditamos que a distância entre uma pessoa e uma análise deveria ser apenas uma boa ideia.

Para realizar essa visão, nós construímos a Base dos Dados Mais (BD+): um repositório integrado de dados. Essa ferramenta traz acesso, rapidez, escala, facilidade, economia, curadoria, e transparência ao cenário de dados no Brasil.

Todos os nossos dados ficam organizados e disponíveis na nuvem dentro da ferramenta da Google chamada [BigQuery](https://cloud.google.com/bigquery).

Uma simples consulta de SQL é o suficiente para cruzamento de bases que você desejar. Sem precisar procurar, baixar, tratar, comprar um servidor e subir clusters na nuvem.

### Por que o BigQuery?

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

<div align="center">
    <a align="center"
    href="https://console.cloud.google.com/bigquery?p=basedosdados&page=project"
    title="{{ lang.t('source.link.title')}}" class="md-button">
        Clique para acessar o projeto no BigQuery
    </a>
</div>


----

## Quick Start

<div class="row">
    <div class="column">
    <a style="width: 90%; text-align: center;"
    href="/access_data_bq"
    title="{{ lang.t('source.link.title')}}" class="md-button">
        Acesse os dados direto pelo BigQuery 🔍
    </a>
    </div>
    <div class="column">
    <a style="width: 90%; text-align: center;"
    href="/access_data_local"
    title="{{ lang.t('source.link.title')}}" class="md-button">
        Acesse os dados pelo seu computador (CLI/API) 👩🏻‍💻
    </a>
    </div>
</div>

-----
## Como citar o projeto

O projeto está licenciado sob a [Licença Hipocrática](https://firstdonoharm.dev/version/2/1/license.html). Sempre que usar os dados cite a fonte como:

> Carabetta, J.; Dahis, R.; Israel, F.; Scovino, F. (2020) Base dos Dados Mais: Repositório de Dados. Github - https://github.com/basedosdados/mais.

-----
## Idiomas

Documentação está em português (quando possível), código e configurações estão em inglês.
