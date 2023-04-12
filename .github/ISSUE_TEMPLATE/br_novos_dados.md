---
name: PTBR | Novos dados
about: Novos dados para serem adicionados à BD+
title: '[dados] <dataset_id>'
labels: data
assignees: 

---

**Metadados da base**

1. Descrição: <descrição da base e suas tabelas>

<!-- Para (2) e (3): veja como nomeamos nossos conjuntos e tabelas aqui https://basedosdados.github.io/mais/style_data/#nomea%C3%A7%C3%A3o-de-bases-e-tabelas -->

2. Qual o nome do conjunto? `dataset_id`

3. Qual o nome da(s) tabela(s)? `table_id`

4. Fonte original dos dados
    * Endereço: <url>
    * Tem API? <sim>/<não>
    * É grátis? <sim>/<não>
    * Cobertura espacial: <area.slug>
    * Cobertura temporal: de YYYY-MM-DD a YYYY-MM-DD

5. Raspagem
    * Nível de dificuldade: <baixo>/<médio>/<alto>
    * Existe código semi-pronto? <sim>/<não>
    * Dificuldades de big data (alta frequência, alto volume)? <sim>/<não>

**Tarefas** (seguindo os passos da documentação [aqui](https://basedosdados.github.io/mais/colab_data/))

- [ ] Baixar a pasta template e os dados originais
- [ ] Preencher as tabelas de arquitetura - Marcar a equipe de dados na issue avisando quando finalizar
- [ ] Escrever código de captura e limpeza de dados
- [ ] Organizar arquivos brutos, se necessário
- [ ] Organizar arquivos auxiliares, se necessário
- [ ] Criar tabela dicionário, se necessário
- [ ] Subir tabelas no BigQuery
- [ ] Fazer uma revisão seguindo o [nosso guia](https://github.com/basedosdados/.github/wiki/Dados#como-fazer-code-review)
- [ ] Abrir o PR
- [ ] Escrever a pipeline
