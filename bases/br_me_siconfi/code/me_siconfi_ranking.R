## Libs

library(tidyverse)

## Importing

estados <- read_delim("~/Downloads/Estados_sintetico_bspn.csv", 
                                     delim = ";", escape_double = FALSE, col_types = cols(COD_IBGE = col_integer()), 
                                     locale = locale(decimal_mark = ","), 
                                     trim_ws = TRUE)

municipios <- read_delim("~/Downloads/municipios_bspn.csv", 
                      delim = ";", escape_double = FALSE, col_types = cols(COD_IBGE = col_integer()), 
                      locale = locale(decimal_mark = ","), 
                      trim_ws = TRUE)

capitais <- read_delim("~/Downloads/Capitais_sintetico_bspn.csv", 
                         delim = ";", escape_double = FALSE, col_types = cols(COD_IBGE = col_integer()), 
                         locale = locale(decimal_mark = ","), 
                         trim_ws = TRUE)
## Tidying and exporting

estados %>%
  rename(ano = VA_EXERCICIO,
         sigla_uf = SG_ESTADO,
         id_uf = COD_IBGE,
         indicador_qualidade_informacao_contabil_fiscal = NO_ICF,
         posicao_ranking = POS_RANKING,
         quantidade_acertos_total = VA_ACERTOS_TOTAL,
         proporcao_acertos = PER_ACERTOS,
         dimensao_I = `DIM-I`,
         dimensao_II = `DIM-II`,
         dimensao_III = `DIM-III`,
         dimensao_IV = `DIM-IV`) %>%
  select(ano, sigla_uf, id_uf, indicador_qualidade_informacao_contabil_fiscal, posicao_ranking, quantidade_acertos_total, proporcao_acertos, dimensao_I, dimensao_II, dimensao_III, dimensao_IV) %>%
  write_csv(file = "uf_ranking_qualidade_informacao_fiscal_contabil.csv", na = "")


municipios %>%
  rename(ano = VA_EXERCICIO,
         sigla_uf = SG_UF,
         id_municipio = COD_IBGE,
         indicador_qualidade_informacao_contabil_fiscal = NO_ICF,
         posicao_ranking = POS_RANKING,
         quantidade_acertos_total = VA_ACERTOS_TOTAL,
         proporcao_acertos = PER_ACERTOS,
         dimensao_I = `DIM-I`,
         dimensao_II = `DIM-II`,
         dimensao_III = `DIM-III`,
         dimensao_IV = `DIM-IV`) %>%
  select(ano, sigla_uf, id_municipio, indicador_qualidade_informacao_contabil_fiscal, posicao_ranking, quantidade_acertos_total, proporcao_acertos, dimensao_I, dimensao_II, dimensao_III, dimensao_IV) %>%
  write_csv(file = "municipios_ranking_qualidade_informacao_fiscal_contabil.csv", na = "")


capitais %>%
  rename(ano = VA_EXERCICIO,
         id_municipio = COD_IBGE,
         indicador_qualidade_informacao_contabil_fiscal = NO_ICF,
         posicao_ranking = POS_RANKING,
         quantidade_acertos_total = VA_ACERTOS_TOTAL,
         proporcao_acertos = PER_ACERTOS,
         dimensao_I = `DIM-I`,
         dimensao_II = `DIM-II`,
         dimensao_III = `DIM-III`,
         dimensao_IV = `DIM-IV`) %>%
  select(ano, id_municipio, indicador_qualidade_informacao_contabil_fiscal, posicao_ranking, quantidade_acertos_total, proporcao_acertos, dimensao_I, dimensao_II, dimensao_III, dimensao_IV) %>%
  write_csv(file = "capitais_ranking_qualidade_informacao_fiscal_contabil.csv", na = "")

