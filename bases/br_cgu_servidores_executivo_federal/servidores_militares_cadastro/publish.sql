/*

Query para publicar a tabela.

Esse é o lugar para:
    - modificar nomes, ordem e tipos de colunas
    - dar join com outras tabelas
    - criar colunas extras (e.g. logs, proporções, etc.)

Qualquer coluna definida aqui deve também existir em `table_config.yaml`.

-- Mudanças feitas --
- Parseamos as datas;
- Alteramos alguns nomes, para explicitar que se tratam de datas;
- Trocamos o prefixo cod_ por id_;
- Trocamos uf por sigla_uf.

PS: Esta view puxa dados do projeto `gabinete-compartilhado`. Os dados não estão no storage da `basedosdados`.
*/

CREATE VIEW `basedosdados.br_cgu_servidores_executivo_federal.servidores_militares_cadastro` AS
SELECT 
    SAFE_CAST(mes AS INT64) mes,
    SAFE_CAST(ano AS INT64) ano,
    SAFE_CAST(id_servidor AS STRING) id_servidor,
    SAFE_CAST(nome AS STRING) nome,
    SAFE_CAST(cpf AS STRING) cpf,
    SAFE_CAST(matricula AS STRING) matricula,
    SAFE_CAST(desc_cargo AS STRING) desc_cargo,
    SAFE_CAST(classe_cargo AS STRING) classe_cargo,
    SAFE_CAST(ref_cargo AS STRING) ref_cargo,
    SAFE_CAST(padrao_cargo AS STRING) padrao_cargo,
    SAFE_CAST(nivel_cargo AS STRING) nivel_cargo,
    SAFE_CAST(sigla_funcao AS STRING) sigla_funcao,
    SAFE_CAST(nivel_funcao AS STRING) nivel_funcao,
    SAFE_CAST(funcao AS STRING) funcao,
    SAFE_CAST(cod_atividade AS STRING) id_atividade,
    SAFE_CAST(atividade AS STRING) atividade,
    SAFE_CAST(opcao_parcial AS STRING) opcao_parcial,
    SAFE_CAST(cod_uorg_lotacao AS STRING) id_uorg_lotacao,
    SAFE_CAST(uorg_lotacao AS STRING) uorg_lotacao,
    SAFE_CAST(cod_org_lotacao AS STRING) id_org_lotacao,
    SAFE_CAST(org_lotacao AS STRING) org_lotacao,
    SAFE_CAST(cod_orgsup_lotacao AS STRING) id_orgsup_lotacao,
    SAFE_CAST(orgsup_lotacao AS STRING) orgsup_lotacao,
    SAFE_CAST(cod_uorg_exercicio AS STRING) id_uorg_exercicio,
    SAFE_CAST(uorg_exercicio AS STRING) uorg_exercicio,
    SAFE_CAST(cod_org_exercicio AS STRING) id_org_exercicio,
    SAFE_CAST(org_exercicio AS STRING) org_exercicio,
    SAFE_CAST(cod_orgsup_exercicio AS STRING) id_orgsup_exercicio,
    SAFE_CAST(orgsup_exercicio AS STRING) orgsup_exercicio,
    SAFE_CAST(tipo_vinculo AS STRING) tipo_vinculo,
    SAFE_CAST(situacao_vinculo AS STRING) situacao_vinculo,
    SAFE_CAST(PARSE_DATE('%d/%m/%Y', inicio_afastamento) AS DATE) data_inicio_afastamento,
    SAFE_CAST(PARSE_DATE('%d/%m/%Y', termino_afastamento) AS DATE) data_termino_afastamento,
    SAFE_CAST(regime_juridico AS STRING) regime_juridico,
    SAFE_CAST(jornada_de_trabalho AS STRING) jornada_de_trabalho,
    SAFE_CAST(PARSE_DATE('%d/%m/%Y', ingresso_cargo_funcao) AS DATE) data_ingresso_cargo_funcao,
    SAFE_CAST(PARSE_DATE('%d/%m/%Y', nomeacao_cargo_funcao) AS DATE) data_nomeacao_cargo_funcao,
    SAFE_CAST(PARSE_DATE('%d/%m/%Y', ingresso_orgao) AS DATE) data_ingresso_orgao,
    SAFE_CAST(doc_ingresso_servico_publico AS STRING) doc_ingresso_servico_publico,
    SAFE_CAST(PARSE_DATE('%d/%m/%Y', data_dipl_ingresso_servico_publico) AS DATE) data_dipl_ingresso_servico_publico,
    SAFE_CAST(dipl_ingresso_cargo_funcao AS STRING) dipl_ingresso_cargo_funcao,
    SAFE_CAST(dipl_ingresso_orgao AS STRING) dipl_ingresso_orgao,
    SAFE_CAST(dipl_ingresso_servico_publico AS STRING) dipl_ingresso_servico_publico,
    SAFE_CAST(uf_exercicio AS STRING) sigla_uf_exercicio,
    SAFE_CAST(data AS DATE) data
FROM `gabinete-compartilhado.views_publicos.servidores_federais_militares_cadastro` 

