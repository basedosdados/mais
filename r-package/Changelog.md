# 0.1.0

## Funções novas

* `bdplyr` e `bd_collect` para manipular bases apenas com código de R, removendo SQL do caminho. Por trás dos panos o pacote [`dbplyr`](https://dbplyr.tidyverse.org/) está fazendo as traduções de R em SQL.
* `bd_write`, `bd_write_rds` e `bd_write_csv` podem ser usadas no lugar de `bd_collect` para armazenar o resultado no disco, em um arquivo com formato desejado. `bd_write` é uma função de alta ordem e aceita funções de escrita para variados formatos, com suporte para customizar seus argumentos via `...`.

## Mudanças

* `download` agora aceita referências para tabelas além de queries, criando uma camada entre o usuário e queries em SQL. Agora também é possível customizar como representar dados ausentes, com o argumento `.na`.
* `set_billing_id` agora abre um prompt no terminal para inserção manual do id de projeto caso seja executada sem nenhum argumento (e.g. `set_billing_id()`)
 
* A mensagem de carregamento agora contém mais informações.
* A cobertura e assertividade dos testes aumentou bastante desde a última versão, o feedback dos usuários foi importante para isso.


# 0.2.0
* 
* Incrementamos o valor padrão de `page_size`, onde quer que apareça, para 100000. A performance da maioria das queries deve aumentar substancialmente.
