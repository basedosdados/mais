
# Suba dados na BD+

## Por que minha organização deve subir dados na BD+?

- **Capacidade de cruzar suas bases com dados de diferentes
  organizações** de forma simples e fácil. Já são centenas de conjuntos
  dados públicos das maiores organizações do Brasil e do mundo presentes
  no nossod *datalake*.

- **Compromisso com a transparência, qualidade dos dados e
  desenvolvimento de melhores pesquisas, análises e soluções** para a
  sociedade. Não só democratizamos o acesso a dados abertos, mas dados
  de qualidade. Temos um time especializado que revisa e garante a qualidade dos
  dados adicionados ao *datalake*.

- **Participação de uma comunidade que cresce cada vez mais**: milhares
  de jornalistas, pesquisadores(as), desenvolvedores(as), já utilizam e
  acompanham a Base dos Dados.
  <!-- TODO: Colocar aqui o link do nosso painel de audiencia quando tiver pronto :) -->

## Passo a passo para subir dados

Quer subir dados na BD+ e nos ajudar a construir esse repositório?
*Maravilha!* Organizamos tudo o que você precisa no manual abaixo, em 10 passos.

Para facilitar a explicação, vamos seguir um exemplo já pronto com dados da [RAIS](https://basedosdados.org/dataset/br-me-rais).

!!! Tip "Você pode navegar pelas etapas no menu à esquerda."
    Sugerimos fortemente que entre em nosso [canal no
    Discord](https://discord.gg/huKWpsVYx4) para tirar dúvidas e
    interagir com a equipe e outros(as) colaboradores(as)! 😉

### Antes de começar

Alguns conhecimentos são necessárias para realizar esse processo:

- **Python, R, SQL e/ou Stata**, para criar os códigos de captura e limpeza dos dados.
- **Linha de comando**, para configurar seu ambiente local
  e conexão com o Google Cloud.
- **Github**, para subir seu código para revisão da
  nossa equipe.

!!! Tip "Não tem alguma dessas habilidades mas quer colaborar?"
    Temos um time de dados que pode te ajudar, basta entrar no [nosso
    Discord](https://discord.gg/huKWpsVYx4) e mandar uma mensagem em #quero-contribuir.

### 1. Informar seu interesse para a gente

Mantemos a lista de conjuntos que ainda não estão na BD+ no nosso [Github](https://github.com/basedosdados/mais/issues?q=is%3Aopen+is%3Aissue+label%3Adata+label%3Aenhancement). Para começar a subir uma base do seu interesse, basta abrir um [novo issue](https://github.com/basedosdados/mais/issues/new?assignees=&labels=data&template=br_novos_dados.md&title=%5Bdados%5D+%3Cdataset_id%3E) de dados e preencher as informações indicadas por lá.

!!! Info "Caso sua base (conjunto) já esteja listada, basta marcar seu usuário do Github como `assignee`."

### 2. Configure suas credenciais localmente e prepare o ambiente

No seu terminal:

1. Instale nosso cliente: `pip install basedosdados`.
2. Rode `basedosdados config init` e siga o passo a passo para configurar localmente com as credenciais de seu projeto no Google Cloud.

> Caso seu ambiente de produção não permita o uso interativo do nosso cliente ou apresente alguma outra dificuldade relativa a esse modo de configuração, você pode configurar o `basedosdados` a partir de variáveis de ambiente da seguinte forma:
>
>```bash
> export BASEDOSDADOS_CONFIG=$(cat ~/.basedosdados/config.toml | base64)
> export BASEDOSDADOS_CREDENTIALS_PROD=$(cat ~/.basedosdados/credentials/prod.json | base64)
> export BASEDOSDADOS_CREDENTIALS_STAGING=$(cat ~/.basedosdados/credentials/staging.json | base64)
>```
>
3. Clone um _fork_ do nosso [repositório](https://github.com/basedosdados/mais) localmente.
4. Dê um `cd` para a pasta local do repositório e abra uma nova branch
   com `git checkout -b [BRANCH_ID]`. Todas as adições e modificações
   serão feitas nessa _branch_.

### 3. Baixar nossa pasta _template_ para dados

[Baixe aqui a pasta
_template_](https://drive.google.com/drive/folders/1xXXon0vdjSKr8RCNcymRdOKgq64iqfS5?usp=sharing)
para a pasta ``dados`` e renomeie para o nome do seu conjunto de dados, `<dataset_id>`
([veja aqui como nomear seu conjunto](../style_data)). Ela facilita todos os
passos daqui pra frente. Sua
estrutura é a seguinte:

- `<dataset_id>/`
    - `code/`: Códigos necessários à **captura** e **limpeza** dos dados
    ([veja no passo
    5](#5-escrever-codigo-de-captura-e-limpeza-de-dados)).
    - `input/`: Contém todos os arquivos com dados originais, exatamente
    como baixados da fonte primária **Esses arquivos não devem ser
    modificados.**
    - `output/`: Arquivos finais, já no formato pronto para subir na BD+.
    - `tmp/`: Quaisquer arquivos temporários criados pelo código em `/code` no processo de limpeza e tratamento.
    - `extra/`
        - `architecture/`: Tabelas de arquitetura ([veja no passo 4](#4-preencher-as-tabelas-de-arquitetura)).
        - `auxiliary_files/`: Arquivos auxiliares aos dados ([veja no passo 6](#6-caso-necessario-organizar-arquivos-auxiliares)).
        - `dicionario.csv`: Tabela dicionário de todo o conjunto de dados ([veja no passo
          7](#7-caso-necessario-criar-tabela-dicionario)).

!!! info "As pastas input, output e tmp não serão commitadas para o seu projeto e existirão apenas localmente"

### 4. Preencher as tabelas de arquitetura

As tabelas de arquitetura determinam **qual a estrutura de
cada tabela do seu conjunto de dados**. Elas definem, por exemplo, o nome, ordem e metadados das colunas, e
como uma coluna deve ser tratada quando há mudanças em versões (por
exemplo, e uma coluna muda de nome de um ano para o outro).

!!! Info "Cada tabela do conjunto de dados deve ter sua própria tabela de arquitetura (planilha), que pode ser preenchida no Google Drive ou localmente (Excel, editor de texto)."

<!-- 
TODO: Não vejo relação dessas perguntas com o exemplo dado
da tabela de arquitetura da RAIS.
Perguntas que uma arquitetura deve responder:
* *Quais serão as tabelas finais na base?* Essas não precisam ser
  exatamente o que veio nos dados brutos. -> não tem isso no exemplo
* *Qual é nível da observação de cada tabela?* O "nível da observação" é
  a menor unidade a que se refere cada linha na tabela (ex: municipio-ano, candidato,
  estabelecimento-cnae). -> não tem isso no exemplo
* *Será gerada alguma tabela derivada com agregações em cima dos dados
  originais?* -> não tem isso no exemplo -->

#### Exemplo: RAIS - Tabelas de arquitetura

As tabelas de arquitetura preenchidas [podem ser consultadas aqui](https://drive.google.com/drive/folders/1OtsucP_KhiUEJI6F6k_cagvXfwZCFZF2?usp=sharing). Seguindo nosso [manual de estilo](../style_data), nós renomeamos, definimos o tipo, preenchemos descrições, indicamos se há dicionário ou diretório, preenchemos campos (e.g. cobertura temporal e unidade de medida) e fizemos a compatibilização entre anos para todas as variáveis (colunas).

- **nome:** Nome da coluna
- **tipo:** tipo de dado do BigQuery (veja quais são no nosso [manual de estilo](../style_data/#tipos-de-variaveis))
- **descricao:** Descrição dos dados que estão nesta coluna 
- **unidade_medida:** em qual unidade (no caso de variáveis numéricas) os dados estão
- **dicionario:** podem ser 3 opções
    - diretorio: caso se refira a uma tabela de diretório da BD
    - local: caso se refira a um dicionario no dataset
    - se não houver um dicionário, deixar em branco
- **nome_diretorio:** se a coluna for coberta por um dicionário da BD, usar o formato [DATASET_ID].[TABLE]:[COLUNA]. Caso contrário, deixe em branco

<!-- nos exemplos os nomes de colunas estão diferentes do que o pacote Python testa como obrigatórias -->

Nas tabelas desse conjunto existiam colunas que deixaram de existir em
determinados anos. Por isso, foi necessário compatibilizar:
criamos colunas à direita chamadas `nome_original_YYYY`, em ordem descendente (e.g. 2022,
2021, 2020, ...). Nessas colunas incluímos _todas_ as variáveis de cada
ano.

Para as que foram excluídas da versão em produção,
deixamos seu nome como `(deletado)` e não preenchemos nenhum metadado.
Por exemplo, a coluna `Municipio` da tabela `microdados_vinculos` não
foi adicionada pois por padrão usamos somente o código IBGE para
identificar municípios (seu nome fica numa tabela de
[Diretórios](../style_data/#diretorios)). Logo, ela aparece com o nome
`(deletado)` na respectiva tabela de arquitetura (penúltima linha).

!!! Tip "Quando terminar de preencher as tabelas de arquitetura, entre em contato com a equipe da Base dos Dados ou nossa comunidade para validar tudo. É importante ter certeza que está fazendo sentido _antes_ de começar a escrever código."

### 5. Escrever código de captura e limpeza de dados

Após validadas as tabelas de arquitetura, podemos escrever os códigos de
**captura** e **limpeza** dos dados.

- **Captura**: Código que baixa automaticamente todos os dados originais e os salva em `/input`. Esses dados podem estar disponíveis em portais ou links FTP, podem ser raspados de sites, entre outros.

- **Limpeza**: Código que transforma os dados originais salvos em `/input` nos dados limpos prontos para serem subidos na BD+ salvos em `/output`, tudo baseado nas tabelas de arquitetura.

Cada tabela limpa para produção pode ser salva como um arquivo `.csv` único ou, caso seja muito grande (e.g. acima de 100-200 mb), ser particionada no formato [Hive](https://cloud.google.com/bigquery/docs/hive-partitioned-loads-gcs) em vários sub-arquivos `.csv`. Nossa recomendação é particionar tabelas por `ano`, `mes`, `sigla_uf`, ou no máximo por `id_municipio`.

!!! Tip "No pacote `basedosdados` você encontra funções úteis para limpeza dos dados"
    Definimos funções para particionar tabelas de forma automática,
    criar variáveis comuns (e.g. `sigla_uf` a partir de `id_uf`) e
    outras. Veja em [Python](../api_reference_python) e [R](../api_reference_r)

#### Padrões necessários no código

- Devem ser escritos em [Python](https://www.python.org/),
  [R](https://www.r-project.org/), ou [Stata](https://www.stata.com/) -
  para que a revisão possa ser realizada pela equipe.
- Pode estar em script (`.py`, `.r`, ...) ou *notebooks* (Google Colab, Jupyter, Rmarkdown, etc).
- Os caminhos de arquivos devem ser atalhos _relativos_ à pasta raíz
  (`<dataset_id>`), ou seja, não devem depender dos caminhos do seu
  computador.
- A limpeza deve seguir nosso [manual de estilo](../style_data) e as [melhores práticas de programação](https://en.wikipedia.org/wiki/Best_coding_practices).

#### Exemplo: RAIS - Código de limpeza

O código de limpeza foi construído em Stata e [pode ser consultado
aqui](https://github.com/basedosdados/mais/tree/master/bases/br_me_rais/code).

A tabela `microdados_vinculos` da RAIS é uma tabela muito grande
(+250GB) por isso nós particionamos por `ano` e `sigla_uf`. O
particionamento foi feito usando a estrutura de pastas
`/microdados_vinculos/ano=YYYY/sigla_uf=XX`.

### 6. (Caso necessário) Organizar arquivos auxiliares

É comum bases de dados serem distribuídas com arquivos auxiliares. Esses podem incluir notas técnicas, descrições de coleta e amostragem, etc. Para ajudar usuários da Base dos Dados terem mais contexto e entenderem melhor os dados, organize todos esses arquivos auxiliares em `/extra/auxiliary_files`.

Fique à vontade para estruturar sub-pastas como quiser lá dentro. O que importa é que fique claro o que são esses arquivos.

### 7. (Caso necessário) Criar tabela dicionário

Muitas vezes, especialmente com bases antigas, há múltiplos dicionários
em formatos Excel ou outros. Na Base dos Dados nós unificamos tudo em um
único arquivo em formato `.csv` - um único dicionário para todas as
colunas de todas as tabelas do seu conjunto.

O uso de dicionários tem seus prós e contras. É bem comum, para quem trabalha
com bancos de dados relacionais (como SQLite, MySQL, MariaDB ou Postgres) o uso
de modelos relacionados para campos de categorias (como, por exemplo, na tabela da RAIS 
o campo tipo_admissao). Vejamos as vantagens e desvantagens:

- vantagens:
    - caso o usuário queira uma lista de valores únicos, ele pode percorrer apenas a tabela dicionário, não precisando percorrer toda a tabela de microdados
    - no momento do tratamento é mais simples detectar erros de digitação em uma determinada categoria, o que causa uma duplicidade incorreta
    - caso o usuário queira exportar os dados ele obterá um arquivo bem menor, otimizando os seus custos de transferência
- desvantagens:
    - quando o usuário precisa fazer uma consulta simples, terá que usar ``JOINS`` para buscar os nomes das categorias
    - ao trabalhar com tais bases, o usuário precisará construir o modelo localmente

!!! Info "Detalhes importantes de como construir seu dicionário estão no nosso [manual de estilo](../style_data/#dicionarios)."

#### Exemplo: RAIS - Dicionário

O dicionário completo [pode ser consultado
aqui](https://docs.google.com/spreadsheets/d/12Wwp48ZJVux26rCotx43lzdWmVL54JinsNnLIV3jnyM/edit?usp=sharing).
Ele já possui a estrutura padrão que utilizamos para dicionários.

### 8. Subir tudo no Google Cloud

Tudo pronto! Agora só falta subir para o Google Cloud e enviar para
revisão. Para isso, vamos usar o cliente `basedosdados` (disponível em
linha de comando e Python) que facilita as configurações e etapas do processo.

#### Configure seu projeto no Google Cloud e um _bucket_ no Google Storage

Os dados vão passar ao todo por 3 lugares no Google Cloud:

1. **Storage**: local onde serão armazenados o arquivos "frios" (arquiteturas, dados, arquivos auxiliares).
2. **BigQuery**: super banco de dados do Google, dividido em 2 projetos/tipos de tabela:
    - *Staging*: banco para teste e tratamento final do conjunto de dados
    - *Produção*: banco oficial de publicação dos dados (nosso projeto `basedosdados`! ou o seu mesmo caso queira reproduzir o ambiente)

É necessário ter uma conta Google e um projeto (gratuito) no Google
Cloud. Para criar seu projeto basta:

1. Acessar o [link](https://console.cloud.google.com/projectselector2/home/dashboard) e aceitar o Termo de Serviços do Google Cloud.
2. Clicar em `Create Project/Criar Projeto` - escolha um nome bacana para o seu projeto, ele terá também um `Project ID` que será utilizado para configuração local.
3. Depois de criado o projeto, vá até a funcionalidade de
   [Storage](https://console.cloud.google.com/storage) e crie uma pasta
   (_bucket_) para subir os dados (pode ter o mesmo nome do projeto).



#### Suba e configure uma tabela no seu _bucket_

Aqui são dois passos: primeiro publicamos uma base (conjunto) e depois publicamos tabelas. Este processo
está automatizado na criação das tabelas, conforme abaixo.

<!--

Para publicar uma **base (conjunto)**:

1. Inicialize o conjunto no seu repositório local:

    ```bash
   basedosdados dataset init [DATASET_ID]
    ```

4. Crie o conjunto no *BigQuery* rodando:

    ```bash
    basedosdados dataset create [DATASET_ID]
    ```

5. Preencha os arquivos de configuração criados em `<dataset_id>/`:
    - `README.md`: informações úteis para quem for ver o código no Github.
    - `dataset_config.yaml`: informações específicas do conjunto (já vem
      com um modelo para preenchimento).
6. Atualize as informações preenchidas do conjunto com:

    ```bash
    basedosdados dataset update [DATASET_ID]
    ```
-->

Para publicar o dataset e a(s) **tabela(s)**:

1. Crie a tabela no *bucket*, indicando o caminho do arquivo no seu local, rodando o seguinte comando no seu terminal:

    ```bash
    basedosdados table create [DATASET_ID] [TABLE_ID] --path <caminho_para_os_dados> --force_dataset False --if_table_exists raise --if_storage_data_exists raise --if_table_config_exists raise --columns_config_url <url_da_planilha_google>
    ```

    Se preferir, você pode usar a API do Python, da seguinte forma:

    ```python
    import basedosdados as bd
    
    tb = bd.Table(dataset_id=<dataset_id>, table_id=<table_id>)
    tb.create(
        path='caminho_para_os_dados',
        force_dataset=False,
        if_table_exists='raise',
        if_storage_data_exists='raise',
        if_table_config_exists='raise',
    )
    ```

    Os seguintes parâmetros podem ser usados (no terminal ou no Python):

    ```bash
    --path [Obrigatório] o caminho completo do arquivo no seu computador, como:
       '/Users/<seu_usuario>/projetos/basedosdados/mais/bases/[DATASET_ID]/output/microdados[.csv]'    
       caso seus dados sejam particionados, o caminho deve apontar para a pasta onde estão as partições.
       caso contrário, deve apontar para um arquivo csv (por exemplo, microdados.csv)
   
    --force_dataset [True|False] cria os arquivos de configuração do dataset locais e no BigQuery
       True: os arquivos de configuração do dataset serão criados no seu projeto e, caso ele não exista
             no BigQuery, será criado automaticamente. se você já tiver criado e configurado o dataset,
             NÃO USE ESTA OPÇÃO, POIS IRÁ SOBRESCREVER SEUS ARQUIVOS!!!!!
       False: o dataset não será recriado e, se não existir, será criado automaticamente
   
    --if_table_exists [raise|replace|pass] o que fazer se a tabela já existir
       raise: retorna um erro
       replace: substitui a tabela atual
       pass: não faz nada

    --if_storage_data_exists [raise|replace|pass] o que fazer se os dados já existirem no Google Cloud Storage
       raise: retorna um erro
       replace: substitui os dados existentes
       pass: não faz nada
   
    --if_table_config_exists [raise|replace|pass]
       raise: retorna mensagem de erro
       replace: substitui as configurações da tabela existentes
       pass: não faz nada
   
    --columns_config_url [google sheets url]
       a url da planilha do Google com a arquitetura. deve estar no formato 
       https://docs.google.com/spreadsheets/d/<table_key>/edit#gid=<table_gid>.
       certifique-se de que a planilha está compartilhada com a opção "qualquer pessoa com o link pode ver"

    ```
!!! Info "se o projeto não existir no BigQuery, ele será autmaticamente criado, junto com os arquivos README.md e dataset_config.yaml, que deverão ser preenchidos, segundo o modelo já criado"

2. Preencha os arquivos de configuração da tabela:

- `/[TABLE_ID]/table_config.yaml`: informações específicas da tabela.
- `/[TABLE_ID]/publish.sql`: aqui você pode indicar tratamentos finais
    na tabela `staging` em SQL para publicação (ex: modificar a query para
    dar um JOIN em outra tabela da BD+ e selecionar variáveis).

3. Publique a tabela em produção:

    ```bash
    basedosdados table publish [DATASET_ID] [TABLE_ID]
    ```

Consulte também nossa [API](../api_reference_cli) para mais detalhes de cada método.

!!! Tip "Abra o console do BigQuery e rode algumas _queries_ para testar se foi tudo publicado corretamente. Estamos desenvolvendo testes automáticos para facilitar esse processo no futuro."

### 9. Validar os metadados para publicação

Para validar os metadados preenchidos nos arquivos `dataset_config.yaml` e `table_config.yaml`, o processo é simples.

<!--
1. Coloque suas credenciais do CKAN no arquivo
   `~/.basedosdados/config.toml`, preenchendo os campos `api_key` e
   `url` em `[ckan]`. Este arquivo é criado automaticamente ao rodar
   `basedosdados config init` [(veja no passo
   7)](#7-subir-tudo-no-google-cloud).
-->
1. Valide os metadados do conjunto através do comando `basedosdados metadata validate [DATASET_ID]`. Para validar metadados de tabelas, basta rodar `basedosdados metadata validate [DATASET_ID] [TABLE_ID]`.
2. Após a revisão da nossa equipe, os dados serão publicados no CKAN
<!--
3. Publique os metadados do conjunto já preenchidos e validados com
   `basedosdados metadata publish [DATASET_ID]`. Para publicar metadados
   de tabelas, use `basedosdados metadata publish [DATASET_ID]
   [TABLE_ID]`.

> Para publicar metadados de ambos (conjunto e tabela), use
> `basedosdados metadata publish [DATASET_ID] [TABLE_ID] --all=True`.
-->

#### Atualizando metadados de bases ou tabelas já existentes

Através do módulo `metadata` é possível também trabalhar com bases e tabelas já existentes na plataforma. Elas podem ser atualizadas a partir do procedimento que descrevemos a seguir.

1. Rode `basedosdados metadata create [DATASET_ID]` para puxar os
   metadados do conjunto disponíveis no site para o arquivo
   `dataset_config.yaml`. Para puxar metadados de tabelas, use
   `basedosdados metadata create [DATASET_ID] [TABLE_ID]`, que irá
   atualizo arquivo `table_config.yaml`
2. Preencha os novos valores de metadados nos respectivos arquivos.
3. Rode `basedosdados metadata validate [DATASET_ID]` <!-- e para publicar os
   metadados atualizados do conjutno use `basedosdados metadata publish [DATASET_ID]`. O mesmo pode ser feito
   para tabela adicionando o parametro `[TABLE_ID]` -->

### 10. Enviar tudo para revisão

Ufa, é isso! Agora só resta enviar tudo para revisão no
[repositório](https://github.com/basedosdados/mais) da Base dos Dados.
Crie os _commits_ necessários e rode `git push origin [BRANCH_ID]`.
Depois é só abrir um _pull request_ (PR) no nosso repositório.

**E agora?** Nossa equipe irá revisar os dados e metadados submetidos
via Github. Podemos entrar em contato para tirar dúvidas ou solicitar
mudanças no código. Quando tudo estiver OK, fazemos um _merge_ do seu
*pull request*, e os dados são automaticamente publicados na nossa
plataforma!
