# Diretrizes de nomes para tabelas e conjuntos

As bases devem ser organizadas no BigQuery de maneira **consistente**, que
permita uma **busca fácil e intuitiva**, e seja **escalável**.

As diretrizes definidas para nomenclatura dos conjuntos (*datasets*) e
tabelas )*tables*) estão descritas abaixo.

!!! Info "O BigQuery permite busca por nome da tabela, conjunto ou rótulo (*label*), incluindo correspondências parciais."

|           | Conjunto (*dataset*)                         | Tabela (*table*)                |
|-----------|----------------------------------------------|---------------------------------|
| Mundial   | mundo_<instituicao\>_<descricao\>                         | <descricao\>                    |
| Federal   | <pais_sigla\>\_<instituicao\>_<descricao\>                         | <descricao\>                    |
| Estadual  | <pais_sigla\>\_<estado_sigla\>\_<instituicao\>_<descricao\>             | <descricao\>                    |
| Municipal | <pais_sigla\>\_<estado_sigla\>\_<cidade\>\_<instituicao\>_<descricao\>   | <descricao\>                   |

Os componentes dos nomes são:

- `mundo/pais_sigla/estado_sigla/cidade`: Abrangência da **instituição** - e não os dados (ex: IBGE tem abrangência `br`)
- `instituicao`: Nome ou sigla (de preferência) da instituição que
  publicou os dados orginais.
- `descricao`: Nome descritivo e **único** para cada tabela e *dataset*
  (nome da tabela basta ser único dentro do *datatset*).

!!! Info "Se atente ao modo de escrita"
    - Utilize somente letras minúsculas
    - Remova acentos, pontuações e espaços
    - Separe palavras por `_`

??? Tip "Não sabe como nomear a instituição?"
    Sugerimos que vá no site da mesma e veja como ela se autodenomina (ex: DETRAN-RJ seria `br-rj-detran-rj`)

## Exemplos

|           |                                           |                                                     |
|-----------|-------------------------------------------|-----------------------------------------------------|
| Mundial   | `mundo_waze.alertas`                      | Dados de alertas do Waze de diferentes cidades.    |
| Federal   | `br_tse_eleicoes.candidatos`              | Dados de candidatos a cargos políticos do TSE.      |
| Federal   | `br_ibge_pnad.pnad_microdados`            | Microdados da Pesquisa Nacional por Amostra de Domicílios produzidos pelo IBGE. |
| Federal   | `br_ibge_pnad.pnad_contínua_microdados`   | Microdados da Pesquisa Nacional por Amostra de Domicílios Contínua (PNAD-C) produzidos pelo IBGE. |
| Estadual  | `br_sp_see_docentes.carga_horaria`        | Carga horária anonimizado de docentes ativos da rede estadual de ensino de SP. |
| Municipal | `br_rj_riodejaneiro_cmrj_legislativo.votacoes` | Dados de votação da Câmara Municipal do Rio de Janeiro (RJ). |

## Bases Desejadas

[Lista de bases mapeadas](https://docs.google.com/spreadsheets/d/1jnmmG4V6Ugh_-lhVSMIVu_EaL05y1dX9Y0YW8G8e_Wo/edit?usp=sharing) que estão no nosso mapa. Cada base a ser adicionada possui uma issue relacionada no Github - [acompanhe e contribua](https://github.com/basedosdados/mais/labels/data)!

## Temas e Identificadores

OS identificadores listados abaixo são os mesmos do mecanismo de busca
da Base dos Dados, mas temas podem ser adicionados e trocados. O BigQuery permite que sejam adicionados
rótulos (*labels*) às tabelas, que também funcionam para a busca de dados.

!!! Warning "Os rótulos ainda não são obrigatórios, sugerimos a busca pela instituição ou descrição dos dados."

| Tema                                     | Identificador (rótulo)    |
|------------------------------------------|------------------|
| Agropecuária                             | agropecuaria     |
| Ciência, Tecnologia e Inovação           | ciencia-tec-inov |
| Cultura e Arte                           | cultura-arte     |
| Diversidade e Inclusão                   | diversidade      |
| Educação                                 | educacao         |
| Energia                                  | energia          |
| Esportes                                 | esportes         |
| Economia                                 | economia         |
| Governo e Finanças Públicas              | gov-fin-pub      |
| História                                 | historia         |
| Infraestrutura e Transportes             | infra-transp     |
| Jornalismo e Comunicação                 | comunicacao      |
| Meio Ambiente                            | meio-ambiente    |
| Justiça                                  | justica          |
| Organização Territorial                  | territorio       |
| Política                                 | politica         |
| População                                | populacao        |
| Religião                                 | religiao         |
| Segurança, Crime, Violência e Conflito   | seguranca        |
| Saúde                                    | saude            |
| Turismo                                  | turismo          |
| Urbanização                              | urbanizacao      |