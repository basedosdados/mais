# Table_approve: O que é

> O table_approve é uma action para automatizar a pipeline de dados no Base dos Dados. Quando um pull request para a subida de dados é aprovada pelo time de revisores, essa action realiza o upload e publicação de tabelas no projeto público do BigQuery para
que possa ser acessada pelos usuários

# Como funciona
> Primeiramente, precisamos replicar um ambiente de trabalho basedosdados na máquina virtual que roda a action. Para isso, além de instalar todas as dependências necessárias, também criamos toda a árvore de arquivos de configuração necessária para que a API funcione da maneira esperada.
> Quando um commit é publicado na branch de trabalho (via $ git push origin <branch> ) usamos uma action que compara a branch com o repositório da branch master e identifica quais arquivos foram alterados pelo commit.
> A partir dessas mudanças, utilizamos uma função chamada sync_bucket (descrita no script main.py) que copia os dados do bucket pessoal de quem estiver subindo dados para o bucket da produção do basedosdados. Essa função checa se os dados já existem, e caso existam, salva um backup deles, para então deletar os dados existente e copiar os novos dados.
> Substituímos, no publish.sql da proposta, os dados de project_id do usuário pelos nossos para que a VIEW dos dados seja publicada corretamente.
> Finalmente, chamamos funções da nossa API (Table.create, Table.publish e Table.update) que fazem o processo de criação de uma tabela staging, criação da VIEW pública que pode ser consultada no Bigquery e atualização da descrição da tabela.
