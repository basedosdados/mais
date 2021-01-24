
# Limpando dados

!!! Info "Essa página expande o passo (5) do fluxo de trabalho resumido [aqui](/data_start/#fluxo-de-trabalho)."

A limpeza de dados é parte fundamental da nossa estrutura. O código deve seguir [boas práticas de programação](https://en.wikipedia.org/wiki/Best_coding_practices).

## Linguagens

Nossas linguagens permitidas são [Python](https://www.python.org/), [R](https://www.r-project.org/), e [Stata](https://www.stata.com/).

## Arquitetura da base de dados

É muito importante pensar a **arquitetura da base** _antes_ de se começar a limpeza dos dados.

Perguntas que uma arquitetura deve responder:

1. Quais serão as tabelas finais na base?
    - Essas não precisam ser exatamente o que veio nos dados brutos.
2. Qual é nível da observação de cada tabela?
    - O "nível da observação" é o que representa cada linha na tabela.
        - Exemplos: municipio-ano, candidato, estabelecimento-cnae.
    - É preciso fazer algum tipo de `reshape` na tabela, de `wide` para `long` ou vice-versa?
3. Será gerada alguma tabela derivada com agregações em cima dos dados originais?
