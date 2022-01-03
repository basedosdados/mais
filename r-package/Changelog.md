# 0.1.0

## Funções novas

* `bdplyr` e `bd_collect` para manipular bases apenas com código de R, removendo SQL do caminho. Por trás dos panos o pacote [`dbplyr`](https://dbplyr.tidyverse.org/) está fazendo as traduções de R em SQL.
* `bd_write`, `bd_write_rds` e `bd_write_csv` podem ser usadas no lugar de `bd_collect` para armazenar o resultado no disco, em um arquivo com formato desejado. `bd_write` é uma função de alta ordem e aceita funções de escrita para variados formatos, com suporte para customizar seus argumentos via `...`.

## Mudanças

* `download` agora aceita referências para tabelas além de queries, criando uma camada entre o usuário e queries em SQL. Agora também é possível customizar como representar dados ausentes, com o argumento `.na`.
* `set_billing_id` agora abre um prompt no terminal para inserção manual do id de projeto caso seja executada sem nenhum argumento (e.g. `set_billing_id()`)
 
* A mensagem de carregamento agora contém mais informações.
* A cobertura e assertividade dos testes aumentou bastante desde a última versão, o feedback dos usuários foi importante para isso.

## Bugs

* Subimos a versão mínima do `readr` para `1.4.0`, resolvendo o problema de escrita com `download` que alguns usuários tinham.
* E também do `bigrquery` para `1.3.2`, resolvendo um problema de queries de grande volumes corrompidas.

# 0.2.0

## Funções novas
* `dataset_search` agora permite busca de bases por palavras-chave
* `get_table_colums` devolve o esquema de uma tabela
* `list_dataset_tables` lista as tabelas dentro de um dataset
* `get_dataset_description` dá uma descrição mais aprofundada de um dataset
* `get_table_description` descreve analogamente uma tabela dentro de um dataset

## Mudanças
* O parâmetro `page_size` foi aposentado em todas as funções. Mais detalhes na seção de bugs abaixo.
* Algumas validações dos argumentos do usuário que emitiam erros opacos foram retiradas ns funções `download` e `query`. A ideia é deixar que alguns erros importantes que estavam sendo mascarados pelo `basedosdados` sejam retornados no original. 
* O pacote agora usa tipagem estática em _algumas_ funções (escolhidas aleatoriamente para que seja simples avaliar o impacto da mudança na ocorrência de bugs), pelo pacote [`typed`](https://github.com/moodymudskipper/typed). Esperamos alguns bugs novos por conta disso, mas acreditamos que os ganhos da tipagem estática compensam.

## Bugs
* Incrementamos a versão mínima do `Rcpp` para `1.0.7`, resolvendo a [ausência de `Rcpp_previous_remove()`](https://stackoverflow.com/questions/68416435/rcpp-package-doesnt-include-rcpp-precious-remove)
* Incrementamos a versão mínima do `bigrquery` para `1.4.0`, resolvendo os [bugs de paginação envolvendo o argumento `page_size`](https://bigrquery.r-dbi.org/news/index.html#bigrquery-1-4-0-2021-08-05). Uma discussão mais detalhada do bug pode ser encontrada no [issue #412 do `bigrquery`](https://github.com/r-dbi/bigrquery/issues/412) e no [PR #456 do `bigrquery`](https://github.com/r-dbi/bigrquery/pull/456).

## Roadmap
* A [pedidos da comunidade](https://twitter.com/KimJoaoUn/status/1469712592054669320), teremos ferramentas para autenticação não-interativa na GCP na `0.3.0`.
