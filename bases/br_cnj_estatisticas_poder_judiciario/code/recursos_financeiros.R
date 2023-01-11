## @arthurfg
## Importing Libs
library(tidyverse)

## Reading and parsing data

cnj <- read.csv2("JN_02-Set-2022.csv", header = TRUE, sep = ";", quote = "\"", dec = ",",
          fill = TRUE, comment.char = "", encoding = "unknown") 

## Selecting Columns
cnj %>%
    select(ano,
           tipo_periodo,
           periodo,
           justica,
           sigla,
           seq_orgao,
           drh,
           dpj,
           odck,
           odc,
           dk,
           dcc,
           dcc2,
           dcctrje1,
           dccadm,
           dfc,
           dfc2,
           dfctrje1,
           dfcadm,
           g1,
           pib,
           g2,
           gt,
           g3,
           g4,
           g5,
           g5a,
           g5b,
           g6,
           g7,
           h1,
           g8,
           g9,
           dpco,
           g10a,
           dmag,
           magp,
           magin,
           g10b,
           dserv,
           serv,
           tps,
           servin,
           g10c,
           tfauxt,
           g10d,
           tfauxe,
           inf1,
           dinf1,
           dinf2,
           eo1,
           odp,
           eo2,
           ok,
           eo3,
           dip,
           ooc,
           i1,
           r,
           i2,
           ref,
           i5,
           vpag,
           i6,
           depjud,
           dpe,
           dpea,
           dpei,
           dpea2,
           dpeatrje1,
           dpeaadm,
           dip,
           dip2,
           diptrje1,
           dipadm,
           dest, dter,
           dben,
           dbena,
           dbeni,
           dbena2,
           dbenatrje1,
           dbenaadm) %>%
    mutate(sigla_uf = str_extract(sigla, "(AC|AL|AP|AM|BA|CE|DF|ES|GO|MA|MT|MS|MG|PA|PB|PR|PE|PI|RJ|RN|RS|RO|RR|SC|SP|SE|TO|BR)")) -> cnj_novo

## Variables for the architecture

cnj_variaveis <- read_delim("/Users/apple/Documents/BackupR/Variaveis_02-Set-2022.csv", delim = ";", locale = locale(encoding = "latin1", asciify = TRUE))

cnj_novo %>%
    names() %>%
    pluck() -> vetor

cnj_variaveis %>%
    filter(sigla %in% vetor) %>%
    write_csv("arquitetura_cnj.csv")

## Reading `renomeador_cnj.csv`, which is a .csv with 2 columns containing old and new names for labeling columns, taken from architecture file # nolint
renomeador <- read_csv("/Users/apple/Documents/BackupR/renomeador_cnj.csv")

  renomeador %>%
    mutate(original_name = if_else(name == "sigla_uf", "sigla_uf",original_name )) %>%
    drop_na() -> renomeador2

    oldnames <- renomeador2[[2]]
    newnames <- renomeador2[[1]]

  cnj_novo %>%
    rename_at(all_of(oldnames), ~ newnames) %>%
    select(renomeador2[[1]]) -> df

### Exporting to .csv

df %>%
    mutate(across(c(6:79), ~ as.numeric(.x))) %>%
    write_csv("recursos_financeiros.csv", na = "")