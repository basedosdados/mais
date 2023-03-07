/*
Query para publicar a tabela.

Esse é o lugar para:
    - modificar nomes, ordem e tipos de colunas
    - dar join com outras tabelas
    - criar colunas extras (e.g. logs, proporções, etc.)

Qualquer coluna definida aqui deve também existir em `table_config.yaml`.

# Além disso, sinta-se à vontade para alterar alguns nomes obscuros
# para algo um pouco mais explícito.

TIPOS:
    - Para modificar tipos de colunas, basta substituir STRING por outro tipo válido.
    - Exemplo: `SAFE_CAST(column_name AS NUMERIC) column_name`
    - Mais detalhes: https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types
*/

CREATE VIEW basedosdados-dev.br_fbsp_absp.municipio AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(grupo AS STRING) grupo,
SAFE_CAST(quantidade_homicidio_doloso AS INT64) quantidade_homicidio_doloso,
SAFE_CAST(quantidade_latrocinio AS INT64) quantidade_latrocinio,
SAFE_CAST(quantidade_lesao_corporal_morte AS INT64) quantidade_lesao_corporal_morte,
SAFE_CAST(quantidade_mortes_policiais_confronto AS INT64) quantidade_mortes_policiais_confronto,
SAFE_CAST(quantidade_mortes_intervencao_policial AS INT64) quantidade_mortes_intervencao_policial,
SAFE_CAST(quantidade_mortes_intervencao_policial_civil_em_servico AS INT64) quantidade_mortes_intervencao_policial_civil_em_servico,
SAFE_CAST(quantidade_mortes_intervencao_policial_militar_em_servico AS INT64) quantidade_mortes_intervencao_policial_militar_em_servico,
SAFE_CAST(quantidade_mortes_intervencao_policial_civil_fora_de_servico AS INT64) quantidade_mortes_intervencao_policial_civil_fora_de_servico,
SAFE_CAST(quantidade_mortes_intervencao_policial_militar_fora_de_servico AS INT64) quantidade_mortes_intervencao_policial_militar_fora_de_servico,
SAFE_CAST(quantidade_mortes_violentas_intencionais AS INT64) quantidade_mortes_violentas_intencionais,
SAFE_CAST(quantidade_feminicidio AS INT64) quantidade_feminicidio,
SAFE_CAST(quantidade_lesao_corporal_dolosa_violencia_domestica AS INT64) quantidade_lesao_corporal_dolosa_violencia_domestica,
SAFE_CAST(quantidade_estupro AS INT64) quantidade_estupro,
SAFE_CAST(quantidade_roubo_veiculos AS INT64) quantidade_roubo_veiculos,
SAFE_CAST(quantidade_furto_veiculos AS INT64) quantidade_furto_veiculos,
SAFE_CAST(quantidade_roubo_furto_veiculos AS INT64) quantidade_roubo_furto_veiculos,
SAFE_CAST(proporcao_mortes_intenvencao_policial_x_mortes_violentas_intencionais AS FLOAT64) proporcao_mortes_intenvencao_policial_x_mortes_violentas_intencionais,
SAFE_CAST(quantidade_posse_ilegal_arma_de_fogo AS INT64) quantidade_posse_ilegal_arma_de_fogo,
SAFE_CAST(quantidade_porte_ilegal_arma_de_fogo AS INT64) quantidade_porte_ilegal_arma_de_fogo,
SAFE_CAST(quantidade_posse_ilegal_porte_ilegal_arma_de_fogo AS INT64) quantidade_posse_ilegal_porte_ilegal_arma_de_fogo,
SAFE_CAST(quantidade_trafico_entorpecente AS INT64) quantidade_trafico_entorpecente,
SAFE_CAST(quantidade_posse_uso_entorpecente AS INT64) quantidade_posse_uso_entorpecente,
SAFE_CAST(quantidade_morte_policiais_civis_confronto_em_servico AS INT64) quantidade_morte_policiais_civis_confronto_em_servico,
SAFE_CAST(quantidade_morte_policiais_militares_confronto_em_servico AS INT64) quantidade_morte_policiais_militares_confronto_em_servico,
SAFE_CAST(quantidade_morte_policiais_civis_fora_de_servico AS INT64) quantidade_morte_policiais_civis_fora_de_servico,
SAFE_CAST(quantidade_morte_policiais_militares_fora_de_servico AS INT64) quantidade_morte_policiais_militares_fora_de_servico
FROM basedosdados-dev.br_fbsp_absp_staging.municipio AS t