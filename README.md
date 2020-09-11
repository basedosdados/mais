# Curió Bases 🗂️

O intuito do projeto é organizar e facilitar o acesso a dados brasileiros através de tabelas públicas no BigQuery.
Qualquer pessoa poderá fazer queries em bases tratadas e documentadas que estarão disponíveis e estáveis.

Uma simples consulta de SQL será o suficiente para cruzamento de bases que você desejar. Sem precisar procurar, baixar, tratar, comprar um servidor e subir clusters.

**Incentivamos que outras instituições e pessoas contribuam**. Só é requerido que o processo de captura e tratamento sejam públicos e documentados, e a inserção dos dados no BigQuery siga nossa metodologia descrita abaixo.

#### Porque o BigQuery?

Sabemos que estruturar os dados em uma plataforma privada não é o ideal para um projeto de dados abertos. Porém o BigQuery oferece uma infraestrutura com algumas vantagens:

- É possível deixar os dados públicos, i.e., qualquer pessoa com uma conta no Google Cloud pode fazer uma query na base, quando quiser
- O usuário (quem faz a query) paga por ela. Isso deixa os custos do projeto bem baixos
- O BigQuery escala magicamente para hexabytes se necessário
- O custo é praticamente zero para usuários. São cobrados somente 5 dólares por terabyte de dados que sua query percorrer, e os primeiros 5 terabytes são gratuitos.

# Como organizar as bases no BigQuery?

As bases tem que ser organizadas no BigQuery de maneira consistente, que permita uma busca fácil e intuitiva, e seja escalável.

Para isso, existem dois níveis de organização: _schemas_ e _tables_, nos quais:
- Todas as tabelas devem estar organizadas em _schemas_
- Cada tabela deve pertencer a um único _schema_

As diretrizes para nomenclatura dos _schemas_ e tabelas são descritas abaixo:

|           | Schema                      | Tabela                           |
|-----------|-----------------------------|----------------------------------|
| Mundial   | mundo-\<tema\>-\<instituicao\>      | \<descrição\>                        |
| Federal   | \<pais\>-\<tema\>-\<instituicao\>       | \<descrição\>                       |
| Estadual  | \<pais\>-\<estado\>                 | \<instituicao\>-\<tema\>-descrição\>       |
| Municipal | \<pais\>-\<estado\>-\<cidade\>          | \<instituicao\>-\<tema\>-descrição\>       |

- Utilizar somente letras minúsculas
- Remover acentos, pontuações e espaços

## Mundial -- Clima, Waze

### Schema:

Usar abrangência, um tema e nome da instituição

`mundo-<tema>-<instituicao>`

### Tabela:

Usar nome descritivo e único para os dados

`<descrição>`

Exemplo: Os dados de alertas do Waze estariam no schema `mundo-mobilidade-waze` e tabela `alertas`. Portanto, o caminho seria `mundo-mobilidade-waze`.`alertas`.

## Federal -- IBGE, IPEA, Senado, Camara, TSE

### Schema:

Usar sigla do país, um tema e nome da instituição

`<pais>-<tema>-<instituicao>`

### Tabela:

Usar nome descritivo e único para os dados:

`<descrição>`

Exemplo: Os dados de candidatos do TSE estariam no schema `br-eleicoes-tse` e na tabela `candidatos`.

## Estadual 

### Schema:

Usar país e sigla do estado (UF).

`<pais>-<estado>`

### Tabela:

Usar nome da instuição estadual, tema e descrição

`<instituicao>-<tema>-<descrição>`


Exemplo: Os dados da rede de esgoto da SANASA que atende no estado de São Paulo estariam no schema `br-sp` e tabela `sanasa-sanementobasico-redeesgoto`.

## Municipal

### Schema:

Usar sigla do país, sigla do estado (UF), nome da cidade (sem espaço)

`<pais>-<estado>-<cidade>`

### Tabela:

Usar nome da instuição estadual, tema e descrição

`<instituicao>-<tema>-<descrição>`

Exemplo: Os dados de votações da camara municipal do rio de janeiro estariam em `br-rj-riodejaneiro` e tabela `dcmrj-legislativo-legislativo`

## Tabela de Temas e Identificadores

A referencia dos temas é do dados.gov.br, mas temas podem ser adicionados e trocados. Identificadores serão adicionados de acordo com demanda.
| Tema                                | Identificador |
|-------------------------------------|---------------|
| Legislativo                         | legislativo   |
| Saúde                               | saude         |
| Educação                            | educacao      |
| Eleições                            | eleicoes      |
| Governo e Política                  |               |
| Agricultura, extrativismo e pesca   |               |
| Economia e Finanças                 |               |
| Pessoa, Familia e Sociedade         |               |
| Equipamentos Públicos               |               |
| Plataforma de Gestão de Indicadores |               |
| Cultura, Lazer e Esporte            |               |
| Plano Plurianual                    |               |
| Trabalho                            |               |
| Transportes e Trânsito              |               |
| Comércio, Serviços e Turismo        |               |
| Defesa e Segurança                  |               |
| Meio Ambiente                       |               |
| Indústria                           |               |
| Geografia                           |               |
| Ciência, Informação e Comunição     |               |
| Fornecedores do Governo Federal     |               |
| Habitação, Saneamento e Urbanismo   |               |


# Estruturação do Github

A pasta `bases/` terá uma estrutura similar a do BigQuery.

```
    ├── bases
        ├── <nome_schema>             Ex: br-eleicoes-tse
        ├── ...
            ├── code/                 Todo código relacionado ao schema
            ├── <schema_config.yaml>
            ├── <nome_tabela>.yaml    Ex: candidatos.yaml
            ├── ...
```

Os arquivos `.yaml` serão usados para documentação e configuração das tabelas e schemas.

### schema_config.yaml

```yaml
name: br-eleicoes-tse
description: |
    Dados do Tribunal Superior Eleitoral disponíveis na url ...
labels: 
    - eleicoes
    - politica
    - candidatos
```

### <nome_tabela>.yaml

```yaml
owner: 
    name: Curio # Ou qualquer outra instituição/ pessoa
    contact: curio-issues
code: <code-that-generated-table-url>
name: candidatos
description: |
    Candidatos das eleições federais e municipais de 2010 até 2020

    Tratamentos:
     - ...
labels:
    - eleicoes
    - candidatos
    - politica
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

# Estruturação no Storage

A estrutura deve seguir a mesma lógica do BigQuery. Porém, existem pastas raízes diferentes: os dados brutos devem ser alocados em `raw` e tratados em `treated`. Ambas possuem a mesma estrutura:

```
    ├── treated/raw
        ├── <nome_schema>        Ex: br-eleicoes-tse
        ├── ...
            ├── <nome_tabela>    Ex: candidatos
            ├── ...
                ├── <dados>      Dados particionados ou não.
```


# Regras de Tratamento das Bases

- Nunca editar os valores da base. Se for o caso de tratar uma coluna, adicionar uma nova coluna com os dados tratados.

- Os tipos do BigQuery devem ser usados apropriadamente.

- Códigos dos Municípios e Estados brasileiros devem seguir o padrão do IBGE.

- Não normalizar campos de texto usando maíusculas.

- O código para reproduzir o tratamento deve ser aberto.

- Valores nulos devem ser convertidos para `None`.

# Idiomas

Toda documentação estará em português (quando possível). O código e configurações estará em inglês.
