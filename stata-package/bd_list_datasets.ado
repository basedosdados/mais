
cap program drop bd_list_datasets
program define bd_list_datasets, rclass
    
    version 16.0
    
    python: import basedosdados as bd
    python: bd.list_datasets()
    
end
