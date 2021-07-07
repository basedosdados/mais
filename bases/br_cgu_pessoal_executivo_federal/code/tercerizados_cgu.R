#### 2010 - 2018 ####
df2010_18 <- read_delim("cgu_2010_18.csv", ";", escape_double = FALSE, trim_ws = TRUE)

### 2019 #### 
df2019_01 = read_delim("cgu_2019_01.csv", ";", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)

names(df2019_01) = c("id_terc", "sg_orgao_sup_tabela_ug", "cd_ug_gestora", "nm_ug_tabela_ug", "sg_ug_gestora", 
                     "nr_contrato", "nr_cnpj", "nm_razao_social", "nr_cpf", "nm_terceirizado", "nm_categoria_profissional", 
                     "nm_escolaridade", "nr_jornada", "nm_unidade_prestacao", "vl_mensal_salario", "vl_mensal_custo", 
                     "Num_Mes_Carga", "Mes_Carga", "Ano_Carga","sg_orgao", "nm_orgao", "cd_orgao_siafi", "cd_orgao_siape")


df2019_05 = read_delim("cgu_2019_05.csv", ";", escape_double = FALSE, trim_ws = TRUE)
df2019_09 = read_delim("cgu_2020_09.csv", ";", escape_double = FALSE, trim_ws = TRUE)

### 2020 #### 
df2020_01 = read_delim("cgu_2020_01.csv", ";", escape_double = FALSE, trim_ws = TRUE)
df2020_05 = read_delim("cgu_2020_05.csv", ";", escape_double = FALSE, trim_ws = TRUE)
df2020_09 = read_delim("cgu_2020_09.csv", ";", escape_double = FALSE, trim_ws = TRUE)

#### 2021 #### 
df2021_01 <- read_delim("cgu_2021_01.csv",";", escape_double = FALSE, trim_ws = TRUE)

### tabela final ####
df_final = Reduce(rbind, list(df2010_18, df2019_01, df2019_05, df2019_09, df2020_01, df2020_05, df2020_09, df2021_01))

#### Tratamento dos Dados ####
df_final10_21 = df_final %>% 
  select(-Mes_Carga) %>% 
  rename(id_terceirizado = id_terc, sigla_orgao_superior_unidade_gestora = sg_orgao_sup_tabela_ug, 
         codigo_unidade_gestora = cd_ug_gestora, unidade_gestora = nm_ug_tabela_ug, sigla_unidade_gestora_terceirizado = sg_ug_gestora, 
         contrato_empresa = nr_contrato, cnpj_empresa = nr_cnpj, razao_social_empresa = nm_razao_social, 
         cpf_terceirizado = nr_cpf, nome_terceirizado = nm_terceirizado, categoria_profissional = nm_categoria_profissional, 
         nivel_escolaridade = nm_escolaridade, quantidade_horas_trabalhadas_semanais = nr_jornada, unidade_trabalho_terceirizado = nm_unidade_prestacao, 
         valor_terceirizado_mensal = vl_mensal_salario, custo_terceirizado_mensal = vl_mensal_custo, mes = Num_Mes_Carga, ano = Ano_Carga, sigla_orgao_trabalho_terceirizado = sg_orgao, 
         nome_orgao_trabalho_terceirizado = nm_orgao, codigo_siafi_trabalho_terceirizado = cd_orgao_siafi, codigo_siape_trabalho_terceirizado  = cd_orgao_siape) %>% 
  select(ano, mes, id_terceirizado, sigla_orgao_superior_unidade_gestora, codigo_unidade_gestora, unidade_gestora, 
         sigla_unidade_gestora_terceirizado, contrato_empresa, cnpj_empresa, razao_social_empresa, cpf_terceirizado, 
         nome_terceirizado, categoria_profissional, nivel_escolaridade, quantidade_horas_trabalhadas_semanais, 
         unidade_trabalho_terceirizado, valor_terceirizado_mensal, custo_terceirizado_mensal, sigla_orgao_trabalho_terceirizado, 
         nome_orgao_trabalho_terceirizado, codigo_siafi_trabalho_terceirizado, codigo_siape_trabalho_terceirizado) 

# exportar 
write.csv(df_final10_21,
          "~/basedosdados/tratamento/5_br_cgu_terceirizados/output/terceirizados.csv",
          na = " ",
          row.names = F, fileEncoding = "UTF-8")
