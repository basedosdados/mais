import basedosdados as bd

tb = bd.Table(dataset_id='br_ans_beneficiario', table_id='informacao_consolidada')
tb.create(
    path='/home/guiss/projects/open_source/mais/bases/br_ans_beneficiario/informacao_consolidada/output',
    force_dataset=False,
    if_table_exists='replace',
    if_storage_data_exists='pass',
    if_table_config_exists='pass',
    source_format='parquet'
)
