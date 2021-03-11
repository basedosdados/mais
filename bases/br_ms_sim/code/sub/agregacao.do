
//----------------------------------------------------------------------------//
// build: agregacao
//----------------------------------------------------------------------------//

foreach ano of numlist 1996(1)2019 {
	
	foreach sigla_uf in AC AL AP AM BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ RN RS RO RR SC SP SE TO {
		
		import delimited "output/microdados/ano=`ano'/sigla_uf=`sigla_uf'/microdados.csv", clear varn(1) //stringc(_all)
		
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
			
			drop if id_municipio_resid == . //| genero == "" | idade == . | raca_cor == ""
			
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
			
			drop if id_municipio_resid == . //| genero == "" | idade == . | raca_cor == ""
			
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


/*
gen causa = substr(causa_basica, 1, 3)

local cat_overdose	F10 F11 F12 F14 F16 F19 ///
					T40 T41 T42 T43 T44 T45 T46 T47 T48 T49 T50 ///
					X42 X43 X44 X45 X46 X47 X48 X49 ///
					X60 X61 X62 X63 X64 X65 X66 X67 X68 X69 ///
					Y12 Y13 Y14 Y15 Y16 Y49 Y50 Y51 ///
					Z64 Z65

local cat_violento	W33 W34 ///
					X85 X86 X87 X88 X89 X90 X91 X92 X93 X94 X95 X96 X97 X98 X99 ///
					Y00 Y01 Y02 Y03 Y04 Y05 Y06 Y07 Y08 Y09 Y10 Y11 Y12 Y13 Y14 Y15 Y16 Y17 Y18 Y19 Y20 Y21 Y22 Y23 Y24 Y25 Y26 Y27 Y28 Y29 Y30 Y31 Y32 Y33 Y34 Y35 Y87 Y89

foreach g in violento overdose {
	
	gen obito_`k' = 0
	foreach j in `cat_`k'' {
		replace obito_`k' = 1 if causa == "`j'"
	}
}
*

