# R

Esta API é composta somente de módulos para **requisição de dados**, ou
seja, download e/ou carregamento de dados do projeto no seu ambiente de
análise).
Para fazer **gerenciamento de dados** no Google Cloud, busque as funções
na API de [linha de comando](../api_reference_cli) ou em [Python](../api_reference_python/#classes-gerenciamento-de-dados).

A documentação completa encontra-se na página do CRAN do projeto, e
segue baixo.

!!! Info "Toda documentação do código abaixo está em inglês"

<object data="https://cran.r-project.org/web/packages/basedosdados/basedosdados.pdf" type="application/pdf" width="700px" height="700px">
    <embed src="https://cran.r-project.org/web/packages/basedosdados/basedosdados.pdf">
        <p>This browser does not support PDFs. Please download the PDF to view it: <a href="https://cran.r-project.org/web/packages/basedosdados/basedosdados.pdf">Download PDF</a>.</p>
    </embed>
</object>

## Ih rapaz, deu erro! E agora?
Os principais erros encontrados do pacote da Base dos Dados no Rstudio são dois: 
    * Autenticação
    * Bibliotecas atualizadas que crasham com a utilização do pacote.
Portanto, se alguns destes erros aparecer para você, por favor, siga o passo a passo listado aqui embaixo.

### Autenticação
Você tentou rodar um código como esse aqui: 

     query <- bdplyr("DATASET_ID_TABLE_ID")
     df <- bd_collect(query)
E chegou no seguinte erro: 

`! The table basedosdados.br_imprensa_nacional_dou.secao_1 doesn't have a valid name or was not found at basedosdados.`

Esse é um erro de autenticação. Esse erro é rotineiro devido a instalação do pacote basedosdados na sua máquina e autorização do Token da Google. 
É necessário estar atento se você marcou todas as caixinhas de seleção quando o Rstudio, no console, disponibiliza essa tela no navegador:

![Capturar](https://user-images.githubusercontent.com/26544494/190700064-1326a74c-8de0-4254-a562-32f9aa10ae07.PNG)

É necessário, portanto, tickar todas as caixinhas disponibilizadas. 
Feito isso, aparecerá uma outra tela com um Token gerado para que o pacote Tidyverse acesse seu bigquery. Copie e cole o código Token direto no console do Rstudio. 

![token](https://user-images.githubusercontent.com/26544494/190700780-dd1d05e3-3ef4-4070-9023-c5e4e1684f79.PNG)

Com o código Token a ser inserido no console do Rstudio, é válido posteriormente reiniciar a sessão do Rstudio. Assim, após reiniciar a sessão, aparecerá a opção de selecionar um e-mail quando o comando `basedosdados::bdplyr(“query”)` for utilizado. Veja: 

![email](https://user-images.githubusercontent.com/26544494/190703436-a1e16906-9b53-4bcf-b337-2a0881548cf0.PNG)

Feito todos esses procedimentos, é bem provável que o problema de autenticação não ocorra mais. 

### O Downgrade do bdplyr 
Nosso pacote em R foi construído utilizando outros pacotes para acesso ao Bigquery. Isso significa que existem dependências e atualizações destes pacotes que podem crashar o código e dar um erro já conhecido pela comunidade. O erro em questão é sobre a versão do bdplyr: 

![bdplyr](https://user-images.githubusercontent.com/26544494/190704346-b898d9b2-aa0e-4f19-8b59-47df4d15b2f5.PNG)

Diante disso, é recomendável que o usuário utilize o comando

`install.packages("~/Downloads/dbplyr_2.1.1.tar", repos = NULL, type = "source")` 

para um downgrade do pacote bdplyr. Feito isso, diante de todas as nossas documentações, é provável que o erro seja solucionado.

É válido também visitar as `issues` que estão atribuídas com o a etiqueta `R` em nosso github. 
[Veja aqui](https://github.com/basedosdados/mais/issues?q=is%3Aissue+is%3Aclosed)

