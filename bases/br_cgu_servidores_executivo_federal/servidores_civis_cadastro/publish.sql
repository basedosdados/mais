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

SELECT 
    mes,
    ano,
    id_servidor,
    nome,
    cpf,
    matricula,
    desc_cargo,
    classe_cargo,
    ref_cargo,
    padrao_cargo,
    nivel_cargo,
    sigla_funcao,
    nivel_funcao,
    funcao,
    cod_atividade AS id_atividade,
    atividade,
    opcao_parcial,
    cod_uorg_lotacao AS id_uorg_lotacao,
    uorg_lotacao,
    cod_org_lotacao AS id_org_lotacao,
    org_lotacao,
    cod_orgsup_lotacao AS id_orgsup_lotacao,
    orgsup_lotacao,
    cod_uorg_exercicio AS id_uorg_exercicio,
    uorg_exercicio,
    cod_org_exercicio AS id_org_exercicio,
    org_exercicio,
    cod_orgsup_exercicio AS id_orgsup_exercicio,
    orgsup_exercicio,
    tipo_vinculo,
    situacao_vinculo,
    PARSE_DATE('%d/%m/%Y', inicio_afastamento) AS data_inicio_afastamento,
    PARSE_DATE('%d/%m/%Y', termino_afastamento) AS data_termino_afastamento,
    regime_juridico,
    jornada_de_trabalho,
    PARSE_DATE('%d/%m/%Y', ingresso_cargo_funcao) AS data_ingresso_cargo_funcao,
    PARSE_DATE('%d/%m/%Y', nomeacao_cargo_funcao) AS data_nomeacao_cargo_funcao,
    PARSE_DATE('%d/%m/%Y', ingresso_orgao) AS data_ingresso_orgao,
    doc_ingresso_servico_publico,
    PARSE_DATE('%d/%m/%Y', data_dipl_ingresso_servico_publico) AS data_dipl_ingresso_servico_publico,
    dipl_ingresso_cargo_funcao,
    dipl_ingresso_orgao,
    dipl_ingresso_servico_publico,
    uf_exercicio AS sigla_uf_exercicio,
    data
FROM `gabinete-compartilhado.views_publicos.servidores_executivo_federal_civis_cadastro`
