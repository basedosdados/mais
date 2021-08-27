
# BigQuery



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
    
## Acessando o projeto da `basedosdados`

O botão abaixo via te direcionar ao nosso projeto no Google BigQuery:

<a
href="https://console.cloud.google.com/bigquery?p=basedosdados&page=project"
title="{{ lang.t('source.link.title')}}" class="md-button"
hover="background-color: var(--md-primary-fg-color--dark)">
    Acessar a BD no BigQuery
</a>

Na sua tela deverá aparecer o projeto fixado no menu lateral esquerdo,
como na imagem abaixo.

![](images/bq_access_project.png){ width=100% }

Dentro do projeto existem dois níveis de organização dos dados,
<strong>*datasets*</strong> (conjuntos de dados) e
<strong>*tables*</strong> (tabelas), nos quais:

- **Todas as tabelas estão organizadas dentro de cojuntos de dados**, que
  representaam sua organização/tema (ex: o conjunto
  `br_ibge_populacao` contém uma tabela `municipio` com a série
  históricac de população a
  nível municipal)
- **Cada tabela pertence a um único conjunto de dados** (ex: a tabela
  `municipio` em `br_ibge_populacao` é diferente de `municipio` em `br_bd_diretorios`)
    

![](images/bq_dataset_tables_structure.png){ width=100% }

!!! Warning "Caso não apareçam as tabelas nos *datasets* do projeto na
1ª vez que você acessar, atualize a página."

### Como navegar pelo BigQuery

Para entender melhor sobre a interface do BigQuery e como explorar os
dados, preparamos um texto completo no blog com um exemplo de busca dos
dados da RAIS (Ministério da Economia).
https://dev.to/basedosdados/bigquery-101-45pk]

### Explorando os dados

Um exemplo simples para começar a explorar o *datalake* é puxar
[informações cadastrais de
municípios](https://basedosdados.org/dataset/br-bd-diretorios-brasil/resource/9046b938-b361-4c3c-a5e7-a549dfc48f2b)
direto na nossa base de diretórios brasileiros. Para isso, basta abrir o
Editor de Consultas do BigQuery (fica no e escreve nossa quer em SQL.

```sql
SELECT * FROM `basedosdados.br_bd_diretorios_brasil.municipio`
```

!!! Tip "Dica"
    Clicando no botão `🔍 Consultar tabela/Query View`, o BigQuery cria
    automaticamente a estrutura básica da sua query em `Query Editor/Editor
    de consultas` - basta você completar com os campos e filtros que
    achar necessários.
    
## Próximos passos

### Entenda os dados

O BigQuery possui já um mecanismo de busca que permite buscar por nomes
de *datasets* (conjuntos), *tables* (tabelas) ou *labels* (grupos).
Construímos regras de nomeação simples e práticas para facilitar sua
busca - veja mais [na seção de Nomenclatura](/style_data).

### Tutoriais

- [Como funcionam os nomes de conjuntos e tabelas]()
- [Como cruzar tabelas de diferentes organizações](/tutorial_cross_table)