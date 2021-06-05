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
      dplyr::mutate(
        regiao_administrativa = dplyr::case_when(
          regiao_administrativa != "RIO DE JANEIRO" ~ stringr::str_replace(regiao_administrativa, "^[A-Z]+\\s", ""),
          TRUE ~ regiao_administrativa
        )
      ) %>% 
      dplyr::mutate(
        regiao_administrativa = stringr::str_to_title(regiao_administrativa, locale = "pt"),
        ano = stringr::str_extract(.x, "\\d{4}") %>% as.numeric()
      ) %>% 
      tidyr::drop_na() %>% 
      dplyr::relocate(ano, .before = regiao_administrativa)
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
      dplyr::mutate(
        regiao_administrativa = dplyr::case_when(
          regiao_administrativa != "RIO DE JANEIRO" ~ stringr::str_replace(regiao_administrativa, "^[A-Z]+\\s", ""),
          TRUE ~ regiao_administrativa
        ),
        regiao_administrativa = stringr::str_to_title(regiao_administrativa, locale = "pt"),
        ano = stringr::str_extract(.x, "\\d{4}") %>% as.numeric()
      ) %>% 
      tidyr::drop_na() %>% 
      dplyr::relocate(ano, .before = regiao_administrativa)
  ) %>% 
  purrr::map_df(~tidyr::unnest(.x)) %>% 
  readr::write_csv(file = "output/dimensoes_componentes.csv")

