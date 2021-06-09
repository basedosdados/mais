
# Diretrizes de dados


Regra para tipagem de variáveis `INT64` ou `FLOAT64`: só o que puder ser usado em contas matemáticas.
    Exemplos:
        `ano` é `INT64` porque dá para subtrair 2021 - 2005
        `salario` é `FLOAT64` porque dá para subtrair R$1250 - R$800
        variáveis categóricas/enum são `STRING`

Deixar nas unidades de medida originais e preencher nas tabelas de arquitetura.
    Exceção: séries financeiras com mudança de moeda - converter para moeda atual.

Só recebe o prefixo `id_` as colunas representando chaves primárias de entidades (que potencialmente teriam uma tabela diretório)
    Exemplos: `id_municipio`, `id_uf`, `id_escola`, `id_pessoa`.
    Exemplos que não recebem: `rede`, `localizacao`.

Regras para strings
Para variáveis de categorias: tudo minúsculo, sem acentos, padronizado
Tirar "de", "da", "dos", etc dos títulos.
Para variáveis de nomes próprios ou descrições extensas: como original

Nomeação de tabelas
Sem regra fixa, mas:
    entidades da tabela
        Exemplos: `municipio`, `uf`, `aluno`
    não inclui unidade temporal
        `municipio`, não `municipio_ano`

Formato de tabelas
Tempo sempre em formato "long".

- Ordenamento de variáveis
Variáveis identificadoras na esquerda.
Chaves mais abrangentes na esquerda.
    Exemplo de ordem: `ano`, `sigla_uf`, `id_municipio`, `id_escola`, `nota_ideb`.
Agrupe e ordene variáveis por importância/temas


- No máximo uma base por PR
    Pode ser um PR por tabela

- regras para quais colunas identificadoras manter, quais adicionar, e quais tirar
tirar strings de nomes que já estão em diretórios
manter/adicionar colunas servindo de partição (e.g. sigla_uf)
adicionar chaves principais para cada unidade já existente (e.g. id_municipio_tse -> id_municipio)
manter todas as chaves que já vem com a tabela, mas (1) adicionar chaves relevantes (sigla_uf, id_municipio) e (2) retirar chaves irrelevantes (regiao)

Dicionário
Tudo STRING





# Diretrizes para valores em células

Todas os dados na BD+ devem seguir o mesmo padrão de formatos e unidades de medida para que haja uma real integração.

## Formatos

- Decimal: formato americano, i.e. sempre `.` (ponto) ao invés de `,` (vírgula).
- Data: YYYY-MM-DD
- Horário (24h): HH:MM:SS
- Datetime ([ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)): YYYY-MM-DDTHH:MM:SS.sssZ
- Valor nulo: `""` (csv), `NULL` (Python), `NA` (R), `.` ou `""` (Stata)
- Porcentagem: entre 0-100

## Unidades de medida

- Área: 1 km2
- Temperatura: graus Celsius
- Dinheiro: 1 unidade
- População: 1 pessoa