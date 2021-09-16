cleanup2  <- function(path, sheet){
  readxl::read_excel(path = path, 
                     range = "A3:HC34", 
                     sheet = sheet) %>% 
    slice(-linhas) %>% 
    t() %>% 
    as_tibble() %>% 
    rename(lista_cols) %>% 
    filter(mes %in% names(meses)) %>% 
    fill(ano) %>% 
    pivot_longer(`Rondônia`:`Distrito Federal`, names_to = "uf", values_to = "numero_consumidores") %>% 
    mutate(mes = meses[mes], ano = anos[ano] %>%
             unname(), across(.cols = numero_consumidores, as.numeric)) %>% 
    left_join(uf, by = "uf") %>% 
    select(ano, mes, sigla_uf, numero_consumidores)} 
