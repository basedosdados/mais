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

CREATE VIEW basedosdados-312117.br_rj_rio_de_janeiro_ipp_ips.dimensoes_componentes AS
SELECT 
SAFE_CAST(regiao_administrativa AS STRING) regiao_administrativa,
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(ips_geral AS FLOAT64) ips_geral,
SAFE_CAST(necessidades_humanas_basicas_nota_dimensao AS FLOAT64) necessidades_humanas_basicas_nota_dimensao,
SAFE_CAST(nutricao_e_cuidados_medicos_basicos AS FLOAT64) nutricao_e_cuidados_medicos_basicos,
SAFE_CAST(agua_e_saneamento AS FLOAT64) agua_e_saneamento,
SAFE_CAST(moradia AS FLOAT64) moradia,
SAFE_CAST(seguranca_pessoal AS FLOAT64) seguranca_pessoal,
SAFE_CAST(fundamentos_bem_estar_nota_dimensao AS FLOAT64) fundamentos_bem_estar_nota_dimensao,
SAFE_CAST(acesso_ao_conhecimento_basico AS FLOAT64) acesso_ao_conhecimento_basico,
SAFE_CAST(acesso_a_informacao AS FLOAT64) acesso_a_informacao,
SAFE_CAST(saude_e_bem_estar AS FLOAT64) saude_e_bem_estar,
SAFE_CAST(qualidade_do_meio_ambiente AS FLOAT64) qualidade_do_meio_ambiente,
SAFE_CAST(oportunidades_nota_dimensao AS FLOAT64) oportunidades_nota_dimensao,
SAFE_CAST(direitos_individuais AS FLOAT64) direitos_individuais,
SAFE_CAST(liberdades_individuais AS FLOAT64) liberdades_individuais,
SAFE_CAST(tolerancia_e_inclusao AS FLOAT64) tolerancia_e_inclusao,
SAFE_CAST(acesso_a_educacao_superior AS FLOAT64) acesso_a_educacao_superior
from basedosdados-312117.br_rj_rio_de_janeiro_ipp_ips_staging.dimensoes_componentes as t