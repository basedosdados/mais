
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