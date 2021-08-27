
# Pacotes

Os pacotes da Base dos Dados permitem o acesso aos dados do nosso
*datalake* público direto do seu terminal ou ambiente de
desenvolvimento. Atualmente, o pacote está disponível para Python, R e
CLI (linha de comando).

Quer seguir na sua linguagem favorita? Veja com configurar seu ambiente
nas linguagens:

- Python
- R
- CLI (terminal)

## Antes de começar: Crie o seu projeto no Google Cloud

Para criar um projeto no Google Cloud basta ter um email cadastrado no
Google. É necessário ter um projeto seu, mesmo que vazio, para você
fazer queries em nosso *datalake* público.

1. **[Acesse o Google Cloud](https://console.cloud.google.com/projectselector2/home/dashboard)**.
   Caso for a sua primeira vez, aceite o Termo de Serviços.
3. **Clique em `Create Project/Criar Projeto`**. Escolha um nome bacana para o projeto.
5. **Clique em `Create/Criar`**

??? Info "Por que eu preciso criar um projeto no Google Cloud?"
    A Google fornece 1 TB gratuito por mês de uso do BigQuery para cada
    projeto que você possui. Um projeto é necessário para ativar os
    serviços do Google Cloud, incluindo a permissão de uso do BigQuery.
    Pense no projeto como a "conta" na qual a Google vai contabilizar o
    quanto de processamento você já utilizou. **Não é necessário adicionar
    nenhum cartão ou forma de pagamento.**

    - Rapidez: Mesmo queries muito longas demoram apenas minutos para serem processadas.

    - Escala: O BigQuery escala magicamente para hexabytes se necessário.

    - Facilidade: Você pode cruzar tabelas tratadas e atualizadas num só lugar.

    - Economia: O BigQuery permite que a consulta seja diretamente do usuário. Porém, são fornecidos **1 TB gratuito por mês gratuitos para quaisquer consultas de dados**. Ou seja, o custo é praticamente zero para a maioria dos usuários. Depois disso, são cobrados somente 5 dólares por TB de dados que sua query percorrer.

## Instalando o pacote

Para instalação do pacote em Python e linha de comando, você pode usar o
`pip` direto do seu terminal. Em R, basta instalar diretamente no
RStudio ou editor de sua preferência.

=== "R"
    ```R
    install.packages("basedosdados")
    ```

=== "Python/CLI"
    ```bash
    pip install basedosdados
    ```

=== "Stata"
    ```bash
    # Ainda não temos suporte :( 
    # Seja a primeira pessoa a contribuir (veja Issue #83 no GitHub)!
    ```


## Configurando o pacote

Uma vez com seu projeto, você precisa configurar o pacote para usar o ID
desse projeto nas consultas ao *datalake*. Para isso, você deve usar o
`Project ID/ID do projeto` que a Google fornece para você assim que o
projeto é criado.

![](images/project_id_example.png)

=== "R"
    *Uma vez com o `Project ID/ID do projeto`, você deve passar essa
    informação para o pacote usando a função `set_billing_id`.*
    ```R
    set_billing_id("<YOUR_PROJECT_ID>")
    ```

=== "Python/CLI"
    *Não é necessário configurar o projeto de antemão. Assim que você
    roda a 1ª consulta, o pacote irá indicar os passos para configuração.*

## Rodando um exemplo

Um exemplo simples para começar a explorar o *datalake* é puxar
[informações cadastrais de
municípios](https://basedosdados.org/dataset/br-bd-diretorios-brasil/resource/9046b938-b361-4c3c-a5e7-a549dfc48f2b)
direto na nossa base de diretórios brasileiros. Para isso, vamos usar a
função `download`, baixando os dados direto para nossa máquina.

=== "R"
    ```R
    library("basedosdados")
    query <- "SELECT * FROM `basedosdados.br_bd_diretorios_brasil.municipio`"
    dir <- tempdir()
    data <- download(query, file.path(dir, "municipio.csv"))
    ```

    *Para entender mais sobre a função `download`, leia o [manual de referência](/reference_api_r).*
    
=== "Python"
    ```python
    import basedosdados as bd
    bd.download(savepath="where/to/save/file",
    dataset_id="br-bd-diretorios-brasil", table_id="municipio")
    ```

    *Para entender mais sobre a função `download`, leia o [manual de referência](/reference_api_py).*

=== "CLI"
    ```bash
    basedosdados download "where/to/save/file" \
    --billing_project_id <YOUR_PROJECT_ID> \
    --query 'SELECT * FROM `basedosdados.br_bd_diretorios_brasil.municipio`'
    ```
    *Para entender mais sobre a função `download`, leia o [manual de referência](/reference_api_cli).*
    
## Próximos passos

### Entenda os dados

O BigQuery possui já um mecanismo de busca que permite buscar por nomes
de *datasets* (conjuntos), *tables* (tabelas) ou *labels* (grupos).
Construímos regras de nomeação simples e práticas para facilitar sua
busca - veja mais [na seção de Nomenclatura](/style_data).

### Tutoriais

- [Como funcionam os nomes de conjuntos e tabelas]()
- [Como cruzar tabelas de diferentes organizações](/tutorial_cross_table)