cleanup  <- function(path, sheet){
  readxl::read_excel(path = path, 
                     range = "A3:HC34", 
                     sheet = sheet) %>% 
    slice(-linhas) %>% 
    t() %>% 
    as_tibble() %>% 
    rename(lista_cols) %>% 
    filter(mes %in% names(meses)) %>% 
    fill(ano) %>% 
    pivot_longer(`Rondônia`:`Distrito Federal`, names_to = "uf", values_to = "consumo") %>% 
    mutate(mes = meses[mes], ano = anos[ano] %>%
             unname(), across(.cols = consumo, as.numeric)) %>% 
    left_join(uf, by = "uf") %>% 
    select(ano, mes, sigla_uf, consumo)} 
