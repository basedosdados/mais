# Python API

Esta API é composta de classes para **gerenciamento de dados** no Google Cloud:

- [`Storage`](#basedosdados.storage.Storage), que permite manusear arquivos no Storage
- [`Dataset`](#basedosdados.dataset.Dataset), que permite manusear *datasets* no BigQuery
- [`Table`](#basedosdados.table.Table), que permite manusear *tables*

E também módulos para **requisição de dados**:

- [`download`](#basedosdados.download.download), que permite baixar
  tabelas do BigQuery em CSV  direto na sua máquina.
- [`read_sql`](#basedosdados.download.read_sql), que permite fazer uma
  query SQL e carregar os dados no ambiente do Python.
- [`read_table`](#basedosdados.download.read_table), que permite ler uma
  tabela do BigQuery pelo nome e carregar os dados no ambiente do Python.

!!! Info "Toda documentação do código abaixo está em inglês"

## Classes

::: basedosdados.storage
    handler: python
    rendering:
            show_root_heading: no
            heading_level: 3
    selection:
      docstring_style: google  # this is the default
      docstring_options:
        replace_admonitions: no

---
::: basedosdados.dataset
    handler: python
    rendering:
            show_root_heading: no
            heading_level: 3
    selection:
      docstring_style: google  # this is the default
      docstring_options:
        replace_admonitions: no

---
::: basedosdados.table
    handler: python
    rendering:
            show_root_heading: no
            heading_level: 3
    selection:
      docstring_style: google  # this is the default
      docstring_options:
        replace_admonitions: no

---

## Módulos

::: basedosdados.download
    handler: python
    rendering:
            show_root_heading: no
            heading_level: 3
    selection:
      docstring_style: google  # this is the default
      docstring_options:
        replace_admonitions: no
