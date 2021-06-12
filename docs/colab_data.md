
# Dados na BD+

Nosso objetivo na Base dos Dados Mais (BD+) é criar um repositório de dados **universal** e de **alta qualidade**.

* **Universal**: Isso significa, em princípio, incluir todas as bases de dados do Brasil e do mundo. Pouco ambicioso né :-).

* **Alta qualidade**: Ter alta qualidade significa manter todos nossos dados estruturados, limpos, bem documentados, consistentes entre si e atualizados.

Isso já é um desafio em projetos pequenos, e é ainda mais _em escala_. Por isso, desenvolvemos e seguimos uma série de padrões e procedimentos de controle de qualidade, e criamos uma infraestrutura para facilitar a subida de dados por qualquer pessoa ou instituição (do nosso time de dados ou colaboradores externos).

# Colaborando com Dados

Quer subir dados na BD+ e nos ajudar a construir esse repositório? Maravilha! Vamos seguir com os passos abaixo.

Ao longo da explicação, vamos sempre seguir um exemplo já pronto com dados da [RAIS](https://basedosdados.org/dataset/br-me-rais).

!!! Tip "Sugerimos que entre em nosso [canal no Discord](https://discord.gg/2GAuw7d8zd) para tirar dúvidas e interagir com outros(as) colaboradores(as)! :)"

## Qual o procedimento?

1. [Informe seu interesse para a gente](#1-informe-seu-interesse-para-a-gente).
2. [Baixar nossa pasta _template_ para dados](#2-baixar-nossa-pasta-template-para-dados).
3. [Preencher as tabelas de arquitetura](#3-preencher-as-tabelas-de-arquitetura).
4. [Escrever código de captura e limpeza de dados](#4-escrever-codigo-de-captura-e-limpeza-de-dados).
5. [Organizar arquivos auxiliares, se necessário](#5-organizar-arquivos-auxiliares-se-necessario).
6. [Criar tabela dicionário, se necessário](#6-criar-tabela-dicionario-se-necessario).
7. [Subir arquiteturas, dados e arquivos auxiliares no Google Cloud](#7-subir-arquiteturas-dados-e-arquivos-auxiliares-no-google-cloud).
8. [Enviar tudo para revisão](#8-enviar-tudo-para-revisao).

## 1. Informe seu interesse para a gente

Mantemos metadados de bases que ainda não estão na BD+ em nossa [tabela de prioridade de bases](https://docs.google.com/spreadsheets/d/1jnmmG4V6Ugh_-lhVSMIVu_EaL05y1dX9Y0YW8G8e_Wo/edit?usp=sharing). Para subir uma base de seu interesse na BD+, adicione os seus metadados de acordo com as colunas da tabela.

- **Inclua uma linha por tabela do conjunto de dados.**
- **Preencha os campos cuidadosamente**. Além dos dados gerais sobre a tabela, adicione as classificações de `Facilidade` e `Importância` e o campo de `Prioridade` será gerado automaticamente.
- Por fim, **crie um issue no Github com o [template "Novos dados"](https://github.com/basedosdados/mais/issues/new?assignees=rdahis&labels=data&template=br_novos_dados.md&title=%5Bdados%5D+%3Cadd+nome%2C+ex%3A+Censo+Escolar+INEP%3E)**

!!! Info "Caso sua base já esteja listada, basta marcar seu usuário do Github na coluna `Pessoa responsável`."

!!! Info "Fique à vontade para conversar com a gente e tirar dúvidas direto no nosso servidor no [Discord](https://discord.gg/2GAuw7d8zd)."

## 2. Baixar nossa pasta _template_ para dados

Baixe [aqui](https://drive.google.com/drive/folders/1xXXon0vdjSKr8RCNcymRdOKgq64iqfS5?usp=sharing) a nossa pasta _template_ para colaboração de dados, e renomeie ela para `<dataset_id>`. Ela facilita todos os passos daqui pra frente.

Sua estrutura é bem simples:

- `/<dataset_id>`
  - `/code`
      - Contém todos os _scripts_ (códigos) necessários à captura e limpeza dos dados (discutido no passo [4](#4-escrever-codigo-de-captura-e-limpeza-de-dados)).
      - Nessa configuração, toda a estrutura de código será com atalhos _relativos_ à pasta raíz, usando as demais pastas criadas.
  - `/input`
      - Contém todos os arquivos com dados originais, exatamente como baixados da fonte primária.
      - *Esses arquivos não devem jamais ser modificados.*
  - `/output`
      - Contém arquivos finais, já no formato pronto para subir na BD+.
  - `/tmp`
      - Contém quaisquer arquivos temporários criados pelo código em `/code` no processo de limpeza e tratamento.
  - `/extra`
      - `/architecture`
          - Contém as tabelas de arquitetura (discutido no passo [3](#3-preencher-as-tabelas-de-arquitetura)).
      - `/auxiliary_files`
          - Contém quaisquer arquivos auxiliares aos dados (discutido no passo [5](#5-se-necessario-organizar-arquivos-auxiliares)).
      - `dicionario.csv`
          - Tabela dicionário mapeando chaves a valores para todas as tabelas da base (discutido no passo [6](#6-se-necessario-criar-tabela-dicionario)).

## 3. Preencher as tabelas de arquitetura

Definir e preencher as tabelas de arquitetura são partes fundamentais da colaboração de dados. É aqui que (1) definimos como estarão estruturadas as tabelas em produção, (2) discutimos nomeação e ordenamento de colunas, (3) preenchemos os metadados de colunas, e (4) compatibilizamos dados entre anos quando há inconsistências.

Cada base tem 1 ou mais tabelas de dados. Cada tabela de dados tem sua tabela de arquitetura.

Tabelas de arquitetura podem ser preenchidas no Google Drive ou localmente (Excel, editor de texto).

Perguntas que uma arquitetura deve responder:

- *Quais serão as tabelas finais na base?* Essas não precisam ser exatamente o que veio nos dados brutos.
- *Qual é nível da observação de cada tabela?* O "nível da observação" é
  a menor unidade a que se refere cada linha na tabela (ex: municipio-ano, candidato,
  estabelecimento-cnae).
- *Será gerada alguma tabela derivada com agregações em cima dos dados originais?*

No exemplo da RAIS, [aqui](https://drive.google.com/drive/folders/1OtsucP_KhiUEJI6F6k_cagvXfwZCFZF2?usp=sharing) estão as tabelas de arquitetura já preenchidas. Sempre seguindo nosso [manual de estilo](/mais/style_data), nós renomeamos, definimos o tipo, preenchemos descrições, indicamos se há dicionário ou diretório, preenchemos campos (e.g. cobertura temporal e unidade de medida) e fizemos a compatibilização entre anos para todas as variáveis (colunas).

A compatibilização entre anos, caso necessária, é feita criando novas colunas à direita chamadas `nome_original_YYYY`, em ordem temporal descendente (2021, 2020, 2019, ...). Nessas colunas incluímos _todas_ as variáveis de cada ano. Para as que forem eventualmente excluídas da versão em produção, deixamos seu nome como `(deletado)` e não preenchemos nenhum metadado.

!!! Tip "Quando terminar de preencher as tabelas de arquitetura, entre em contato com a equipe da Base dos Dados ou nossa comunidade para validar tudo. É importante ter certeza que está fazendo sentido _antes_ de começar a escrever código."

## 4. Escrever código de captura e limpeza de dados

Depois de validadas as tabelas de arquitetura podemos escrever o código de captura e limpeza dos dados. Exigimos que tudo esteja escrito em [Python](https://www.python.org/), [R](https://www.r-project.org/), ou [Stata](https://www.stata.com/). Podem ser código padrão ou cadernos (Colab, Jupyter, Rmarkdown, etc).

No exemplo da RAIS, temos todo o código escrito em Stata para consulta [aqui](https://github.com/basedosdados/mais/tree/master/bases/br_me_rais/code).

#### Captura

Esse script baixa automaticamente todos os dados originais e os salva em `/input`. Esses dados podem estar disponíveis em portais ou links FTP, podem ser raspados de sites, entre outros.

#### Limpeza

Esse script transforma os dados originais salvos em `/input` nos dados limpos prontos para serem subidos na BD+ salvos em `/output`, tudo baseado nas tabelas de arquitetura.

Cada tabela limpa para produção pode ser salva como um arquivo `.csv` único ou, caso seja muito grande (e.g. acima de 100-200 mb), ser particionada no formato [Hive](https://cloud.google.com/bigquery/docs/hive-partitioned-loads-gcs) em vários sub-arquivos `.csv`. Nossa recomendação é particionar tabelas por `ano`, `mes`, `sigla_uf`, ou no máximo por `id_municipio`. Para a tabela `microdados_vinculos` da RAIS nós particionamos por `ano` e `sigla_uf`, com a estrutura de pastas sendo `/microdados_vinculos/ano=YYYY/sigla_uf=XX`.

Nós já criamos funções úteis para limpeza nas nossas APIs de Python e R. Por exemplo, com o pacote `basedosdados` você pode ler tabelas muito grandes, particionar tabelas automaticamente, gerar certas variáveis comuns (e.g. `sigla_uf` a partir de `id_uf`), etc.

Tudo nesse passo deve seguir nosso [manual de estilo](/mais/style_data) e as [melhores práticas de programação]((https://en.wikipedia.org/wiki/Best_coding_practices)).

## 5. Se necessário, organizar arquivos auxiliares

É comum bases de dados serem distribuídas com arquivos auxiliares. Esses podem incluir notas técnicas, descrições de coleta e amostragem, etc. Para ajudar usuários da Base dos Dados terem mais contexto e entenderem melhor os dados, organize todos esses arquivos auxiliares em `/extra/auxiliary_files`.

Fique à vontade para estruturar sub-pastas como quiser lá dentro. O que importa é que fique claro o que são esses arquivos.

## 6. Se necessário, criar tabela dicionário

É também comum que bases de dados grandes sejam estruturadas de forma a precisar de um dicionário. Para poupar espaço, variáveis STRING são convertidas em variáveis numéricas com cada chave mapeando um valor único. Muitas vezes, especialmente com bases antigas, há múltiplos dicionários em formatos Excel ou outros. Na Base dos Dados nós unificamos tudo em um único arquivo em formato `.csv`.

Descrevemos nossas várias diretrizes para dicionários no nosso [manual de estilo](/mais/style_data). Por exemplo:

- Cada base inclui somente um dicionário (que cobre uma ou mais tabelas).
- Para cada tabela, coluna e cobertura temporal, cada chave mapeia unicamente um valor.
- Chaves não podem ter valores nulos.
- Dicionários devem cobrir todas as chaves disponíveis nas tabelas originais.
- Chaves não possuem zeros à esquerda. Exemplo: `01` deveria ser `1`.
- Valores são padronizados: sem espaços extras, inicial maiúscula e resto minúsculo, etc.

No exemplo da RAIS nós criamos um dicionário completo [aqui](https://docs.google.com/spreadsheets/d/12Wwp48ZJVux26rCotx43lzdWmVL54JinsNnLIV3jnyM/edit?usp=sharing).

## 7. Subir arquiteturas, dados e arquivos auxiliares no Google Cloud

Tudo pronto! Agora só falta subir as coisas para o Google Cloud e depois enviar para revisão.

Desenvolvemos um cliente `basedosdados` (disponível para linha de comando e Python por enquanto) para facilitar esse processo e indicar configurações básicas que devem ser preenchidas sobre os dados.

#### Configure seu projeto no Google Cloud e um _bucket_ no Google Storage

Os dados vão passar ao todo por 3 lugares no Google Cloud:

1. Storage: local onde serão armazenados o arquivos (arquiteturas, dados, arquivos auxiliares).
2. BigQuery: banco de dados do Google, dividido em 2 projetos/tipos de tabela:
    - Staging: banco para teste e tratamento final do conjunto de dados
    - Produção: banco oficial de publicação dos dados (`basedosdados`! ou o seu mesmo caso queira reproduzir o ambiente)

Para criar um projeto no Google Cloud basta ter um email cadastrado no Google. Seguindo o passo-a-passo:

- Acesse o [link](https://console.cloud.google.com/projectselector2/home/dashboard) e aceite o Termo de Serviços do Google Cloud.
- Clique em `Create Project/Criar Projeto` - escolha um nome bacana para o seu projeto, ele terá também um `Project ID` que será utilizado para configuração local.
- Depois de criado o projeto, vá até a funcionalidade de [Storage](https://console.cloud.google.com/storage) e crie uma pasta, seu _bucket_, para você subir os dados.

#### Configure o CLI localmente, clone nosso repositório e abra uma nova _branch_

No seu terminal:

- Instale nosso cliente: `pip install basedosdados`.
- Rode `basedosdados config` e siga o passo a passo para configurar localmente com as credenciais de seu projeto no Google Cloud.
- Clone um _fork_ do nosso [repositório](https://github.com/basedosdados/mais) localmente.
- Dê um `cd` para a pasta local do repositório e abra uma nova branch com `git checkout -b [BRANCH_ID]`.

Todas as adições e modificações serão feitas nessa _branch_.

#### Suba e configure uma tabela no seu _bucket_

Aqui são dois passos: primeiro publicamos uma base e depois publicamos tabelas.

- Publique uma base.
    - Rode o comando `basedosdados dataset create [DATASET_ID] --raw_path '/[DATASET_ID]/input' --auxiliary_files_path '/[DATASET_ID]/extra/auxiliary_files'`.
    - Preencha os arquivos de configuração da base:
        - `README.md`: informações básicas da base de dados aparecendo no Github.
        - `dataset_config.yaml`: informações específicas da base de dados.
    - Rode o comando `basedosdados dataset update [DATASET_ID]` para atualizar a base com as configurações preenchidas.
- Publique uma tabela (ou várias!) dentro da base
    - Rode o comando `basedosdados table create [DATASET_ID] [TABLE_ID] --data_path '/[DATASET_ID]/output/[TABLE_ID]' --architecture_path '/[DATASET_ID]/extra/architecture/[TABLE_ID]'`.
    - Preencha os arquivos de configuração da tabela:
        - `/[TABLE_ID]/table_config.yaml`: informações específicas da tabela.
        - `/[TABLE_ID]/publish.sql`: aqui você pode fazer tratamentos finais na tabela `staging` em SQL para publicação. Exemplo: modificar a query para dar um JOIN em outra tabela da BD+ e selecionar variáveis.
    - Rode o comando `basedosdados table publish [DATASET_ID] [TABLE_ID]` para publicar a tabela em produção.

Consulte também nossa [API](/mais/reference_api_cli) para mais detalhes de cada método.

É sempre bom abrir o console do BigQuery e rodar algumas _queries_ para testar se foi tudo publicado corretamente. Estamos desenvolvendo testes automáticos para facilitar esse processo no futuro.

## 8. Enviar tudo para revisão

Ufa, é isso! Agora só resta enviar tudo para revisão no [repositório](https://github.com/basedosdados/mais) da Base dos Dados.

Crie os _commits_ necessários e rode um `git push origin [BRANCH_ID]`. Depois é só abrir um _pull request_ (PR) no nosso repositório.

Temos passos manuais e automáticos de revisão para dados e metadados. Pessoas do time da Base dos Dados entrarão em contato com você para pedir mudanças ou tirar dúvidas. Quando tudo estiver redondo nós fazemos um _merge_ e os dados são publicados na nossa plataforma.
