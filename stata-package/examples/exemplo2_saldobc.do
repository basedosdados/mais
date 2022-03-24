*** Pacote basedosdados - EXEMPLO 2 - SALDO BALANÇA COMERCIAL DO BRASIL EM 2020 ***
*** Isabella | Data: 18/03/2022                                                 ***

*EXEMPLO 2
*2.1) DADOS
cd "C:/Users/isabe/OneDrive/Documentos/GitHub/mais/stata-package/testes/" // defina a pasta onde serão salvos os arquivos

bd_read_sql, path("~/Downloads/BR_2020.csv") query("WITH m AS (SELECT ano, sigla_uf, SUM(valor_fob_dolar) AS importacao FROM basedosdados.br_me_comex_stat.municipio_importacao AS t1 WHERE ano = 2020 GROUP BY ano, sigla_uf ORDER BY importacao DESC) SELECT t1.ano, t1.sigla_uf, importacao, SUM(valor_fob_dolar) AS exportacao FROM m AS t1 JOIN basedosdados.br_me_comex_stat.municipio_exportacao AS t2 ON t1.ano = t2.ano AND t1.sigla_uf = t2.sigla_uf GROUP BY ano, sigla_uf, importacao ORDER BY importacao DESC") billing_project_id("monografia-12061998")

gen saldo = (exportacao - importacao)/1000000
