# Chaves externas

Podemos cruzar tabelas na BD+ fazendo _joins_ em cima de **chaves externas** (_foreign keys_). Essas são colunas que servem para identificar unicamente entidades no repositório.

**Critérios** para uma variável ser uma chave externa:

- Nome da variável é único entre todos as bases do repositório BD+;
- Identifica unicamente a entidade e não tem valores nulos na tabela correspondente de diretório.

## Chaves geográficas

- Setor censitário: `id_setor_censitario`

- Município: `id_municipio`, `id_municipio_6`, `id_municipio_tse`, `id_municipio_rf`, `id_municipio_bcb`

- Área Mínima Comparável: `id_AMC`

- Região imediata: `id_regiao_imediata`

- Região intermediária: `id_regiao_intermediaria`

- Microrregião: `id_microrregiao`

- Mesorregião: `id_mesorregiao`

- Unidade da federação (UF): `id_uf`, `sigla_uf`, `uf`

- Região: `regiao`

## Chaves temporais

- `ano`, `semestre`, `mes`, `semana`, `dia`, `hora`

## Chaves de pessoas físicas

- `cpf`, `pis`, `nis`

## Chaves de pessoas jurídicas

- Empresa: `cnpj`

- Escola: `id_escola`

## Chaves em política

- Candidato(a): `id_candidato_bd`

- Partido: `sigla_partido`, `partido`

