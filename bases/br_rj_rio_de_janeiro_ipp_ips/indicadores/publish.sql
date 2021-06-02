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
SAFE_CAST(regiao_administrativa AS STRING) regiao_administrativa,
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(mortalidade_na_infancia AS FLOAT64) mortalidade_na_infancia,
SAFE_CAST(baixo_peso_ao_nascer AS FLOAT64) baixo_peso_ao_nascer,
SAFE_CAST(mortalidade_materna AS FLOAT64) mortalidade_materna,
SAFE_CAST(internacoes_infantis_por_crise_respiratoria_aguda AS FLOAT64) internacoes_infantis_por_crise_respiratoria_aguda,
SAFE_CAST(acesso_a_agua_canalizada AS FLOAT64) acesso_a_agua_canalizada,
SAFE_CAST(acesso_a_esgotamento_sanitario AS FLOAT64) acesso_a_esgotamento_sanitario,
SAFE_CAST(acesso_a_banheiro AS FLOAT64) acesso_a_banheiro,
SAFE_CAST(populacao_vivendo_em_favelas_nao_urbanizadas AS FLOAT64) populacao_vivendo_em_favelas_nao_urbanizadas,
SAFE_CAST(acesso_a_energia_eletrica AS FLOAT64) acesso_a_energia_eletrica,
SAFE_CAST(adensamento_habitacional_excessivo AS FLOAT64) adensamento_habitacional_excessivo,
SAFE_CAST(taxa_de_homicidios AS FLOAT64) taxa_de_homicidios,
SAFE_CAST(roubos_de_rua AS FLOAT64) roubos_de_rua,
SAFE_CAST(alfabetizacao AS FLOAT64) alfabetizacao,
SAFE_CAST(qualidade_do_ensino_fundamental_anos_iniciais AS FLOAT64) qualidade_do_ensino_fundamental_anos_iniciais,
SAFE_CAST(qualidade_do_ensino_fundamental_anos_finais AS FLOAT64) qualidade_do_ensino_fundamental_anos_finais,
SAFE_CAST(abandono_escolar_no_ensino_medio AS FLOAT64) abandono_escolar_no_ensino_medio,
SAFE_CAST(acesso_a_telefone_celular_ou_fixo AS FLOAT64) acesso_a_telefone_celular_ou_fixo,
SAFE_CAST(acesso_a_internet AS FLOAT64) acesso_a_internet,
SAFE_CAST(mortalidade_por_doencas_cronicas AS FLOAT64) mortalidade_por_doencas_cronicas,
SAFE_CAST(incidencia_de_dengue AS FLOAT64) incidencia_de_dengue,
SAFE_CAST(mortalidade_por_tuberculose_e_hiv AS FLOAT64) mortalidade_por_tuberculose_e_hiv,
SAFE_CAST(coleta_seletiva_de_lixo AS FLOAT64) coleta_seletiva_de_lixo,
SAFE_CAST(degradacao_de_areas_verdes AS FLOAT64) degradacao_de_areas_verdes,
SAFE_CAST(mobilidade_urbana AS FLOAT64) mobilidade_urbana,
SAFE_CAST(homicidios_por_acao_policial AS FLOAT64) homicidios_por_acao_policial,
SAFE_CAST(tempo_medio_de_deslocamento AS FLOAT64) tempo_medio_de_deslocamento,
SAFE_CAST(participacao_politica AS FLOAT64) participacao_politica,
SAFE_CAST(gravidez_na_adolescencia AS FLOAT64) gravidez_na_adolescencia,
SAFE_CAST(trabalho_infantil AS FLOAT64) trabalho_infantil,
SAFE_CAST(indice_de_acesso_a_cultura AS FLOAT64) indice_de_acesso_a_cultura,
SAFE_CAST(violencia_contra_a_mulher AS FLOAT64) violencia_contra_a_mulher,
SAFE_CAST(homicidios_de_jovens_negros AS FLOAT64) homicidios_de_jovens_negros,
SAFE_CAST(vulnerabilidade_familiar AS FLOAT64) vulnerabilidade_familiar,
SAFE_CAST(pessoas_com_ensino_superior AS FLOAT64) pessoas_com_ensino_superior,
SAFE_CAST(negros_e_indigenas_com_ensino_superior AS FLOAT64) negros_e_indigenas_com_ensino_superior,
SAFE_CAST(frequencia_ao_ensino_superior AS FLOAT64) frequencia_ao_ensino_superior
from basedosdados-312117.br_rj_rio_de_janeiro_ipp_ips_staging.indicadores as t