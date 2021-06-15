library(tidyverse)
library(fs)
library(janitor)

fs::dir_create(c("input", "output"))

utils::download.file(
  url = "https://www.arcgis.com/sharing/rest/content/items/39e092f61d7449ce911f77e5e5f8c5fb/data",
  destfile = "input/ips.xlsx"
)

readxl::excel_sheets("input/ips.xlsx") %>% 
  purrr::keep(~stringr::str_detect(.x, "Indicadores")) %>% 
  purrr::map(
    ~readxl::read_excel("input/ips.xlsx", sheet = .x, skip = 4) %>% 
      janitor::clean_names() %>% 
      dplyr::rename_all(
        ~stringr::str_replace_all(.x, "_(na|ao|a|de|da|por|em|ou|com|e|do|no)_", "_")
      ) %>% 
      dplyr::mutate(
        regiao_administrativa = dplyr::case_when(
          regiao_administrativa != "RIO DE JANEIRO" ~ stringr::str_replace(regiao_administrativa, "^[A-Z]+\\s", ""),
          TRUE ~ regiao_administrativa
        ),
        regiao_administrativa = stringr::str_to_title(regiao_administrativa, locale = "pt"),
        ano = stringr::str_extract(.x, "\\d{4}") %>% as.numeric()
      ) %>%
      dplyr::rename_with(
        ~stringr::str_c("prop_", .x), 
        .cols = c(
          baixo_peso_nascer,
          acesso_agua_canalizada,
          acesso_esgotamento_sanitario,
          acesso_banheiro,
          populacao_vivendo_favelas_nao_urbanizadas,
          acesso_energia_eletrica,
          adensamento_habitacional_excessivo,
          alfabetizacao,
          abandono_escolar_ensino_medio,
          acesso_telefone_celular_fixo,
          acesso_internet,
          coleta_seletiva_lixo,
          mobilidade_urbana,
          gravidez_adolescencia,
          vulnerabilidade_familiar,
          pessoas_ensino_superior,
          negros_indigenas_ensino_superior,
          frequencia_ensino_superior
        )
      ) %>% 
      dplyr::rename_with(
        ~stringr::str_c("taxa_", .x),
        .cols = c(
          internacoes_infantis_crise_respiratoria_aguda,
          roubos_rua,
          mortalidade_doencas_cronicas,
          incidencia_dengue,
          mortalidade_tuberculose_hiv,
          homicidios_acao_policial,
          participacao_politica,
          violencia_contra_mulher,
          homicidios_jovens_negros
        )
      ) %>% 
      tidyr::drop_na() %>% 
      dplyr::relocate(ano, .before = regiao_administrativa) %>% 
      dplyr::mutate(
        dplyr::across(dplyr::starts_with("prop_"), function(x) {
          if (x * 100 > 100) {
            return(x)
          }
          x * 100
        }),
        dplyr::across(!c(ano, regiao_administrativa), ~round(.x, digits = 2))
      )
  ) %>% 
  purrr::map_df(~tidyr::unnest(.x)) %>% 
  readr::write_csv(file = "output/indicadores.csv")

readxl::excel_sheets("input/ips.xlsx") %>% 
  purrr::keep(~stringr::str_detect(.x, "Componentes")) %>% 
  purrr::map(
    ~readxl::read_excel("input/ips.xlsx", sheet = .x, skip = 5) %>% 
      janitor::clean_names() %>% 
      dplyr::rename(
        regiao_administrativa = x1,
        ips_geral = x2,
        necessidades_humanas_basicas_nota_dimensao = nota_da_dimensao_3,
        fundamentos_bem_estar_nota_dimensao = nota_da_dimensao_8,
        oportunidades_nota_dimensao = nota_da_dimensao_13
      ) %>% 
      dplyr::rename_all(
        ~stringr::str_replace_all(.x, "_(na|ao|a|de|da|por|em|ou|com|e|do|no)_", "_")
      ) %>% 
      dplyr::mutate(
        regiao_administrativa = dplyr::case_when(
          regiao_administrativa != "RIO DE JANEIRO" ~ stringr::str_replace(regiao_administrativa, "^[A-Z]+\\s", ""),
          TRUE ~ regiao_administrativa
        ),
        regiao_administrativa = stringr::str_to_title(regiao_administrativa, locale = "pt"),
        ano = stringr::str_extract(.x, "\\d{4}") %>% as.numeric(),
        dplyr::across(!c(ano, regiao_administrativa), ~round(.x, digits = 2))
      ) %>% 
      tidyr::drop_na() %>% 
      dplyr::relocate(ano, .before = regiao_administrativa)
  ) %>% 
  purrr::map_df(~tidyr::unnest(.x)) %>% 
  readr::write_csv(file = "output/dimensoes_componentes.csv")
