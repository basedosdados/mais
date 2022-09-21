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
A maioria dos erros do nosso pacote estão relacionados a problemas de autenticação. É preciso que o usuário forneça todas as autenticações requeridas pela função `set_billing_id`, inclusive aquelas que aparecem como optativas. É necessário estar atento se você marcou todas as caixinhas de seleção quando o Rstudio disponibiliza essa tela no navegador:

![Capturar](https://user-images.githubusercontent.com/26544494/190700064-1326a74c-8de0-4254-a562-32f9aa10ae07.PNG)

Note que é preciso marcar inclusive as duas últimas "caixinhas", que aparecem como opcionais.

Caso você já tenha autenticado com autorização incompleta, é preciso repetir o processo de autenticação. Você pode fazer isso rodando `gargle::gargle_oauth_sitrep()`. Você deverá checar a pasta em que estão salvas as autenticações do seu R, entrar nesta pasta e deletar aquela referente ao Google Cloud/Bigquery. Feito isso, ao rodar `set_billing_id` você poderá autenticar novamente.  

Feito todos esses procedimentos, é bem provável que o problema de autenticação não ocorra mais. 

### O Downgrade do dbplyr 
Outro problema está relacionado ao uso do `bdplyr`. Nosso pacote em R foi construído utilizando outros pacotes para acesso ao Bigquery. Isso significa que existem dependências e atualizações destes pacotes que podem alterar o funcionamento destes e gerar efeitos em cascata a pacotes desenvolvidos em cima deles. Neste contexto, o nosso pacote funciona apenas com a versão 2.1.1 do pacote `dbplyr`, e *não* funciona com versões posteriores. 

Você pode checar a função do `dbplyr` rodando a função `utils::packageVersion("dbplyr")`. Caso ela seja diferente de 2.1.1, você precisa dar um _downgrade_ para essa versão. Para isso, você pode rodar `devtools::install_version("dbplyr", version = "2.1.1", repos = "http://cran.us.r-project.org")`

### Outros erros
Caso os erros persistam, você pode abrir uma Issue no nosso Github clicando [aqui](https://github.com/basedosdados/mais/issues). Você também visitar as `issues` que já foram resolvidas e estão atribuídas com o a etiqueta `R` em nosso Github [aqui](https://github.com/basedosdados/mais/issues?q=is%3Aissue+is%3Aclosed). 