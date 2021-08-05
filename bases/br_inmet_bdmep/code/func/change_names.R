new_names <- function(base, oldname, newname){
x = grep(oldname, names(base)) 

  if(length(x) > 1) {
    return(names(base))
  }

  else{
    names(base)[x] <- newname
    return(names(base))
  }
}
 
change_names <- function(base){
names(base) = tolower(names(base))
names(base) = stringi::stri_trans_general(str = names(base), 
                            id = "Latin-ASCII")
names(base) = new_names(base,"data","data")
names(base) = new_names(base,"^hora","hora")
names(base) = new_names(base,"precipitacao.*total","precipitacao_total")
names(base) = new_names(base,"pressao.*nivel","pressao_atm_hora")
names(base) = new_names(base,"pressao.*max","pressao_atm_max")
names(base) = new_names(base,"pressao.*min","pressao_atm_min")
names(base) = new_names(base,"radiacao","radiacao_global")
names(base) = new_names(base,"temperatura.*bulbo.*horaria","temperatura_bulbo_hora")
names(base) = new_names(base,"temperatura maxima","temperatura_max")
names(base) = new_names(base,"temperatura minima","temperatura_min")
names(base) = new_names(base,"temperatura do ponto de orvalho","temperatura_orvalho_hora")
names(base) = new_names(base,"temperatura orvalho min","temperatura_orvalho_min")
names(base) = new_names(base,"temperatura orvalho max","temperatura_orvalho_max")
names(base) = new_names(base,"umidade relativa.*horaria","umidade_rel_hora")
names(base) = new_names(base,"umidade rel. max","umidade_rel_max")
names(base) = new_names(base,"umidade rel. min","umidade_rel_min")
names(base) = new_names(base,"vento.*direcao","vento_direcao")
names(base) = new_names(base,"vento.*rajada.* maxima","vento_rajada_max")
names(base) = new_names(base,"vento.*velocidade","vento_velocidade")

return(names(base))
}
