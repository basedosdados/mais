
//----------------------------------------------------------------------------//
// preface
//----------------------------------------------------------------------------//

clear all
set more off
clear programs

local PATH "path/to/basedosdados/mais/stata-package"

qui do "setup.do" "`PATH'"

//----------------------------------------------------------------------------//
// examples to test BD Stata package
//----------------------------------------------------------------------------//

bd_list_datasets
bd_list_dataset_tables, dataset_id("br_bd_diretorios_brasil")
bd_get_table_columns, dataset_id("br_bd_diretorios_brasil") table_id("cnae_2")
bd_get_table_description, dataset_id("br_bd_diretorios_brasil") table_id("cnae_2")

bd_read_table, ///
	path("~/Downloads/test.csv") ///
	dataset_id("br_bd_diretorios_brasil") ///
	table_id("municipio") ///
	billing_project_id("projeto-teste-302617")

bd_read_sql, ///
	path("~/Downloads/test.csv") ///
	query("SELECT * FROM basedosdados.br_bd_diretorios_brasil.municipio") ///
	billing_project_id("projeto-teste-302617")

bd_download, ///
	path("~/Downloads/test.csv") ///
	dataset_id("br_bd_diretorios_brasil") ///
	table_id("municipio") ///
	billing_project_id("projeto-teste-302617")
