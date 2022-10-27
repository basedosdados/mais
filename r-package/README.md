## Pacote R
### Desenvolvimento via GITHUB

Tenha certeza que você deseja colaborar! Às vezes, o que você queira melhorar, já foi observado ou já está em processo de manutenção. 
Verifique sempre as issues [abertas](https://github.com/basedosdados/mais/labels/R) e [fechadas](https://github.com/basedosdados/mais/issues?q=label%3AR+is%3Aclosed) 
sobre o pacote R. Se você deseja contribuir com o código no pacote .R, é necessário seguir os seguintes passos: 

### Propondo Mudanças
Abra uma Issue no [repositório](https://github.com/basedosdados/mais/issues) `mais` demonstrando para a equipe que exista um bug ou melhoria plena de um processo ou função. 
Caso Você tenha encontrado um bug, por favor, preencha a issue com [reprex](https://github.com/tidyverse/reprex).

### Fork o pacote e clone em sua máquina
`usethis::create_from_github("https://github.com/basedosdados/mais/tree/master/r-package", fork = TRUE)`

### Instale as dependências de desenvolvimento 
Rode o comando `devtools::install_dev_deps()` e posteriormente rode `devtools::check()`. Tenha certeza que o pacote passou no `devtools::check()`.
Caso não passe no `devtools::check()`, é uma boa ideia nos contactar via [Discord](https://discord.gg/qjYE453a) ou via [site](https://basedosdados.org/contato).

### Crie uma nova git branch
Crie uma branch para seu Pull Request (PR) utilizando o comando `usethis::pr_init("minhas_mudancas")`

### Commite, dê seu PUSH e crie seu PR 
Realize as mudanças necessárias, commite na sua `branch` e crie seu PR utilizando o comando `usethis::pr_push()`. 
O Título do seu PR deve seguir a seguinte forma: `[dados] minhas_mudancas.r` 
No corpo do PR deve conter Fixes `#numero da issue`

Agradecemos a colaboração e revisaremos seu código. 
Muito obrigadx! 
