
//----------------------------------------------------------------------------//
// build: agregacao
//----------------------------------------------------------------------------//

foreach ano of numlist 1996(1)2019 {
	
	foreach sigla_uf in AC AL AP AM BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ RN RS RO RR SC SP SE TO {
		
		import delimited "output/microdados/ano=`ano'/sigla_uf=`sigla_uf'/microdados.csv", clear varn(1)
		
		// resolve problema Stata de precisao de floats (ex. 0.519999999)
		gen aux_idade = string(idade, "%4.2f")
		destring aux_idade, replace
		order aux_idade, a(idade)
		drop idade
		ren aux_idade idade
		
		destring id_municipio_resid, replace
		
		gen numero_obitos = 1
		
		//-----------------------------//
		// municipio-causa-idade-genero-raca
		//-----------------------------//
		
		! mkdir "output/municipio_causa_idade_genero_raca"
		! mkdir "output/municipio_causa_idade_genero_raca/ano=`ano'"
		! mkdir "output/municipio_causa_idade_genero_raca/ano=`ano'/sigla_uf=`sigla_uf'"
		
		preserve
			
			collapse (sum) numero_obitos, by(id_municipio_resid causa_basica idade genero raca_cor)
			
			drop if id_municipio_resid == .
			
			ren id_municipio_resid id_municipio
			
			order id_municipio causa_basica idade genero raca_cor
			
			export delimited "output/municipio_causa_idade_genero_raca/ano=`ano'/sigla_uf=`sigla_uf'/municipio_causa_idade_genero_raca.csv", replace datafmt
			
		restore
		
		//-----------------------------//
		// municipio-causa-idade
		//-----------------------------//
		
		! mkdir "output/municipio_causa_idade"
		! mkdir "output/municipio_causa_idade/ano=`ano'"
		! mkdir "output/municipio_causa_idade/ano=`ano'/sigla_uf=`sigla_uf'"
		
		preserve
			
			collapse (sum) numero_obitos, by(id_municipio_resid causa_basica idade)
			
			drop if id_municipio_resid == .
			
			ren id_municipio_resid id_municipio
			
			order id_municipio causa_basica idade
			
			export delimited "output/municipio_causa_idade/ano=`ano'/sigla_uf=`sigla_uf'/municipio_causa_idade.csv", replace datafmt
			
		restore
		
		//-----------------------------//
		// municipio-causa
		//-----------------------------//
		
		! mkdir "output/municipio_causa"
		! mkdir "output/municipio_causa/ano=`ano'"
		! mkdir "output/municipio_causa/ano=`ano'/sigla_uf=`sigla_uf'"
		
		preserve
			
			collapse (sum) numero_obitos, by(id_municipio_resid causa_basica)
			
			drop if id_municipio_resid == .
			ren id_municipio_resid id_municipio
			
			order id_municipio causa_basica
			
			export delimited "output/municipio_causa/ano=`ano'/sigla_uf=`sigla_uf'/municipio_causa.csv", replace
			
		restore
		
		//-----------------------------//
		// municipio
		//-----------------------------//
		
		! mkdir "output/municipio"
		! mkdir "output/municipio/ano=`ano'"
		! mkdir "output/municipio/ano=`ano'/sigla_uf=`sigla_uf'"
		
		preserve
			
			collapse (sum) numero_obitos, by(id_municipio_resid)
			
			drop if id_municipio_resid == .
			ren id_municipio_resid id_municipio
			
			order id_municipio
			
			export delimited "output/municipio/ano=`ano'/sigla_uf=`sigla_uf'/municipio.csv", replace datafmt
			
		restore
		
	}
}
*
