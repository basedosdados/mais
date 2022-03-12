
library(tidyverse)
library(dplyr)
library(basedosdados)

setwd("~/Downloads")

#set_billing_id("pessoal-rd")
set_billing_id("projeto-basedosdados-fl")

query = "
  WITH aprendizagem_adequada AS (
    SELECT *
    FROM `projeto-basedosdados-fl.tabelas.aprendizagem-adequada-ano-uf-serie`
    WHERE serie = 9
  ),
  aprendizagem_adequada_pretos AS (
    SELECT
      ano,
      sigla_uf,
      adequado_LP_publica AS adequado_LP_publica_pretos,
      adequado_MT_publica AS adequado_MT_publica_pretos,
      adequado_LP_privada AS adequado_LP_privada_pretos,
      adequado_MT_privada AS adequado_MT_privada_pretos,
      adequado_pandemia_PB_LP_publica AS adequado_pandemia_PB_LP_publica_pretos,
      adequado_pandemia_PB_MT_publica AS adequado_pandemia_PB_MT_publica_pretos,
      adequado_pandemia_SP_LP_publica AS adequado_pandemia_SP_LP_publica_pretos,
      adequado_pandemia_SP_MT_publica AS adequado_pandemia_SP_MT_publica_pretos
    FROM `projeto-basedosdados-fl.tabelas.aprendizagem-adequada-ano-uf-serie-raca`
    WHERE
      serie = 9 AND
      raca_cor = 'preto'
  ),
  ideb AS (
    SELECT
      ano,
      sigla_uf,
      ideb
    FROM `basedosdados.br_inep_ideb.uf`
    WHERE
      rede = 'publica' AND
      ensino = 'fundamental' AND
      anos_escolares = 'finais (6-9)'
  ),
  matriculas AS (
    SELECT *
    FROM `projeto-basedosdados-fl.tabelas.br_inep_censo_escolar_matricula_ano_uf_rede`
    PIVOT (
      MAX(numero_matriculas) AS numero_matriculas,
      MAX(porcentagem_nao_declarado) AS porcentagem_nao_declarado,
      MAX(porcentagem_branco) AS porcentagem_branco,
      MAX(porcentagem_preto) AS porcentagem_preto,
      MAX(porcentagem_pardo) AS porcentagem_pardo,
      MAX(porcentagem_amarelo) AS porcentagem_amarelo,
      MAX(porcentagem_indigena) AS porcentagem_indigena
      FOR rede in (
        'publica', 'privada'
      )
    )
  ),
  indicadores AS (
    SELECT
      ano,
      sigla_uf,
      atu_ef_9_ano,
      had_ef_9_ano,
      tdi_ef_9_ano,
      taxa_aprovacao_ef_9_ano,
      taxa_reprovacao_ef_9_ano,
      taxa_abandono_ef_9_ano,
      tnr_ef_9_ano
    FROM `basedosdados.br_inep_indicadores_educacionais.uf`
    WHERE localizacao = 'total' AND rede = 'publica'
  ),
  pop AS (
    SELECT *
    FROM `basedosdados.br_ibge_populacao.uf`
  )
  
  SELECT
    COALESCE(
      aprendizagem_adequada.ano,
      aprendizagem_adequada_pretos.ano,
      matriculas.ano,
      indicadores.ano,
      pib_pc.ano,
      pop.ano
    ) AS ano,
    COALESCE(
      aprendizagem_adequada.sigla_uf,
      aprendizagem_adequada_pretos.sigla_uf,
      matriculas.sigla_uf,
      indicadores.sigla_uf,
      pib_pc.sigla_uf,
      pop.sigla_uf
    ) AS sigla_uf,
    aprendizagem_adequada.insuficiente_LP_publica,
    aprendizagem_adequada.insuficiente_MT_publica,
    aprendizagem_adequada.basico_LP_publica,
    aprendizagem_adequada.basico_MT_publica,
    aprendizagem_adequada.proficiente_LP_publica,
    aprendizagem_adequada.proficiente_MT_publica,
    aprendizagem_adequada.avancado_LP_publica,
    aprendizagem_adequada.avancado_MT_publica,
    aprendizagem_adequada.adequado_LP_publica,
    aprendizagem_adequada.adequado_MT_publica,
    aprendizagem_adequada_pretos.adequado_LP_publica_pretos,
    aprendizagem_adequada_pretos.adequado_MT_publica_pretos,
    aprendizagem_adequada.adequado_pandemia_PB_LP_publica AS adequado_PB_LP_publica,
    aprendizagem_adequada.adequado_pandemia_PB_MT_publica AS adequado_PB_MT_publica,
    aprendizagem_adequada.adequado_pandemia_SP_LP_publica AS adequado_SP_LP_publica,
    aprendizagem_adequada.adequado_pandemia_SP_MT_publica AS adequado_SP_MT_publica,
    aprendizagem_adequada_pretos.adequado_pandemia_PB_LP_publica_pretos AS adequado_PB_LP_publica_pretos,
    aprendizagem_adequada_pretos.adequado_pandemia_PB_MT_publica_pretos AS adequado_PB_MT_publica_pretos,
    aprendizagem_adequada_pretos.adequado_pandemia_SP_LP_publica_pretos AS adequado_SP_LP_publica_pretos,
    aprendizagem_adequada_pretos.adequado_pandemia_SP_MT_publica_pretos AS adequado_SP_MT_publica_pretos,
    ideb.ideb,
    matriculas.* except (sigla_uf, ano),
    indicadores.* except (sigla_uf, ano),
    pib_pc.pib_pc,
    pop.populacao,
    pbf.familias_beneficiarias_pbf
  FROM aprendizagem_adequada
  LEFT JOIN aprendizagem_adequada_pretos
    ON
      aprendizagem_adequada.sigla_uf = aprendizagem_adequada_pretos.sigla_uf AND
      aprendizagem_adequada.ano = aprendizagem_adequada_pretos.ano
  LEFT JOIN ideb
    ON
      aprendizagem_adequada.sigla_uf = ideb.sigla_uf AND
      aprendizagem_adequada.ano = ideb.ano
  LEFT JOIN matriculas
    ON
      aprendizagem_adequada.sigla_uf = matriculas.sigla_uf AND
      aprendizagem_adequada.ano = matriculas.ano
  LEFT JOIN indicadores
    ON
      aprendizagem_adequada.sigla_uf = indicadores.sigla_uf AND
      aprendizagem_adequada.ano = indicadores.ano
  LEFT JOIN `basedosdados-projetos.fundacao_lemann.pib-per-capita-uf` AS pib_pc
    ON
      aprendizagem_adequada.sigla_uf = pib_pc.sigla_uf AND
      aprendizagem_adequada.ano = pib_pc.ano
  LEFT JOIN pop ON
    aprendizagem_adequada.sigla_uf = pop.sigla_uf AND
    aprendizagem_adequada.ano = pop.ano
  LEFT JOIN `basedosdados-projetos.fundacao_lemann.total-familias-pbf` AS pbf ON
    aprendizagem_adequada.sigla_uf = pbf.sigla_uf AND
    aprendizagem_adequada.ano = pbf.ano
"
df = basedosdados::read_sql(query) #, page_size = 5000)

write.csv(df, "/Users/ricardodahis/Dropbox/basedosdados/projects/Lemann/projecao saeb/input/dados_fl.csv",
          row.names = FALSE,
          na = "")
