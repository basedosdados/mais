
cap program drop bd_read_sql
program define bd_read_sql, rclass
    
    version 16.0
    syntax, path(string) query(string) billing_project_id(string)
    
    python: import basedosdados as bd
    python: bd.download(savepath           = "`path'", ///
                        query              = "`query'", ///
                        billing_project_id = "`billing_project_id'")
    
    import delimited "`path'", clear varn(1) encoding("utf-8")
    
end
