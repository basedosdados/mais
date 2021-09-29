
cap program drop bd_download
program define bd_download, rclass
    version 16.0
    syntax, path(string) dataset_id(string) table_id(string) billing_project_id(string)

    if _rc!=111 | _rc!=7102 {
	python: import basedosdados as bd 
    python: bd.download(savepath           = "`path'", ///
                        dataset_id         = "`dataset_id'", ///
                        table_id           = "`table_id'", ///
                        billing_project_id = "`billing_project_id'")
	}
	if _rc==111 | _rc==7102{
	db instrucoes
	}
						
	
    
end
