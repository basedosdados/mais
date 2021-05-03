
//----------------------------------------------------------------------------//
// prefacio
//----------------------------------------------------------------------------//

clear all
clear programs
set more off
cap log close

cd "atalho/para/Comercio Exterior (Comex Stat)"

//----------------------------------------------------------------------------//
// build
//----------------------------------------------------------------------------//

foreach B in EXP IMP {
	
	if "`B'" == "EXP" local b exportacao
	if "`B'" == "IMP" local b importacao
	
	//------------------------//
	// NCM
	//------------------------//
	
	import delimited "input/`B'_COMPLETA.csv", clear delim(";") varn(nonames) rowr(2:)
	
	ren v1	ano
	ren v2	mes
	ren v3	id_ncm
	ren v4	id_unidade
	ren v5	id_pais
	ren v6	sigla_uf_ncm
	ren v7	id_via
	ren v8	id_urf
	ren v9	quantidade_estatistica
	ren v10	peso_liquido_kg
	ren v11	valor_fob_dolar
	
	tempfile ncm_`b'
	save `ncm_`b''
	
	//------------------------//
	// particiona
	//------------------------//
	
	! mkdir "output/ncm_`b'"
	
	levelsof ano, local(anos)
	
	foreach ano in `anos' {
		
		! mkdir "output/ncm_`b'/ano=`ano'"
		
		use `ncm_`b'', clear
		levelsof mes if ano == `ano', local(meses)
		foreach mes in `meses' {
			
			! mkdir "output/ncm_`b'/ano=`ano'/mes=`mes'"
			
			use `ncm_`b'', clear
			keep if ano == `ano' & mes == `mes'
			drop ano mes
			export delimited "output/ncm_`b'/ano=`ano'/mes=`mes'/ncm_`b'.csv", replace datafmt
		
		}
	}
	*
	
	//------------------------//
	// municipio
	//------------------------//
	
	import delimited "input/`B'_COMPLETA_MUN.csv", clear delim(";") varn(nonames) rowr(2:)
	
	drop in 1
	
	ren v1 ano
	ren v2 mes
	ren v3 id_sh4
	ren v4 id_pais
	ren v5 sigla_uf
	ren v6 id_municipio
	ren v7 peso_liquido_kg
	ren v8 valor_fob_dolar
	
	tempfile municipio_`b'
	save `municipio_`b''
	
	//------------------------//
	// particiona
	//------------------------//
	
	! mkdir "output/municipio_`b'"
	
	levelsof ano, local(anos)
	
	foreach ano in `anos' {
		
		! mkdir "output/municipio_`b'/ano=`ano'"
		
		use `municipio_`b'', clear
		levelsof mes if ano == `ano', local(meses)
		foreach mes in `meses' {
			
			! mkdir "output/municipio_`b'/ano=`ano'/mes=`mes'"
			
			use `municipio_`b'', clear
			keep if ano == `ano' & mes == `mes'
			drop ano mes
			export delimited "output/municipio_`b'/ano=`ano'/mes=`mes'/municipio_`b'.csv", replace datafmt
		
		}
	}
}
*
