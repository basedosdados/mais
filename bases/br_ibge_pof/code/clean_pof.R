## github.com/arthurfg
## Libs
library(tidyverse)
library(basedosdados)


## Importando a tabela de Diretórios para criar a coluna 'sigla_uf'
set_billing_id("casebd")
query <- "SELECT id_uf, sigla FROM `basedosdados.br_bd_diretorios_brasil.uf`"
ufs <- read_sql(query)

ufs %>%
  rename(sigla_uf = sigla) -> ufs

## Criando uma lista com o nome de todos os registros da POF a partir dos arquivos presentes no meu diretório local ## nolint
list.files("/Users/apple/Documents/pof_bd/dados_rds") %>%
  str_remove("pof_") %>%
  str_remove(".rds") %>% as_tibble() %>%
  filter(value != "despesa" & value != "rendimentos_uc") %>%
  pull(value) -> registros


## Carregando o .csv renomeador, arquivo criado com os nomes novos e antigos
## extraídos das tabelas de arquitetura. 

renomeador <- read_csv("/Users/apple/Documents/pof_bd/renomeador.csv")

## Função que lê os dados, limpa as variáveis, renomeia, ordena e
## extrai os .csv`s nas suas devidas partiçoes

limpa_pof <- function(registro){ # nolint
  df <- read_rds(paste("/Users/apple/Documents/pof_bd/dados_rds/pof_",
                       ".rds", sep = registro))
  informante <- c("morador", "despesa_individual",
             "rendimento_trabalho", "outros_rendimentos",
             "caracteristicas_dieta", "consumo_alimentar", "condicoes_vida",
             "restricao_saude", "servico_nao_monetario_pof4")

  codigos <- c("aluguel_estimado", "caderneta_coletiva",
                          "despesa_individual", "rendimento_trabalho",
                          "outros_rendimentos", "inventario", "restricao_saude",
                          "consumo_alimentar",
                          "servico_nao_monetario_pof4")

  codigos_2 <- c("servico_nao_monetario_pof2", "despesa_coletiva")

  if (registro %in% informante) {

     df <- df %>% 
      mutate(NUM_DOM = str_pad(NUM_DOM, 2, "left", "0"),
            NUM_UC = str_pad(NUM_UC, 2, "left", "0"),
            COD_INFORMANTE = str_pad(COD_INFORMANTE, 2, "left", "0"),
            id_domicilio = str_c(COD_UPA, NUM_DOM),
            id_unidade_consumo = str_c(COD_UPA, NUM_DOM, NUM_UC),
            id_informante = str_c(COD_UPA, NUM_DOM, NUM_UC, COD_INFORMANTE))
            
  }
  else if (registro == "domicilio") {
     df <- df %>%
      mutate(NUM_DOM = str_pad(NUM_DOM, 2, "left", "0"),
            id_domicilio = str_c(COD_UPA, NUM_DOM))
  }
  else {
     df <- df %>%
      mutate(NUM_DOM = str_pad(NUM_DOM, 2, "left", "0"),
            NUM_UC = str_pad(NUM_UC, 2, "left", "0"),
            id_domicilio = str_c(COD_UPA, NUM_DOM),
            id_unidade_consumo = str_c(COD_UPA, NUM_DOM, NUM_UC))
  }
  if (registro %in% codigos) {
     df <- df %>% 
      mutate(id_codigo_5_bd = str_sub(V9001, 1, -3))
  }
  else if (registro %in% codigos_2) {
     df <- df %>% 
        mutate(id_codigo_5_bd = str_pad(V9001, 7, "left", "0")) %>% 
        mutate(id_codigo_5_bd = str_sub(V9001, 1, -3))
  }

  renomeador %>%
    select(tidyselect::starts_with(registro)) %>%
    drop_na() -> renomeador2

    oldnames <- renomeador2[[2]]
    newnames <- renomeador2[[1]]

  df %>%
    rename_at(all_of(oldnames), ~ newnames) %>%
    select(renomeador2[[1]]) %>%
    mutate_all(as.character) %>%
    left_join(ufs, by = "id_uf") %>%
    select(-id_uf) -> df

  dir.create(paste0("/Users/apple/Documents/pof_bd/output/",registro,"_2017"))

  for (uf in unique(df$sigla_uf)) {
  
  dir.create(paste0("/Users/apple/Documents/pof_bd/output/",registro,"_2017","/sigla_uf=",uf))
  
  df %>%
    filter(sigla_uf == uf) %>%
    select(-sigla_uf) %>%
    write_csv(file = paste0("/Users/apple/Documents/pof_bd/output/",registro,"_2017","/sigla_uf=",uf,"/",registro,"_2017.csv"),
                na = "",
                quote = c("none"))}
  }
## Aplicando a função limpa_pof() para cada elemento do vetor 'registros'

walk(registros, ~limpa_pof(.x))
