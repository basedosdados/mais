
cap program drop bd_get_table_columns
program define bd_get_table_columns, rclass
    
    version 16.0
    syntax, dataset_id(string) table_id(string)
    
    python: import basedosdados as bd
    python: bd.get_table_columns(dataset_id = "`dataset_id'", ///
                                 table_id   = "`table_id'")
    
end
