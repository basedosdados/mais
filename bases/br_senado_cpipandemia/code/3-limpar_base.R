## Rodrigo Dornelles - Fri Jul 02 22:45:40 2021
##
## Objetivo: limpeza dos discursos e nome dos oradores


# Pacotes -----------------------------------------------------------

library(magrittr)
library(tibble)


# carregar a base suja ----------------------------------------------------

base <- readr::read_rds("tmp/rds/base_suja.rds")

# expressões a serem removidas --------------------------------------------
# do campo falante

remover <- c("Para questão de ordem\\.", "Pela ordem\\.",
             "Fora do microfone\\.", "Bloco Parlamentar.*\\/",
             "Bloco",
             "Para responder questão de ordem\\.", "Por videoconferência\\.",
             "Para interpelar\\.", "Para expor\\.", "PRESIDENTE ",
             "Para depor\\.", "Para breve comunicação\\.",
             "Fala da Presidência\\.", "Para comunicação inadiável",
             "Para explicação pessoal", "Como Relator",
             "Fazendo soar a campainha", "Para contraditar",
             "GEN\\. ",
             "Para discutir", "[[:upper:]]*.-.[[:upper:]]{2,2}",
             "[[:punct:]]*",
             "\\.") %>%
  # montar a regex
  stringr::str_c(collapse = "|")

base_limpa <- base %>%
  dplyr::mutate(
    # características da fala
    pela_ordem = stringr::str_detect(falante, "Pela ordem"),
    questao_ordem = stringr::str_detect(falante, "Para questão de ordem"),
    fora_microfone = stringr::str_detect(falante, "Fora do microfone."),
    responder_qordem = stringr::str_detect(falante, "Para responder questão de ordem."),
    por_videoconferencia = stringr::str_detect(falante, "Por videoconferência."),
    para_interpelar = stringr::str_detect(falante, "Para interpelar."),
    para_expor = stringr::str_detect(falante, "Para expor"),
    para_depor = stringr::str_detect(falante, "Para depor."),
    bloco_parlamentar = stringr::str_extract(falante, "Bloco Parlamentar.*\\/"),
    como_presidente = stringr::str_detect(falante, "PRESIDENTE "),
    # separar o partido
    partido = stringr::str_extract(falante, "[[:upper:]]*.-.[[:upper:]]{2,2}"),
    # remover as expressões da lista
    falante = stringr::str_remove_all(falante, remover),
    # padronizar o nome da pessoa que está falando
    falante = stringr::str_trim(falante),
    falante = stringr::str_to_upper(falante),
    # limpar bloco e o texto
    bloco_parlamentar = stringr::str_remove(bloco_parlamentar, "\\/"),
    texto = stringr::str_trim(texto)
  )


# separar sigla do partido da UF ------------------------------------------

base_limpa <- base_limpa %>%
  tidyr::separate(col = partido,
                  into = c("partido_sigla", "partido_uf"),
                  sep = " - ")


# corrigir duplicados -----------------------------------------------------

base_limpa <- base_limpa %>%
  dplyr::mutate(
    falante = dplyr::case_when(
    falante == "MARCELO ANTÔNIO CARTAXO QUEIROGA LOPES" ~ "MARCELO QUEIROGA",
    falante == "MARCELLUS JOSÉ BARROSO CAMPÊLO" ~ "MARCELLUS CAMPELO",
    TRUE ~ falante
    )
  )


# acrescentar dados -------------------------------------------------------

# acrescentar gênero
base_limpa <- base_limpa %>%
  dplyr::mutate(
    genero = genderBR::get_gender(abjutils::rm_accent(falante)),
    genero = dplyr::if_else(genero == "Female", "Feminino",
                            "Masculino",
                            # os nomes NA eram de homens
                            "Masculino")
  )

# se é ou não parlamentar do Senado
base_limpa <- base_limpa %>%
  dplyr::mutate(
    # padronizar Osmar Terra que aparece às vezes com partido
    partido_sigla = dplyr::if_else(falante %in% c("OSMAR TERRA",
                                                  "LUIS MIRANDA"),
                                   NA_character_,
                                   partido_sigla),
    senado = dplyr::if_else(is.na(partido_sigla), FALSE, TRUE, FALSE)
  )

# papel na Comissão

base_limpa <- base_limpa %>%
  dplyr::mutate(
    papel = dplyr::case_when(
      senado == FALSE ~ "Depoente/Convidado",
    #  como_presidente == TRUE ~ "Presidindo Sessão",
      senado == TRUE ~ "Senador/a",
      TRUE ~ NA_character_
    )
  )


# corrigir partidos -------------------------------------------------------

base_limpa <- base_limpa %>%
  dplyr::mutate(
    partido_sigla = dplyr::if_else(
      is.na(partido_sigla),
      "Sem partido/Não se aplica",
      partido_sigla
    )
  )


# nomes colunas -----------------------------------------------------------
# ajusta para serem mais padronizados

base_limpa <- base_limpa %>%
  dplyr::select(-senado) %>%
  dplyr::rename(
    sequencial_sessao = numero_sessao,
    nome_discursante = falante,
    texto_discurso = texto,
    genero_discursante = genero,
    categoria_discursante = papel,
    horario_inicio_discurso = horario_inicio,
    horario_fim_discurso = horario_fim,
    duracao_discurso = horario_duracao,
    sigla_uf_partido = partido_uf,
    sigla_partido = partido_sigla,
    sinalizacao_pela_ordem = pela_ordem,
    sinalizacao_questao_ordem = questao_ordem,
    sinalizacao_como_presidente = como_presidente,
    sinalizacao_questao_ordem = questao_ordem,
    sinalizacao_por_videoconferencia = por_videoconferencia,
    sinalizacao_fora_microfone = fora_microfone,
    sinalizacao_para_expor = para_expor,
    sinalizacao_para_depor = para_depor,
    sinalizacao_para_interpelar = para_interpelar,
    sinalizacao_responder_questao_ordem = responder_qordem
  ) %>%
  dplyr::relocate(
    sequencial_sessao,
    data_sessao,
    texto_discurso,
    nome_discursante,
    genero_discursante,
    categoria_discursante,
    horario_inicio_discurso,
    horario_fim_discurso,
    duracao_discurso,
    sigla_partido,
    sigla_uf_partido,
    bloco_parlamentar
  ) %>%
  dplyr::mutate(
    duracao_discurso = lubridate::time_length(duracao_discurso),
    dplyr::across(
      dplyr::starts_with("horario_"),
      hms::as_hms
    ),
    dplyr::across(
      .cols = dplyr::starts_with("sinalizacao"),
      .fns = dplyr::if_else,
      true = "Sim",
      false = "Não"
    )
  )


# exportar ----------------------------------------------------------------

usethis::use_directory("output/discursos")

readr::with_edition(
  1,
  readr::write_csv(
    base_limpa,
    file = "output/discursos/discursos.csv")
  )


