# Participe do projeto

**TODO: organizar aqui :)**

!!! Info "Incentivamos que outras instituições e pessoas contribuam."
    Só é requerido que o processo de captura e tratamento sejam públicos
    e documentados, e a inserção dos dados no BigQuery siga nossa
    metodologia descrita abaixo.

# Instale o CLI localmente

```sh
make create-env
. .bases/bin/activate
```

# Estrutura do Github

A pasta `bases/` terá uma estrutura similar a do BigQuery.

```
    ├── bases
        ├── <nome_dataset>             Ex: br_eleicoes_tse
        ├── ...
            ├── code/                 Todo código relacionado ao dataset
            ├── <dataset_config.yaml>
            ├── <nome_tabela>.yaml    Ex: candidatos.yaml
            ├── ...
```

Os arquivos `.yaml` serão usados para documentação e configuração das
tabelas e datasets.

!!! Info "Veja também as regras de [Nomenclatura](naming_rules.md)"

### dataset_config.yaml

```yaml
name: br_politica_tse
description: |
    Dados do Tribunal Superior Eleitoral disponíveis na url ...
labels: 
    - eleicao
    - candidatos
```

### <nome_tabela>.yaml

```yaml
owner: 
    name: Base dos Dados # Ou qualquer outra instituição/ pessoa
    contact: bdd-issues
code: <code-that-generated-table-url>
name: eleicao_candidatos
description: |
    Candidatos das eleições federais e municipais de 2010 até 2020

    Tratamentos:
     - ...
labels:
    - eleicao
    - candidatos
columns:
    ANO:
        description: asdfsfasf
        type: INTEGER
        treated?: False # A coluna foi modificada (exceto mudançã de tipos)?
    NOME:
        description: asdfsfasf
        type: STRING
        treated?: False # A coluna foi modificada (exceto mudançã de tipos)?
```

# Estrutura no Storage

A estrutura deve seguir a mesma lógica do BigQuery. Porém, existem pastas raízes diferentes: os dados brutos devem ser alocados em `raw` e prontos em `ready`. Ambas possuem a mesma estrutura:

```
    ├── ready|raw
        ├── <nome_dataset>        Ex: br_politica_tse
        ├── ...
            ├── <nome_tabela>    Ex: eleicao_candidatos
            ├── ...
                ├── <dados>      Dados particionados ou não.
```

Nem todos os dados necessitam estar na pasta `raw`. Essa pasta existe somente para aqueles que precisam de um processamento prévio. 

# Tratamento no Bigquery

O BigQuery é uma ótima ferramenta para tratar as bases. Portanto, recomenda-se
que subir os dados brutos e usar uma query para tratá-los. Seja para corrigir tipos
ou adicionar colunas úteis.

Para isso, deverá ser criado uma dataset com o mesmo nome, mas precedido de `raw_`.

Exemplo: `raw_br_politica_tse`

E todas as tabelas desse dataset serão consideradas brutas e não deverão ser abertas
ao público.

# Regras de Tratamento das Bases

- Nunca editar os valores da base. Se for o caso de tratar uma coluna, adicionar uma nova coluna com os dados tratados.

- Os tipos do BigQuery devem ser usados apropriadamente.

- Códigos dos Municípios e Estados brasileiros devem seguir o padrão do IBGE.

- Não normalizar campos de texto usando maíusculas.

- O código para reproduzir o tratamento deve ser aberto.

- Valores nulos devem ser convertidos para `None`.