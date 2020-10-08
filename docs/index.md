<!-- Header -->
<p align="center">
  <a href="https://base-dos-dados.github.io/bases/">
    <img src="https://avatars3.githubusercontent.com/u/71097635?s=400&u=59375d7ae320f43b2bb6accc8ef6dd79837c88f5&v=4" width="320" alt="Base dos Dados">
  </a>
</p>

<p align="center">
    <em>O mais completo mecanismo de busca e <b>consulta</b> a bases de dados brasileiras e internacionais.</em>
</p>

---

<div align="center">
    <a align="center"
    href="https://console.cloud.google.com/bigquery?p=basedosdados&page=project"
    title="{{ lang.t('source.link.title')}}" class="md-button">
        Clique para acessar o projeto no BigQuery
    </a>
</div>


Uma simples consulta de SQL é o suficiente para cruzamento de bases que
você desejar. Sem precisar procurar, baixar, tratar, comprar um servidor
e subir clusters.

Por que o BigQuery?

**TODO: add infografico**

- **Acesso**: É possível deixar os dados públicos, i.e., qualquer
  pessoa com uma conta no Google Cloud pode fazer uma query na base,
  quando quiser.
- **Rapidez**: Uma query muito longa não demora menos de minutos para
  ser processada.
- **Escala**: O BigQuery escala magicamente para hexabytes se necessário.
- **Facilidade**: Você pode cruzar tabelas de diferentes organizações, temas,
  tudo numa só query.
- **Economia**: O custo é praticamente zero para usuários - **1
  TB gratuito por mês para usar como quiser**. Depois disso, são cobrados
  somente 5 dólares por TB de dados que sua query percorrer.

----

# Quick Start

<div class="termy">
    ```console
    $ pip3 install basedosdados
    ```
</div>

- [Acessando os dados pelo BigQuery](access_data_bq)
- [Acessando os dados localmente](access_data_local)
- **TODO: organizar essa intro**

## Sobre o projeto

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

#### Instale o CLI localmente

```sh
make create-env
. .bases/bin/activate
```

# Como organizar as bases no BigQuery?

As bases tem que ser organizadas no BigQuery de maneira consistente, que permita uma busca fácil e intuitiva, e seja escalável.

Para isso, existem dois níveis de organização: _datasets_ e _tables_, nos quais:
- Todas as tabelas devem estar organizadas em _datasets_
- Cada tabela deve pertencer a um único _dataset_

As diretrizes para nomenclatura dos _datasets_ e tabelas são descritas abaixo:

|           | Dataset                      | Tabela                           |
|-----------|-----------------------------|----------------------------------|
| Mundial   | mundo_\<tema\>_\<instituicao\>      | \<descrição\>                        |
| Federal   | \<pais\> _ \<tema\> _ \<instituicao\>       | \<descrição\>                       |
| Estadual  | \<pais\> _ \<estado\> _ \<tema\> _ \<instituicao\>     | \<descrição\>       |
| Municipal | \<pais\> _ \<estado\> _ \<cidade\> _ \<tema\> _ \<instituicao\> | \<descrição\>       |

- Utilizar somente letras minúsculas
- Remover acentos, pontuações e espaços

### Bases Desejadas

[Lista de bases mapeadas](https://docs.google.com/spreadsheets/d/1t9kEsiyatmmdDCy2qjaCjLqdw-oJj33P7tY5bnkR0aw/edit#gid=0) que estão no nosso mapa.


## Mundial -- Clima, Waze

### Dataset:

Usar abrangência, um tema e nome da instituição

`mundo_<tema>_<instituicao>`

### Tabela:

Usar nome descritivo e único para os dados

`<descrição>`

Exemplo: Os dados de alertas do Waze estariam no dataset `mundo_mobilidade_waze` e tabela `alertas`. Portanto, o caminho seria `mundo_mobilidade_waze`.`alertas`.

## Federal -- IBGE, IPEA, Senado, Camara, TSE

### Dataset:

Usar sigla do país, um tema e nome da instituição

`<pais>_<tema>_<instituicao>`

### Tabela:

Usar nome descritivo e único para os dados:

`<descrição>`

Exemplo: Os dados de candidatos do TSE estariam no dataset `br-eleicoes-tse` e na tabela `candidatos`.

## Estadual 

### Dataset:

Usar país e sigla do estado (UF).

`<pais>_<estado>`

### Tabela:

Usar nome da instuição estadual, tema e descrição

`<instituicao>_<tema>_<descrição>`


Exemplo: Os dados da rede de esgoto da SANASA que atende no estado de São Paulo estariam no dataset `br-sp` e tabela `sanasa-sanementobasico-redeesgoto`.

## Municipal

### Dataset:

Usar sigla do país, sigla do estado (UF), nome da cidade (sem espaço)

`<pais>_<estado>_<cidade>`

### Tabela:

Usar nome da instuição estadual, tema e descrição

`<instituicao>_<tema>_<descrição>`

Exemplo: Os dados de votações da camara municipal do rio de janeiro estariam em `br-rj-riodejaneiro` e tabela `dcmrj-legislativo-legislativo`

## Tabela de Temas e Identificadores

A referencia dos temas é da busca da Base dos Dados, mas temas podem ser adicionados e trocados. Identificadores serão adicionados de acordo com demanda.
| Tema                                     | Identificador    |
|------------------------------------------|------------------|
| Agropecuária                             | agropecuaria     |
| Ciência, Tecnologia e Inovação           | ciencia_tec_inov |
| Cultura e Arte                           | cultura_arte     |
| Diversidade e Inclusão                   | diversidade      |
| Educação                                 | educacao         |
| Energia                                  | energia          |
| Esportes                                 | esportes         |
| Economia                                 | economia         |
| Governo e Finanças Públicas              | governo          |
| História                                 | historia         |
| Infraestrutura e Transportes             | infr_transp      |
| Jornalismo e Comunicação                 | jornalismo       |
| Meio Ambiente                            | meio_ambiente    |
| Justiça                                  | justica          |
| Organização Territorial                  | territorio       |
| Política                                 | politica         |
| População                                | populacao        |
| Religião                                 | religiao         |
| Segurança, Crime, Violência e Conflito   | seguranca        |
| Saúde                                    | saude            |
| Turismo                                  | turismo          |
| Urbanização                              | urbanizacao      |

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

Os arquivos `.yaml` serão usados para documentação e configuração das tabelas e datasets.

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

# Idiomas

Toda documentação estará em português (quando possível). O código e configurações estará em inglês.
