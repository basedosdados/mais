
cap program drop basedosdados_download
program basedosdados_download
	
	local dataset_id = "`1'"
	local table_id = "`2'"
	local path  = "`3'"
	
	!basedosdados download ///
		--dateset_id `dataset_id' ///
		--table_id `table_id' ///
		`path'
	
end

// use case

basedosdados_download "br_basedosdados_diretorios_brasil" "municipio" "~/Downloads"

