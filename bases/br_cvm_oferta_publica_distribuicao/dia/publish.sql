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

CREATE VIEW basedosdados-dev.br_cvm_oferta_publica_distribuicao.dia AS
SELECT 
SAFE_CAST(numero_processo AS STRING) numero_processo,
SAFE_CAST(numero_registro_oferta AS STRING) numero_registro_oferta,
SAFE_CAST(tipo_oferta AS STRING) tipo_oferta,
SAFE_CAST(tipo_componente_oferta_mista AS STRING) tipo_componente_oferta_mista,
SAFE_CAST(tipo_ativo AS STRING) tipo_ativo,
SAFE_CAST(cnpj_emissor AS STRING) cnpj_emissor,
SAFE_CAST(nome_emissor AS STRING) nome_emissor,
SAFE_CAST(cnpj_lider AS STRING) cnpj_lider,
SAFE_CAST(nome_lider AS STRING) nome_lider,
SAFE_CAST(nome_vendedor AS STRING) nome_vendedor,
SAFE_CAST(cnpj_ofertante AS STRING) cnpj_ofertante,
SAFE_CAST(nome_ofertante AS STRING) nome_ofertante,
SAFE_CAST(rito_oferta AS STRING) rito_oferta,
SAFE_CAST(modalidade_registro_oferta AS STRING) modalidade_registro_oferta,
SAFE_CAST(modalidade_dispensa_oferta AS STRING) modalidade_dispensa_oferta,
SAFE_CAST(data_abertura_processo AS DATE) data_abertura_processo,
SAFE_CAST(data_protocolo AS DATE) data_protocolo,
SAFE_CAST(data_dispensa_oferta AS DATE) data_dispensa_oferta,
SAFE_CAST(data_registro_oferta AS DATE) data_registro_oferta,
SAFE_CAST(data_encerramento_oferta AS DATE) data_encerramento_oferta,
SAFE_CAST(emissao AS STRING) emissao,
SAFE_CAST(classe_ativo AS STRING) classe_ativo,
SAFE_CAST(serie AS STRING) serie,
SAFE_CAST(especie_ativo AS STRING) especie_ativo,
SAFE_CAST(forma_ativo AS STRING) forma_ativo,
SAFE_CAST(data_emissao AS DATE) data_emissao,
SAFE_CAST(data_vencimento AS DATE) data_vencimento,
SAFE_CAST(quantidade_sem_lote_suplementar AS INT64) quantidade_sem_lote_suplementar,
SAFE_CAST(quantidade_no_lote_suplementar AS INT64) quantidade_no_lote_suplementar,
SAFE_CAST(quantidade_total AS INT64) quantidade_total,
SAFE_CAST(preco_unitario AS FLOAT64) preco_unitario,
SAFE_CAST(valor_total AS FLOAT64) valor_total,
SAFE_CAST(oferta_inicial AS STRING) oferta_inicial,
SAFE_CAST(oferta_incentivo_fiscal AS STRING) oferta_incentivo_fiscal,
SAFE_CAST(oferta_regime_fiduciario AS STRING) oferta_regime_fiduciario,
SAFE_CAST(atualizacao_monetaria AS STRING) atualizacao_monetaria,
SAFE_CAST(juros AS STRING) juros,
SAFE_CAST(projeto_audiovisual AS STRING) projeto_audiovisual
FROM basedosdados-dev.br_cvm_oferta_publica_distribuicao_staging.dia AS t