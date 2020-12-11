# CLI API

Esta API é composta de comandos para **gerenciamento e inserção de
dados** no Google Cloud.

Os comandos disponíveis dentro de `cli` atualmente são:

- `config`, que é utilizado para atualizar seus dados de configuração e
 gerenciar templates
- `dataset`, que permite gerenciar datasets no BigQuery (criar,
  modificar, publicar , atualizar e deletar)
- `download`, que permite baixar/salvar queries de tabelas do BigQuery na sua máquina local
- `storage`, que permite gerenciar seu Storage no BigQuery (criar e
  subir arquivos)
- `table`, que permite gerenciar tabelas no BigQuery (criar,
  modificar, publicar , atualizar e deletar)

!!! Info "Toda documentação do código abaixo está em inglês"

::: mkdocs-click
    :module: basedosdados.cli
    :command: cli
    :depth: 1
