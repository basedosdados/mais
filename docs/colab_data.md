# Colaborando com dados na BD+

Para criar um repositório integrado de dados públicos precisamos subir
bases de dados de centenas de fontes e também mantê-las **consistentes
entre si, atualizadas, e úteis**.

Nossa intenção é que **qualquer pessoa possa colaborar** com seu
conhecimento sobre dados públicos, seguindonossa metodologia e
procedimentos de limpeza e validação dos dados.

!!! Tip "Sugerimos que entre em nosso [canal no Discord](https://discord.gg/T2nbPNty) para tirar dúvidas e interagir com outrxs colaboradorxs! :)"

## Qual o procedimento?

Adicionar bases novas na BD+ deve seguir nosso fluxo de trabalho:

1. [Informe seu interesse para a gente](#1-informe-seu-interesse-para-a-gente).
3. [Limpe e trate dados](#2-limpe-e-trate-os-dados).
3. [Suba dados no BigQuery](#3-suba-dados-no-bigquery)
4. [Envie código e dados prontos para revisão.](#4-envie-codigo-e-dados-prontos-para-revisao) 

## 1. Informe seu interesse para a gente

Mantemos metadados de bases que ainda não estão no BD+ em nossa
[tabela de prioridade de bases](https://docs.google.com/spreadsheets/d/1jnmmG4V6Ugh_-lhVSMIVu_EaL05y1dX9Y0YW8G8e_Wo/edit?usp=sharing).
Para subir uma base de seu interesse no BD+, adicione os seus metadados
acordo com as colunas da tabela.

- **Inclua uma linha por tabela do conjunto de dados.**
- **Preencha os campos cuidadosamente**. Além dos dados gerais sobre a
  tabela, adicione as classificações de `Facilidade` e `Importância` e o
  campo de `Prioridade` será gerado automaticamente.
- Por fim, **crie um issue no Github com o [template "Novos dados"](https://github.com/basedosdados/mais/issues/new?assignees=&labels=data&template=br_novos_dados.md&title=Base%3A+%3Cadd+nome%2C+ex%3A+Censo+Escolar+INEP%3E)**

!!! Info "Caso sua base já esteja listada, basta marcar seu usuário do Github na coluna `Pessoa responsável`."

## 2. Limpe e trate os dados

#### Captura dos dados
De início, baixe os dados originais (idealmente forma automatizada, mas
não obrigatório) e organize os dados numa pasta `/input` com atalho relativo à
pasta raiz incluindo o código. - TODO: como explicar melhor aqui?

#### Arquitetura dos dados

É muito importante pensar a arquitetura da base **antes de se começar a
limpeza**. Perguntas que uma arquitetura deve responder:

- *Quais serão as tabelas finais na base?* Essas não precisam ser exatamente o que veio nos dados brutos.
- *Qual é nível da observação de cada tabela?* O "nível da observação" é
  a menor unidade a que se refere cada linha na tabela (ex: municipio-ano, candidato,
  estabelecimento-cnae).
- É preciso fazer algum tipo de `reshape` na tabela, de `wide` para
  `long` ou vice-versa? - TODO: como explicar melhor aqui?
- Será gerada alguma tabela derivada com agregações em cima dos dados originais?

#### Limpeza dos dados

A limpeza de dados é parte fundamental da nossa estrutura. O código deve seguir [boas práticas de
programação](https://en.wikipedia.org/wiki/Best_coding_practices) na
linguagem e sua preferência, e os dados devem ser tratados garantindo
que:

- As colunas seguem as [diretrizes Base dos Dados](/style_namind_columns)
- Os valores seguem as [diretrizes Base dos Dados](/style_data)

!!! Tip "Sugerimos as linguagens [Python](https://www.python.org/), [R](https://www.r-project.org/), ou [Stata](https://www.stata.com/)."


## 3. Suba dados no BigQuery

Desenvolvemos um cliente `basedosdados` (disponível para linha de
comando e Python por enquanto) para facilitar esse processo e indicar
configurações básicas que devem ser preenchidas sobre os dados.

1. Configure seu projeto no Google Cloud e um _Bucket_ no Google Storage

TODO: add explicação geral + revisar passo a passo com clareza.

Agora no seu terminal:
- Instale nosso cliente: `pip install basedosdados`
- Rode e siga o passo a passo para configurar localmente com as
  credenciais de seu projeto no Googl Cloud: `basedosdados config`

2. Suba e configure uma tabela no seu _Bucket_

- Siga o comando `basedosdados table create [DATASET_ID] [TABLE_ID]`.
- Preencha todos os arquivos de configuração:
    - `README.md`: informações básicas da base de dados aparecendo no Github
    - `dataset_config.yaml`: informações específicas da base de dados
    - `/<table_id>/table_config.yaml`: informações específicas da tabela
    - `/<table_id>/publish.sql`: informações da publicação da tabela (os
      tipos de variáveis do
      [BigQuery](https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types)
      são `STRING`, `INT64`, `FLOAT64`, `DATE`)

3. Publique a versão pronta no seu _bucket_ com: `basedosdados table
   publish`.

!!! Tip "Consulte nossa [API](/cli_reference_api) para mais detalhes de cada método."

## 4. Envie código e dados prontos para revisão

Basta seguir o passo a passo do comando `basedosdados table release`.
Isto irá criar um pull request no nosso Github para validarmos.

As etapas de validação que seguimos (devem ser feitas por outra pessoa
além de quem subiu os dados) são:

- Testar a query sem limite de observações;
- Revisar todos os campos dos arquivos de configuração;
- Checar nomeação de variáveis e formatos e unidades de dados de acordo com nosso manual de estilo.
