# Como acessar os dados localmente
    
<div class="termy">
    ```console
    $ pip install basedosdados
    ```
</div>

Em apenas 3 passos você consegue obter dados estruturados para baixar e
analisar:

1. Instalar a aplicação
2. Criar um projeto no Google Cloud
2. Realizar sua query para explorar os dados

## Instalando a aplicação

=== "CLI"
    ```bash
    pip install basedosdados
    ```

=== "Python"
    ```bash
    pip install basedosdados
    ```

=== "R"
    Ainda não temos suporte oficial para R, mas recomendamos o pacote [bigrquery](https://bigrquery.r-dbi.org/).
    ```bash
    install.packages("bigrquery")
    ```
    Seja a primeira pessoa a contribuir (veja Issue #82 no GitHub)!
=== "Stata"
    ```bash
    # Ainda não temos suporte :( 
    # Seja a primeira pessoa a contribuir (veja Issue #83 no GitHub)!
    ```

## Criando um projeto no Google Cloud

!!! Info "Caso já tenha um projeto próprio, vá direto para a próxima etapa!"


Para criar um projeto no Google Cloud basta ter um email cadastrado no
Google. É necessário ter um projeto seu, mesmo que vazio, para você fazer queries em nosso repositório público. Basta seguir o passo-a-passo:

1. Acesse o link: [https://console.cloud.google.com/projectselector2/home/dashboard](https://console.cloud.google.com/projectselector2/home/dashboard)
2. Aceite o Termo de Serviços do Google Cloud
3. Clique em `Create Project/Criar Projeto`
4. Escolha um nome bacana para o seu projeto :)
5. Clique em `Create/Criar`

Veja que seu projeto tem um `Nome` e um `Project ID` - este segundo é a informação
que você irá utilizar em `<YOUR_PROJECT_ID>` para fazer queries no nosso
repositório público.

![](images/project_id_example.png)

## Fazendo queries

Utilize todo o poder do BigQuery onde quiser. Para obter, filtrar ou
cruzar bases basta escrever a query e carregar em sua linguagem
favorita.

Abaixo você pode seguir um exemplo de **como cruzar as tabelas de população e PIB do
IBGE para obter o PIB per capita de todos os municípios brasileiros
em todos os anos disponíveis**.

=== "CLI"
    ```bash
    basedosdados download "where/to/save/file" \
    --billing_project_id <YOUR_PROJECT_ID> \
    --query '
    SELECT 
        pib.id_municipio, 
        pop.ano,  
        pib.PIB / pop.populacao * 1000 as pib_per_capita 
    FROM `basedosdados.br_ibge_pib.municipios` as pib 
    INNER JOIN `basedosdados.br_ibge_populacao.municipios` as pop 
    ON pib.id_municipio = pop.id_municipio AND pib.ano = pop.ano
    LIMIT 100;'
    ```

    !!! Info "Caso esteja rodando a query pela 1ª vez será feita somente a configuração do seu ambiente Siga as instruções que irão aparecer até o final e rode a query novamente para puxar os dados :)"

=== "Python"
    ```python
    import basedosdados as bd

    pib_per_capita = """SELECT 
        pib.id_municipio ,
        pop.ano, 
        pib.PIB / pop.populacao * 1000 as pib_per_capita
    FROM `basedosdados.br_ibge_pib.municipios` as pib
    INNER JOIN `basedosdados.br_ibge_populacao.municipios` as pop
    ON pib.id_municipio = pop.id_municipio AND pib.ano = pop.ano
    """

    # Você pode fazer o download no seu computador
    bd.download(query=pib_per_capita, 
                savepath="where/to/save/file", 
                billing_project_id=<YOUR_PROJECT_ID>)

    # Ou carregar o resultado da query no pandas
    df = bd.read_sql(pib_per_capita, billing_project_id=<YOUR_PROJECT_ID>)

    # Ou carregar uma tabela inteira no pandas -- por padrão, `query_project_id` 
    # é o basedosdados, você pode usar esse parâmetro para escolher outro projeto
    df = bd.read_table(
            dataset_id='br_ibge_populacao', 
            table_id='municipios',
            billing_project_id=<YOUR_PROJECT_ID>,
            limit=100
    )
    ```

    !!! Info "Caso esteja rodando a query pela 1ª vez será feita somente a configuração do seu ambiente Siga as instruções que irão aparecer até o final e rode a query novamente para puxar os dados :)"

=== "R"
    ```R
    if (!require("bigrquery")) install.packages("bigrquery")
    library("bigrquery")

    billing_project_id = "<YOUR_PROJECT_ID>"

    pib_per_capita = "SELECT 
        pib.id_municipio ,
        pop.ano, 
        pib.PIB / pop.populacao * 1000 as pib_per_capita
    FROM `basedosdados.br_ibge_pib.municipios` as pib
    INNER JOIN `basedosdados.br_ibge_populacao.municipios` as pop
    ON pib.id_municipio = pop.id_municipio AND pib.ano = pop.ano"

    d <- bq_table_download(bq_project_query(billing_project_id, pib_per_capita), page_size=500, bigint="integer64")
    ```

=== "Stata"
    ```bash
    # Ainda não temos suporte :(
    # Seja a primeira pessoa a contribuir (veja Issue #83 no GitHub)!
    ```
