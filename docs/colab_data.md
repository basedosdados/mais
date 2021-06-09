
# Colaborando com dados na BD+

Para criar um repositório integrado de dados públicos precisamos subir bases de dados de centenas de fontes e também mantê-las **consistentes entre si, atualizadas, e úteis**.

Nossa intenção é que **qualquer pessoa possa colaborar** com seu conhecimento sobre dados públicos, seguindo nossas metodologias e procedimentos de limpeza e validação dos dados.

!!! Tip "Sugerimos que entre em nosso [canal no Discord](https://discord.gg/2GAuw7d8zd) para tirar dúvidas e interagir com outros(as) colaboradores(as)! :)"

## Qual o procedimento?

Adicionar bases novas na BD+ deve seguir nosso fluxo de trabalho:

informar interesse

preencher arquitetura (uma arquitetura por tabela)
  pegar nosso template
  confirmar com equipe da BD que faz sentido

escrever código
  captura de dados
  limpeza de dados
  criar tabela dicionário se necessário

subir dados no BigQuery
  preencher arquivos de configuração (automaticamente)

envie código e dados prontos para revisão



Quer testar se entendeu tudo? Tenta replicar do zero nosso exemplo de base.
  Pasta com dados:
  br_me_rais
    code (em Python ou R)
      download
      clean
    raw
    output
      <table_id>
    extra
      architecture
        <table_id>
      auxiliary_files
      dicionario
  Pasta com configs prontos

Passos de código
1. Instalar e configurar o CLI.
  `pip install basedosdados`
2. Dar um fork no repositório no Github.
3. Clonar seu fork localmente e abrir uma nova branch.
4. Criar a tabela no BigQuery
  `basedosdados table create br_me_rais microdados --path br_me_rais/output/<table_id>`
5. Preencher os configs
6. Publicar tabela no BigQuery
  `basedosdados table publish br_me_rais microdados`
7. Abrir PR no `mais` original.


Temos um nível alto de exigência. Para garantir que colaboradores pegaram tudo, nós organizamos um exemplo do produto final.
Para garantir que você entendeu tudo, 
tente replicar do zero o processo de limpeza 





1. [Informe seu interesse para a gente](#1-informe-seu-interesse-para-a-gente).
2. [Limpe e trate dados](#2-limpe-e-trate-os-dados).
3. [Suba dados no BigQuery](#3-suba-dados-no-bigquery)
4. [Envie código e dados prontos para revisão.](#4-envie-codigo-e-dados-prontos-para-revisao) 

## 1. Informe seu interesse para a gente

Mantemos metadados de bases que ainda não estão na BD+ em nossa
[tabela de prioridade de bases](https://docs.google.com/spreadsheets/d/1jnmmG4V6Ugh_-lhVSMIVu_EaL05y1dX9Y0YW8G8e_Wo/edit?usp=sharing).
Para subir uma base de seu interesse na BD+, adicione os seus metadados
acordo com as colunas da tabela.

- **Inclua uma linha por tabela do conjunto de dados.**
- **Preencha os campos cuidadosamente**. Além dos dados gerais sobre a
  tabela, adicione as classificações de `Facilidade` e `Importância` e o
  campo de `Prioridade` será gerado automaticamente.
- Por fim, **crie um issue no Github com o [template "Novos dados"](https://github.com/basedosdados/mais/issues/new?assignees=rdahis&labels=data&template=br_novos_dados.md&title=%5Bdados%5D+%3Cadd+nome%2C+ex%3A+Censo+Escolar+INEP%3E)**

!!! Info "Caso sua base já esteja listada, basta marcar seu usuário do Github na coluna `Pessoa responsável`."

## 2. Limpe e trate os dados

#### Estrutura de pastas

Sugerimos a seguinte estrutura local da pasta que você irá trabalhar num determinado conjunto de dados:

- `nome_conjunto` (um conjunto pode ter mais de uma tabela aqui)
  - `/code`
      - Pasta onde ficam todos os _scripts_ (códigos) necessários à
        limpeza dos dados. Nessa configuração, toda a estrutura de código
        será com atalhos _relativos_ à pasta raíz, usando as demais pastas criadas.
  - `/input`
      - Pasta onde ficam todos os arquivos com dados originais, como
        baixados da fonte primária. *Esses arquivos não devem jamais ser modificados.*
  - `/output`
      - Pasta para arquivos finais, já no formato e conteúdo prontos para subir na BD+.
  - `/tmp`
      - Pasta usada para quaisquer arquivos temporários criados pelos códigos em `/code` no processo de limpeza e tratamento.

#### Captura dos dados

De início, baixe os dados originais e os organize na pasta `/input`. Idealmente esse processo deve ser automatizado por um _script_ específico que possa ser reutilizado, mas isso não é obrigatório.

#### Arquitetura dos dados

É muito importante pensar a arquitetura da base **antes de se começar a
limpeza**. Perguntas que uma arquitetura deve responder:

- *Quais serão as tabelas finais na base?* Essas não precisam ser exatamente o que veio nos dados brutos.
- *Qual é nível da observação de cada tabela?* O "nível da observação" é
  a menor unidade a que se refere cada linha na tabela (ex: municipio-ano, candidato,
  estabelecimento-cnae).
- Será gerada alguma tabela derivada com agregações em cima dos dados originais?

#### Limpeza dos dados

A limpeza de dados é parte fundamental da nossa estrutura. O código deve seguir [boas práticas de
programação](https://en.wikipedia.org/wiki/Best_coding_practices) na
linguagem de sua preferência, e os dados devem ser tratados garantindo
que:

- As colunas seguem as [diretrizes Base dos Dados](/mais/style_naming_columns)
- Os valores seguem as [diretrizes Base dos Dados](/mais/style_data)

!!! Tip "Sugerimos as linguagens [Python](https://www.python.org/), [R](https://www.r-project.org/), ou [Stata](https://www.stata.com/)."


## 3. Suba dados no BigQuery

Desenvolvemos um cliente `basedosdados` (disponível para linha de
comando e Python por enquanto) para facilitar esse processo e indicar
configurações básicas que devem ser preenchidas sobre os dados.

Os dados vão passar ao todo por 3 lugares no Google Cloud:

1. Bucket (Storage): local onde serão armazenados o arquivos frios
2. Big Query: banco de dados do Google, dividido em 2 projetos/tipos de tabela:
    - Staging: banco para teste e tratamento final do conjunto de dados
    - Prod: banco oficial de publicação dos dados (`basedosdados`! ou o seu mesmo caso queira reproduzir o ambiente)


#### Configure seu projeto no Google Cloud e um _bucket_ no Google Storage

Para criar um projeto no Google Cloud basta ter um email cadastrado no
Google. Basta seguir o passo-a-passo:

- Acesse o [link](https://console.cloud.google.com/projectselector2/home/dashboard) e aceite o Termo de Serviços do Google Cloud.
- Clique em `Create Project/Criar Projeto` - escolha um nome bacana para
  o seu projeto, ele terá também um `Project ID` que será utilizado
  para configuração local.
- Depois de criado o projeto, vá até a funcionalidade de
  [Storage](https://console.cloud.google.com/storage) e crie uma
  pasta, seu _bucket_, para você subir os dados.
- Por fim, no seu terminal:
    - Instale nosso cliente: `pip install basedosdados`.
    - Rode `basedosdados config` e siga o passo a passo para configurar localmente com as credenciais de seu projeto no Googl Cloud.

#### Suba e configure uma tabela no seu _bucket_

- Siga o comando `basedosdados table create [DATASET_ID] [TABLE_ID]`.
- Preencha todos os arquivos de configuração:
    - `README.md`: informações básicas da base de dados aparecendo no Github
    - `dataset_config.yaml`: informações específicas da base de dados
    - `/[TABLE_ID]/table_config.yaml`: informações específicas da tabela
    - `/[TABLE_ID]/publish.sql`: informações da publicação da tabela, como os tipos de variáveis do [BigQuery](https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types) (`STRING`, `INT64`, `FLOAT64`, `DATE`), e use também este espaço para escrever tratamentos finais na tabela `staging` em SQL para publicacao
    
Consulte também nossa [API](/mais/reference_api_cli) para mais detalhes de cada método.

#### Publique a versão pronta no seu _bucket_ com `basedosdados table publish`

Após rodar o `publish`, vá no BigQuery e verifique se os dados subiram rodando `SELECT * FROM [PROJECT_ID].[DATASET_ID].[TABLE_ID]`.

## 4. Envie código e dados prontos para revisão

Basta seguir o passo a passo do comando `basedosdados table release`. Isto irá criar um pull request no nosso Github para validarmos.

As etapas de validação que seguimos (devem ser feitas por outra pessoa além de quem subiu os dados) são:

- Testar a query sem limite de observações;
- Revisar todos os campos dos arquivos de configuração;
- Checar nomeação de variáveis e formatos e unidades de dados de acordo com nosso manual de estilo.
