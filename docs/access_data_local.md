# Como acessar os dados localmente

!!! Info
    Atualmente nossa aplicação tem suporte para Python e CLI. 
    Para colaborar com R, Stata ou outra linguagem, acesse nossos [issues](https://github.com/basedosdados/bases/issues).

Em apenas 2 passos você consegue obter dados estruturados para baixar e
analisar:

1. Instalar a aplicação
2. Realizar sua query para explorar os dados

## Instalando a aplicação

=== "Python"
    ```bash
    $ pip3 install basedosdados
    ```
=== "CLI"
    ```bash
    $ pip3 install basedosdados
    ```
=== "R"
    ```bash
    Ainda não temos suporte :(
    
    >> Seja a primeira pessoa a contribuir (veja Issue #82 no GitHub)!
    ```
=== "Stata"
    ```bash
    Ainda não temos suporte :( 

    >> Seja a primeira pessoa a contribuir (veja Issue #83 no GitHub)!
    ```

## Baixando bases do projeto

Obtendo toda a tabela (ou limitada) em CSV:

=== "Python"
    ```python
    from basedosdados import download

    download(savepath="where/to/save/file",
             dataset_id="br_suporte", 
             table_id="diretorio_municipios",
             limit=1000)
    ```

=== "CLI"
    ```bash
    $ basedosdados download --dataset_id "br_suporte" --table_id "diretorio_municipios" --limit 1000
    ```

=== "R"
    ```bash
    Ainda não temos suporte :( -- TODO: add com a ferramenta do GCD em R
    
    >> Seja a primeira pessoa a contribuir (veja Issue #82 no GitHub)!
    ```
=== "Stata"
    ```bash
    Ainda não temos suporte :( 

    >> Seja a primeira pessoa a contribuir (veja Issue #83 no GitHub)!
    ```

!!! Info
    Por padrão, o BigQuery escolhido para puxar os dados é
    `basedosdados` - você pode mudar para o seu explicitando
    `project_id`.

Baixando a tabela com filtros ou condicionais:

=== "Python"
    ```python
    from basedosdados import download

    my_query = """SELECT *
    FROM `basedosdados.br_suporte.diretorio_municipios`
    WHERE existia_2000 = 0;
    """

    download(savepath="where/to/save/file", query=my_query)
    ```
    
=== "CLI"
    ```bash
    $ basedosdados download "where/to/save/file" --query "SELECT * FROM `basedosdados.br_suporte.diretorio_municipios` WHERE existia_2000 = 0;"
    ```
=== "R"
    ```bash
    Ainda não temos suporte :(
    
    >> Seja a primeira pessoa a contribuir (veja Issue #82 no GitHub)!
    ```
=== "Stata"
    ```bash
    Ainda não temos suporte :( 

    >> Seja a primeira pessoa a contribuir (veja Issue #83 no GitHub)!
    ```
