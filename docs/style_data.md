
# Manual de estilo

Nessa seção listamos todos os padrões do nosso manual de estilo e diretrizes de dados que usamos na Base dos Dados. Eles nos ajudam a manter os dados e metadados que publicamos com qualidade alta.

!!! Tip "Você pode usar o menu esquerdo para navegar pelos diferentes tópicos dessa página."
<!-- **Resumo**:

- [Nomeação de bases e tabelas](#nomeação-de-bases-e-tabelas)
- [Formatos de tabelas](#formatos-de-tabelas)
- [Nomeação de variáveis](#nomeacao-de-variaveis)
- [Ordenamento de variáveis](#ordenamento-de-variáveis)
- [Tipos de variáveis](#tipos-de-variaveis)
- [Unidades de medida](#unidades-de-medida)
- [Quais variáveis manter, quais adicionar e quais remover](#quais-variáveis-manter-quais-adicionar-e-quais-remover)
- [Cobertura temporal](#cobertura-temporal)
- [Limpando STRINGs](#limpando-strings)
- [Formatos de valores](#formatos-de-valores)
- [Particionamento de tabelas](#particionamento-de-tabelas)
- [Número de bases por _pull request_](#número-de-bases-por-pull-request)
- [Dicionários](#dicionarios)
- [Diretórios](#diretorios) -->

---

## Nomeação de bases e tabelas

### Conjuntos de dados (`dataset_id`)

Nomeamos conjuntos no formato `<organization_id\>_<descrição\>`, onde
`organization_id` segue por padrão a **abrangência geográfica da
organização** que publica o conjunto:

|           | organization_id                         | 
|-----------|----------------------------------------------|
| Mundial   | mundo_<organizacao\>                         |
| Federal   | <sigla_pais\>\_<organizacao\>                         |
| Estadual  | <sigla_pais\>\_<sigla_uf\>\_<organizacao\>             |
| Municipal | <sigla_pais\>\_<sigla_uf\>\_<cidade\>\_<organizacao\>   |

* `sigla_pais` e `sigla_uf` são sempre 2 letras minúsculas;
* `organizacao` é o nome ou sigla (de preferência) da organização que
  publicou os dados orginais (ex: `ibge`, `tse`, `inep`).
* `descricao` é uma breve descrição do conjunto de dados, que pode ser

Por exemplo, o conjunto de dados do PIB do IBGE tem como `dataset_id`: `br_ibge_pib`

!!! Tip "Não sabe como nomear a organização?"
    Sugerimos que vá no site da mesma e veja como ela se autodenomina (ex: DETRAN-RJ seria `br_rj_detran`)

### Tabelas

Nomear tabelas é algo menos estruturado e, por isso, requer bom senso. Mas temos algumas regras:

- Se houver tabelas para diferentes entidades, incluir a entidade no começo do nome. Exemplo: `municipio_valor`, `uf_valor`.
- Não incluir a unidade temporal no nome. Exemplo: nomear `municipio`, e não `municipio_ano`.
- Deixar nomes no singular. Exemplo: `escola`, e não `escolas`.
- Nomear de `microdados` as tabelas mais desagregadas. Em geral essas tem dados a nível de pessoa ou transação.

### Exemplos de `dataset_id.table_id`

|           |                                           |                                                     |
|-----------|-------------------------------------------|-----------------------------------------------------|
| Mundial   | `mundo_waze.alertas`                      | Dados de alertas do Waze de diferentes cidades.    |
| Federal   | `br_tse_eleicoes.candidatos`              | Dados de candidatos a cargos políticos do TSE.      |
| Federal   | `br_ibge_pnad.microdados`                 | Microdados da Pesquisa Nacional por Amostra de Domicílios produzidos pelo IBGE. |
| Federal   | `br_ibge_pnadc.microdados`                | Microdados da Pesquisa Nacional por Amostra de Domicílios Contínua (PNAD-C) produzidos pelo IBGE. |
| Estadual  | `br_sp_see_docentes.carga_horaria`        | Carga horária anonimizado de docentes ativos da rede estadual de ensino de SP. |
| Municipal | `br_rj_riodejaneiro_cmrj_legislativo.votacoes` | Dados de votação da Câmara Municipal do Rio de Janeiro (RJ). |

## Formatos de tabelas

Tabelas devem, na medida do possível, estar no formato `long`, ao invés de `wide`.

## Nomeação de variáveis

Nomes de variáveis devem respeitar algumas regras:

- Usar ao máximo nomes já presentes no repositório. Exemplos: `ano`, `mes`, `id_municipio`, `sigla_uf`, `idade`, `cargo`, `resultado`, `votos`, `receita`, `despesa`, `preco`, etc.
- Respeitar padrões das tabelas de diretórios.
- Ser o mais intuitivo, claro e extenso possível.
- Ter todas letras minúsculas (inclusive siglas), sem acentos, conectados por `_`.
- Não incluir conectores como `de`, `da`, `dos`, `e`, `a`, `em`, etc.
- Só ter o prefixo `id_` quando a variável representar chaves primárias de entidades (que eventualmente teriam uma tabela de diretório).
    - Exemplos que tem: `id_municipio`, `id_uf`, `id_escola`, `id_pessoa`.
    - Exemplos que não tem: `rede`, `localizacao`.
- Só ter sufixos de entidade quando a entidade da coluna for diferente da entidade da tabela.
    - Exemplos que tem: numa tabela com entidade `pessoa`, uma coluna sobre PIB municipal se chamaria `pib_municipio`.
    - Exemplos que não tem: numa tabela com entidade `pessoa`, características da pessoa se chamariam `nome`, `idade`, `sexo`, etc.
- Lista de **prefixos permitidos**
    - `nome_`, `data_`, `numero_`, `quantidade_`, `proporcao_` (variáveis de porcentagem 0-100%), `taxa_`, `razao_`,  `indice_`, `indicador_`, `tipo_`, `sigla_`, `sequencial_`.
- Lista de **sufixos comuns**
    - `_pc` (per capita)

## Ordenamento de variáveis

A ordem de variáveis em tabelas é padronizada para manter uma consistência no repositório. Nossas regras são:

- Chaves primárias à esquerda, em ordem descendente de abrangência. Exemplo de ordem: `ano`, `sigla_uf`, `id_municipio`, `id_escola`, `nota_ideb`.    
- Agrupar e ordenar variáveis por importância ou temas.

## Tipos de variáveis

Nós utilizamos algumas das opções de [tipos do BigQuery](https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types): `STRING`, `INT64`, `FLOAT64`, `DATE`, `TIME`, `GEOGRAPHY`.

Quando escolher:

- `STRING`:
    - Variáveis de texto
    - Chaves de variáveis categóricas com dicionário ou diretório
- `INT64`:
    - Variáveis de números inteiros com as quais é possível fazer contas (adição, subtração).
- `FLOAT64`:
    - Variáveis de números com casas decimais com as quais é possível fazer contas (adição, subtração).
- `DATE`:
    - Variáveis de data no formato `YYYY-MM-DD`.
- `TIME`:
    - Variáveis de tempo no formato `HH:MM:SS`.
- `GEOGRAPHY`:
    - Variáveis de geografia.

## Unidades de medida

A regra é manter variáveis com suas unidades de medida originais, com a exceção de variáveis financeiras onde convertermos moedas antigas para as atuais (e.g. Cruzeiro para Real).

Catalogamos unidades de medida em formato padrão na tabela de arquitetura. Exemplos: `m`, `km/h`, `BRL`.

Variáveis devem ter sempre unidades de medida com base 1. Ou seja, ter `BRL` ao invés de `1000 BRL`, ou `pessoa` ao invés de `1000 pessoas`. Essa informação, como outros metadados de colunas, são registradas na tabela de arquitetura da tabela.

## Quais variáveis manter, quais adicionar e quais remover

Mantemos nossas tabelas parcialmente [normalizadas](https://www.guru99.com/database-normalization.html), e temos regras para quais variáveis incluirmos em produção. Elas são:

- Remover variáveis de nomes de entidades que já estão em diretórios. Exemplo: retirar `municipio` da tabela que já inclui `id_municipio`.
- Remover variáveis servindo de partição. Exemplo: remover `ano` e `sigla_uf` se a tabela é particionada nessas duas dimensões.
- Adicionar chaves primárias principais para cada entidade já existente. Exemplo: adicionar `id_municipio` a tabelas que só incluem `id_municipio_tse`.
- Manter todas as chaves primárias que já vem com a tabela, mas (1) adicionar chaves relevantes (e.g. `sigla_uf`, `id_municipio`) e (2) retirar chaves irrelevantes (e.g. `regiao`).

## Cobertura temporal

Preencher a coluna `cobertura_temporal` nos metadados de tabela, coluna e chave (em dicionários) segue o seguinte padrão.

- Formato geral: `data_inicial(unidade_temporal)data_final`
    - `data_inicial` e `data_final` estão na correspondente unidade temporal.
        - Exemplo: tabela com unidade `ano` tem cobertura `2005(1)2018`.
        - Exemplo: tabela com unidade `mes` tem cobertura `2005-08(1)2018-12`.
        - Exemplo: tabela com unidade `dia` tem cobertura `2005-08-01(1)2018-12-31`.
- Regras para preenchimento
    - Metadados de tabela
        - Preencher no formato geral.
    - Metadados de coluna
        - Preencher no formato geral, exceto quando a `data_inicial` ou `data_final` sejam iguais aos da tabela. Nesse caso deixe vazio.
        - Exemplo: suponha que a cobertura da tabela seja `2005(1)2018`.
            - Se uma coluna aparece só em 2012 e existe até 2018, preenchemos sua cobertura como `2012(1)`.
            - Se uma coluna desaparece em 2013, preenchemos sua cobertura como `(1)2013`.
            - Se uma coluna existe na mesma cobertura temporal da tabela, preenchemos sua cobertura como `(1)`.
    - Metadados de chave
        - Preencher no mesmo padrão de colunas, mas a referência sendo a coluna correspondente, e não a tabela.

## Limpando STRINGs

- Variáveis categóricas: inicial maiúscula e resto minúsculo, com acentos.
- STRINGs não-estruturadas: manter igual aos dados originais.

## Formatos de valores

- Decimal: formato americano, i.e. sempre `.` (ponto) ao invés de `,` (vírgula).
- Data: `YYYY-MM-DD`
- Horário (24h): `HH:MM:SS`
- Datetime ([ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)): `YYYY-MM-DDTHH:MM:SS.sssZ`
- Valor nulo: `""` (csv), `NULL` (Python), `NA` (R), `.` ou `""` (Stata)
- Proporção/porcentagem: entre 0-100

## Particionamento de tabelas

Uma tabela particionada é uma tabela especial dividida em segmentos, chamados de partições, que facilitam o gerenciamento e a consulta de seus dados. Ao dividir uma grande tabela em partições menores, você pode melhorar o desempenho da consulta e pode controlar os custos reduzindo o número de bytes lidos por uma consulta. Por isso, sempre recomendamos que tabelas grandes sejam particionadas. Leia mais a respeito na [documentação da Google Cloud](https://cloud.google.com/bigquery/docs/partitioned-tables).

Note que ao particionar uma tabela é preciso excluir a coluna correspondente. Exemplo: é preciso excluir a coluna `ano` ao particionar por `ano`.

Colunas comuns para usar como partição: `ano`, `mes`, `sigla_uf`, `id_municipio`.

## Número de bases por _pull request_

Pull requests no Github devem incluir no máximo uma base. Ou seja, podem envolver uma ou mais tabela intra-base.

## Dicionários

- Cada base inclui somente um dicionário (que cobre uma ou mais tabelas).
- Para cada tabela, coluna, e cobertura temporal, cada chave mapeia unicamente um valor.
- Chaves não podem ter valores nulos.
- Dicionários devem cobrir todas as chaves disponíveis nas tabelas originais.
- Chaves só podem possuir zeros à esquerda quando o número de dígitos da variável tiver significado. Quando a variável for `enum` padrão, nós excluimos os zeros à esquerda.
    - Exemplo: mantemos o zero à esquerda da variável `br_bd_diretorios_brasil.cbo_2002:cbo_2002`, que tem seis dígitos, pois o primeiro dígito `0` significa a categoria ser do `grande grupo = "Membros das forças armadas, policiais e bombeiros militares"`.
    - Para outros casos, como por exemplo `br_inep_censo_escolar.turma:etapa_ensino`, nós excluimos os zeros à esquerda. Ou seja, mudamos `01` para `1`.
- Valores são padronizados: sem espaços extras, inicial maiúscula e resto minúsculo, etc.

## Diretórios

Diretórios são as pedras fundamentais da estrutura do nosso _datalake_. Nossas regras para gerenciar diretórios são:

- Diretórios representam _entidades_ do repositório que tenham chaves primárias (e.g. `uf`, `município`, `escola`) e unidades de data-tempo (e.g. `data`, `tempo`, `dia`, `mes`, `ano`).
- Cada tabela de diretório tem ao menos uma chave primária com valores únicos e sem nulos. Exemplos: `municipio:id_municipio`, `uf:sigla_uf`.
- Nomes de variáveis com prefixo `id_` são reservadas para chaves
  primárias de entidades.

Veja todas as [tabelas já disponíveis aqui.](https://basedosdados.org/dataset?organization=br-bd&order_by=score&q=%22diret%C3%B3rios%22)

## **Pensou em melhorias para os padrões definidos?**

Abra um [issue no nosso Github](https://github.com/basedosdados/mais/labels/docs) ou mande uma mensagem no [Discord](https://discord.gg/huKWpsVYx4) para conversarmos :)
