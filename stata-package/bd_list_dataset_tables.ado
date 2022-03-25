
cap program drop bd_list_dataset_tables
program define bd_list_dataset_tables, rclass
    
    version 16.0
    syntax, dataset_id(string)
    
    python: import basedosdados as bd
    python: bd.list_dataset_tables(dataset_id = "`dataset_id'")
    
end
