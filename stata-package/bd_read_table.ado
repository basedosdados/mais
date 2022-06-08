
cap program drop bd_read_table
program define bd_read_table, rclass
    
    version 16.0
    syntax, path(string) dataset_id(string) table_id(string) billing_project_id(string)
    
    python: import basedosdados as bd
    python: bd.download(savepath           = "`path'", ///
                        dataset_id         = "`dataset_id'", ///
                        table_id           = "`table_id'", ///
                        billing_project_id = "`billing_project_id'")
    
    import delimited "`path'", clear varn(1) encoding("utf-8")
    
end
