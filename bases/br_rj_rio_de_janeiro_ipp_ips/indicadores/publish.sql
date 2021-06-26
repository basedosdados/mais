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

CREATE VIEW basedosdados-312117.br_rj_rio_de_janeiro_ipp_ips.indicadores AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(regiao_administrativa AS STRING) regiao_administrativa,
SAFE_CAST(mortalidade_infancia AS FLOAT64) mortalidade_infancia,
SAFE_CAST(prop_baixo_peso_nascer AS FLOAT64) prop_baixo_peso_nascer,
SAFE_CAST(mortalidade_materna AS FLOAT64) mortalidade_materna,
SAFE_CAST(taxa_internacoes_infantis_crise_respiratoria_aguda AS FLOAT64) taxa_internacoes_infantis_crise_respiratoria_aguda,
SAFE_CAST(prop_acesso_agua_canalizada AS FLOAT64) prop_acesso_agua_canalizada,
SAFE_CAST(prop_acesso_esgotamento_sanitario AS FLOAT64) prop_acesso_esgotamento_sanitario,
SAFE_CAST(prop_acesso_banheiro AS FLOAT64) prop_acesso_banheiro,
SAFE_CAST(prop_populacao_vivendo_favelas_nao_urbanizadas AS FLOAT64) prop_populacao_vivendo_favelas_nao_urbanizadas,
SAFE_CAST(prop_acesso_energia_eletrica AS FLOAT64) prop_acesso_energia_eletrica,
SAFE_CAST(prop_adensamento_habitacional_excessivo AS FLOAT64) prop_adensamento_habitacional_excessivo,
SAFE_CAST(taxa_homicidios AS FLOAT64) taxa_homicidios,
SAFE_CAST(taxa_roubos_rua AS FLOAT64) taxa_roubos_rua,
SAFE_CAST(prop_alfabetizacao AS FLOAT64) prop_alfabetizacao,
SAFE_CAST(qualidade_ensino_fundamental_anos_iniciais AS FLOAT64) qualidade_ensino_fundamental_anos_iniciais,
SAFE_CAST(qualidade_ensino_fundamental_anos_finais AS FLOAT64) qualidade_ensino_fundamental_anos_finais,
SAFE_CAST(prop_abandono_escolar_ensino_medio AS FLOAT64) prop_abandono_escolar_ensino_medio,
SAFE_CAST(prop_acesso_telefone_celular_fixo AS FLOAT64) prop_acesso_telefone_celular_fixo,
SAFE_CAST(prop_acesso_internet AS FLOAT64) prop_acesso_internet,
SAFE_CAST(taxa_mortalidade_doencas_cronicas AS FLOAT64) taxa_mortalidade_doencas_cronicas,
SAFE_CAST(taxa_incidencia_dengue AS FLOAT64) taxa_incidencia_dengue,
SAFE_CAST(taxa_mortalidade_tuberculose_hiv AS FLOAT64) taxa_mortalidade_tuberculose_hiv,
SAFE_CAST(prop_coleta_seletiva_lixo AS FLOAT64) prop_coleta_seletiva_lixo,
SAFE_CAST(degradacao_areas_verdes AS FLOAT64) degradacao_areas_verdes,
SAFE_CAST(prop_mobilidade_urbana AS FLOAT64) prop_mobilidade_urbana,
SAFE_CAST(taxa_homicidios_acao_policial AS FLOAT64) taxa_homicidios_acao_policial,
SAFE_CAST(tempo_medio_deslocamento AS FLOAT64) tempo_medio_deslocamento,
SAFE_CAST(taxa_participacao_politica AS FLOAT64) taxa_participacao_politica,
SAFE_CAST(prop_gravidez_adolescencia AS FLOAT64) prop_gravidez_adolescencia,
SAFE_CAST(trabalho_infantil AS FLOAT64) trabalho_infantil,
SAFE_CAST(indice_acesso_cultura AS FLOAT64) indice_acesso_cultura,
SAFE_CAST(taxa_violencia_contra_mulher AS FLOAT64) taxa_violencia_contra_mulher,
SAFE_CAST(taxa_homicidios_jovens_negros AS FLOAT64) taxa_homicidios_jovens_negros,
SAFE_CAST(prop_vulnerabilidade_familiar AS FLOAT64) prop_vulnerabilidade_familiar,
SAFE_CAST(prop_pessoas_ensino_superior AS FLOAT64) prop_pessoas_ensino_superior,
SAFE_CAST(prop_negros_indigenas_ensino_superior AS FLOAT64) prop_negros_indigenas_ensino_superior,
SAFE_CAST(prop_frequencia_ensino_superior AS FLOAT64) prop_frequencia_ensino_superior
from basedosdados-312117.br_rj_rio_de_janeiro_ipp_ips_staging.indicadores as t