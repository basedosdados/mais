rm( list = ls( ) ) 
graphics.off()
gc()
gc(reset = TRUE)
getwd()

#Lendo o arquivo csv. Esse aqui é o final.  

x <- read.csv('censo_agropecuario.csv', sep = ';')

#Verificando minhas variaveis
str(x)

#Mudando a posição da variável Ano
x <- dplyr::select(x,
               id_municipio, ano, everything())


#alteração do nome das variaveis
x |> 
  dplyr::rename(
  ano = year,
  id_municipio = municipality_id,
  area_total=a_total,
  area_proprietario=a_proprietario,
  area_arrendatario=a_arrendatario,
  area_parceiro=a_parceiro,
  area_ocupante=a_ocupante,
  area_lavoura_peramenente=a_lavperm,
  area_lavoura_temporaria=a_lavtemp,
  area_pastagem_natural=a_pastnat,
  area_pastagem_plantada=a_pastplan,
  area_pastagem=a_past,
  area_mata_natural=a_matanat,
  area_mata_plantada=a_mataplan,
  area_sistema_agroflorestal=a_sisagro,
  area_mata=a_mata,
  area_nao_utilizada=a_naoutiliz,
  quantidade_estabelecimentos=n_estcal,
  producao_cafe=p_cafe,
  area_cafe=a_cafe,
  quantidade_estabelecimentos_cafe=n_cafe,
  valor_total_producao_cafe=v_cafe,
  quantidade_bovinos_total=n_bovtotal,
  quantidade_bezerros=n_bovbezerro,
  quantidade_bovinos_garrote=n_bovnovgar,
  quantidade_bovinos_vaca=n_bovvaca,
  quantidade_bovinos_trab=n_bovtrab,
  quantidade_bovinos_touro=n_bovtouro,
  quantidade_estabelecimentos_energia_eletrica=n_estenerg,
  despesa_total=d_total,
  despesa_adubos=d_adubos,
  despesa_sementes=d_sementes,
  despesa_arrendamentos=d_arrend,
  despesa_salarios=d_salarios,
  despesa_defensivos=d_defensiv,
  despesa_cotas=d_quota,
  areas_irrigacao=a_irrig,
  producao_leite=p_leite,
  numero_estabelecimentos_total=estabelecimentos_total,
  numero_estabelecimentos_proprietario=estabelecimentos_proprietario,
  numero_estabelecimentos_arrendatario=estabelecimentos_arrendatario,
  numero_estabelecimentos_parceiros=estabelecimentos_parceiros,
  numero_estabelecimentos_ocupantes=estabelecimentos_ocupantes,
  numero_estabelecimentos_outros=estabelecimentos_outros,
  numero_estabelecimentos_nenhuma=estabelecimentos_nenhuma,
  numero_estabelecimentos_cooperativas=estabelecimentos_cooperativas,
  numero_estabelecimentos_cooperativas_credito=estabelecimentos_cooperativas_credito,
  numero_estabelecimentos_cooperativa_energia_eletrica=estabelecimentos_cooperativa_energia_eletrica,
  numero_estabelecimentos_cooperativa_energia_outras=estabelecimentos_cooperativa_energia_outras,
  numero_estabelecimentos_arroz=estabelecimentos_arroz,
  numero_estabelecimentos_feijao=estabelecimentos_feijao,
  numero_estabelecimentos_milho=estabelecimentos_milho,
  numero_estabelecimentos_mandioca=estabelecimentos_mandioca,
  numero_estabelecimentos_soja=estabelecimentos_soja,
  numero_estabelecimentos_algodao=estabelecimentos_algodao,
  numero_estabelecimentos_cana=estabelecimentos_cana,
  numero_estabelecimentos_trigo=estabelecimentos_trigo,
  alor_total_arroz=v_arroz,
  valor_total_feijao=v_feijao,
  valor_total_milho=v_milho,
  valor_total_mandioca=v_mandioca,
  valor_total_soja=v_soja,
  valor_total_algodao=v_algodao,
  valor_total_cana=v_cana,
  valor_total_trigo=v_trigo,
  valor_total=v_total,
  valor_total_terras=v_terras,
  valor_total_cultura_permanente=v_cultperm,
  valor_total_matas_plantadas=v_matasplant,
  valor_total_predios_benfeitorias=v_prediosbenfeit,
  valor_total_animais=v_ani,
  valor_total_animais_transporte=v_transpanimaq,
  valor_total_maquinas_transporte=v_transpmaqtrat,
  proporcao_despesa_fertilizante=exp_share_fertilizer,
  proporcao_despesa_defensivos=exp_share_defensives,
  # alterar aqui proporcao_despesa_sementes=exp_share_seeds,
  proporcao_despesa_salarios=exp_share_wages
  ) -> x

x |>
  dplyr::rename(
    quantidade_bovinos_trabalho = quantidade_bovinos_trab,
    proporcao_despesa_fertilizante = porcentagem_despesa_fertilizante,
    proporcao_despesa_defensivos = porcentagem_despesa_defensivos,
    proporcao_despesa_sementes = porcentamgem_despesa_sementes,
    proporcao_despesa_salarios = porcentagem_despesa_salarios
  )


#Atribuindo a UF para comparar com os dados oficiais do Censo
dplyr::mutate(x,
              sigla_uf = 
                dplyr::case_when(
                  id_municipio<=1199999~'RO',
                  id_municipio>=1200000 & id_municipio<=1299999 ~'AC',
                  id_municipio>=1300000 & id_municipio<=1399999 ~'AM',
                  id_municipio>=1400000 & id_municipio<=1499999 ~'RR',
                  id_municipio>=1500000 & id_municipio<=1599999 ~'PA',
                  id_municipio>=1600000 & id_municipio<=1699999 ~'AP',
                  id_municipio>=1700000 & id_municipio<=1799999 ~'TO',
                  id_municipio>=2100000 & id_municipio<=2199999 ~'MA',
                  id_municipio>=2200000 & id_municipio<=2299999 ~'PI',
                  id_municipio>=2300000 & id_municipio<=2399999 ~'CE',
                  id_municipio>=2400000 & id_municipio<=2499999 ~'RN',
                  id_municipio>=2500000 & id_municipio<=2599999 ~'PB',
                  id_municipio>=2600000 & id_municipio<=2699999 ~'PE',
                  id_municipio>=2700000 & id_municipio<=2799999 ~'AL',
                  id_municipio>=2800000 & id_municipio<=2899999 ~'SE',
                  id_municipio>=2900000 & id_municipio<=2999999 ~'BA',
                  id_municipio>=3100000 & id_municipio<=3199999 ~'MG',
                  id_municipio>=3200000 & id_municipio<=3299999 ~'ES',
                  id_municipio>=3300000 & id_municipio<=3399999 ~'RJ',
                  id_municipio>=3500000 & id_municipio<=3599999 ~'SP',
                  id_municipio>=4100000 & id_municipio<=4199999 ~'PR',
                  id_municipio>=4200000 & id_municipio<=4299999 ~'SC',
                  id_municipio>=4300000 & id_municipio<=4399999 ~'RS',
                  id_municipio>=5000000 & id_municipio<=5099999 ~'MS',
                  id_municipio>=5100000 & id_municipio<=5199999 ~'MT',
                  id_municipio>=5200000 & id_municipio<=5299999 ~'GO',
                  id_municipio>=5300000 & id_municipio<=5399999 ~'DF'
                  )) -> x

#alterando ordem das variáveis tal como na table_id
x|>
  dplyr::select(ano, sigla_uf, id_municipio, everything()
  ) ->x

write.csv(x,'censo_agropecuario.csv',  na = " ", 
          row.names = F, fileEncoding = "UTF-8")
#Exemplos de Análises realizadas para
#para ver se as variáveis tão batendo
#ano de 1996 no estado do Acre
dplyr::filter(x,
              ano==1996) -> geral_2017

sum(ac1996$n_BovTotal)
  
# Geral de Roraíma 
dplyr::filter(x,
              uf=='RO') ->ro_geral

#Ano de 2006 de Roraima porque têm muito dado que não coletado/disponivel
dplyr::filter(ro_geral,
              ano==2006) -> ro2006

# Exmemplo de como estou realizando a análise das variáveis
sum(ro2006$v_TranspMaqTrat) #pra 2006

dplyr::group_by(ano_1996,
                uf)|>
  dplyr::summarise((a_Total))




              
