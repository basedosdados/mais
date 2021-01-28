# Diretrizes para nomes de colunas

Nomear colunas é parte fundamental da construção do nosso repositório. Escolhas feitas nesse momento tem ramificações longe no futuro, e por isso levamos essa parte muito a sério.

Um bom nome de coluna satisfaz algumas **condições**:

- Respeita padrões das tabelas de diretórios;
- É o mais intuitivo, claro, e extenso possível;
- Tem todas letras minúsculas (inclusive siglas), sem acentos, conectados por `_`;
- Segue os padrões BD+ abaixo.

## Padrões BD+ de nomeação de colunas

- Usar **nomes já presentes** no repositório. Alguns exemplos:
    - `ano`
    - `mes`
    - `id_municipio`
    - `sigla_uf`
    - `idade`
    - `cargo`
    - `resultado`
    - `votos`
    - `receita`
    - `despesa`
    - `preco`

- **Evitar abreviações**.
    - Exemplos para evitar: `qtde`, `n`. 
    - Exceções naturais: `resid` (residência), `ocor` (ocorrência).

- Lista de **prefixos comuns**
    - `id_`
    - `nome_`
    - `data_`
    - `numero_`
    - `quantidade_`
    - `prop_`
    - `taxa_`
    - `razao_`
    - `indice_`
    - `indicador_`
    - `tipo_`
    - `sigla_`
    - `sequencial_`

- Lista de **sufixos comuns**
    - `_pc` (per capita)

TODO:

- definir exatamente `id` como identificadores INT64

## **Pensou em melhorias para os padrões definidos?**

Abra um [issue no nosso Github](https://github.com/basedosdados/mais/labels/docs) ou mande uma mensagem para conversarmos :)