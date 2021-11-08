# Como usar via BigQuery

Ao clicar no botão você será redirecionado para logar na sua conta ou criar uma antes de acessar o projeto.

<a
href="https://console.cloud.google.com/bigquery?p=basedosdados&page=project"
title="{{ lang.t('source.link.title')}}" class="md-button"
style="background-color: var(--md-primary-fg-color);color:
var(--md-primary-bg-color);"
hover="background-color: var(--md-primary-fg-color--dark)">
    Clique para acessar o projeto no BigQuery
</a>

Na sua tela deverá aparecer o projeto fixado no menu lateral esquerdo,
como na imagem abaixo.

![](images/bq_access_project.png){ width=100% }

## Criando uma conta no BigQuery

- **Todas as tabelas estão organizadas dentro de cojuntos de dados**, que
  representaam sua organização/tema (ex: o conjunto
  `br_ibge_populacao` contém uma tabela `municipio` com a série
  históricac de população a
  nível municipal)
- **Cada tabela pertence a um único conjunto de dados** (ex: a tabela
  `municipio` em `br_ibge_populacao` é diferente de `municipio` em `br_bd_diretorios`)
  
!!! Tip "[Veja aqui o guia do Google de como funciona a interface do BigQuery](https://cloud.google.com/bigquery/docs/bigquery-web-ui)."
É preciso, basicamente, ter uma conta Google para acessar o BigQuery. O
site deve solicitar que você crie um projeto qualquer no seu BigQuery
antes de acessar os nossos dados - não se preocupe, não é pago! 

<i>O BigQuery inicia automaticamente no modo Sandbox, que permite você
utilizar seus recursos sem adicionar um modo de pagamento. Leia mais sobre o
Sandbox [aqui](https://cloud.google.com/bigquery/docs/sandbox).</i>

## Acessando o projeto

Dentro do projeto existem dois níveis de organização, <strong
style="color:red">*datasets*</strong> (conjuntos de dados) e <strong
style="color:green">*tables*</strong>
(tabelas), nos quais:

- Todas as *tables* estão organizadas em *datasets*
- Cada *table* pertence a um único *dataset*
    

![](images/bq_dataset_tables_structure.png){ width=100% }


!!! Warning "Caso não apareçam as tabelas nos *datasets* do projeto na 1ª vez que você acessar, atualize a página."

## Explorando os dados

### Exemplo: Qual a evolução do PIB per capita de todos os municípios? 📈

O BigQuery utiliza SQL como linguagem nativa. Leia mais sobre a sintaxe
utilizada
[aqui](https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax).

Rode a query abaixo no `Query Editor/Editor de consultas` e obtenha o cruzamento
das tabelas de população e PIB do IBGE com o resultado anual desde 2002.

```sql
SELECT 
    pib.id_municipio,
    pop.ano, 
    pib.PIB / pop.populacao AS pib_per_capita
FROM `basedosdados.br_ibge_pib.municipio` AS pib
    JOIN `basedosdados.br_ibge_populacao.municipio` AS pop
    ON pib.id_municipio = pop.id_municipio AND pib.ano = pop.ano
```

!!! Tip "Dica"
    Clicando no botão `🔍 Consultar tabela/Query View`, o BigQuery cria
    automaticamente a estrutura básica da sua query em `Query Editor/Editor
    de consultas` - basta você completar com os campos e filtros que achar necessários.

### Entenda os dados

O BigQuery possui já um mecanismo de busca que permite buscar por nomes
de *datasets* (conjuntos), *tables* (tabelas) ou *labels* (grupos).
Construímos regras de nomeação simples e práticas para facilitar sua
busca - veja mais [na seção de Nomenclatura](../style_data/).

#### Metadados

Clicando num *dataset* ou *table* você já consegue ver toda a estrutura
e descrição das colunas, e pode acessar também os detalhes de tratamento e publicação,
para entender melhor os dados.

- [Lista de funções em SQL da W3](https://www.w3schools.com/sql/default.Asp)
- [Curso SQL na Codeacademy](https://www.codecademy.com/learn/learn-sql)
