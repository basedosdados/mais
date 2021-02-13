
//----------------------------------------------------------------------------//
// build: filiacao partidaria
//----------------------------------------------------------------------------//

local estados	ac al am ap ba ce df es go ma mg ms mt pa ///
				pb pe pi pr rj rn ro rr rs sc se sp to

local partidos	cidadania dc dem mdb novo patriota pcb pcdob pco pdt phs pl pmb ///
				pmn pode pp ppl pros prp prtb psb psc psd psdb psl psol pstu pt ///
				ptb ptc pv rede republicanos solidariedade up

foreach estado in `estados' {
	
	foreach partido in `partidos' {
		
		local filename "input/filiacao_partidaria/filiados_`partido'_`estado'/filiados_`partido'_`estado'.csv"
		capture confirm file `filename'
		
		if _rc == 0 {
		
			import delimited `filename', clear varn(nonames) delim(";") stringc(_all)
			
			drop in 1
			
			keep v3 v4 v5 v7 v8 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19
			
			ren v3	titulo_eleitoral
			ren v4	nome_filiado
			ren v5	sigla_partido
			ren v7	sigla_uf
			ren v8	id_municipio_tse
			ren v10	zona
			ren v11	secao
			ren v12	data_filiacao
			ren v13	situacao_registro
			ren v14	tipo_registro
			ren v15	data_processamento
			ren v16	data_desfiliacao
			ren v17	data_cancelamento
			ren v18	data_regularizacao
			ren v19	motivo_cancelamento
			
			destring id_municipio_tse zona secao, replace force
			
			foreach k of varlist data_* {
				
				replace `k' = substr(`k', 7, 4) + "-" + substr(`k', 4, 2) + "-" + substr(`k', 1, 2) if `k' != ""
				
			}
			*
			
			foreach k in situacao_registro tipo_registro motivo_cancelamento {
				cap clean_string `k'
			}
			foreach k in nome_filiado {
				cap replace `k' = ustrtitle(`k')
			}
			*
			
			tempfile filiacao_`estado'_`partido'
			save `filiacao_`estado'_`partido''
			
		}
	}
}
*

use `filiacao_ac_cidadania', clear
foreach estado in `estados' {
	foreach partido in `partidos' {
		if !("`estado'" == "ac" & "`partido'" == "cidadania") {
			cap append using `filiacao_`estado'_`partido''
		}
	}
}
*

compress

save "output/filiacao_partidaria.dta", replace

		
		
