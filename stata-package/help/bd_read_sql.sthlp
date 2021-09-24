{smcl}
{* *! version 16.0  23set2021}{...}
{vieweralsosee "" "--"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[D] bd_read_sql} {hline 2}}bd_read_sql datasets{p_end}
{p2col:}({mansection D bd_read_sql:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmdab:bd_read_s:ql} {cmd:using} {it:{help filename}}
[{it:{help filename}} {cmd:...}]
[{cmd:,} {it:options}]

{pstd} to use {cmd:bd_read_sql} you must have Stata version 16+ and Python {it:`basedosdados`} package installed and configured. If not, run {it:`pip install basedosdados`} and configure following the instructions.

{synoptset 15}{...}
{synopthdr}
{synoptline}
{synopt :{opth pa:th(newfile)}} string containing the path for the file to be created. The desired folders must
already exist and the file should normally end with the corresponding extension {p_end}
{synopt :{opth que:ry(SQL)}} valid SQL Standard Query to basedosdados. If query is available, dataset_id and table_id are not required.{p_end}
{synopt :{opth billing_p:roject_id(projectid)}} a string containing your billing project id. Find your Project ID here https://console.cloud.google.com/projectselector2/home/dashboard{p_end}
{synoptline}
{p2colreset}{...}

{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > ? > ?}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bd_read_sql} download table or query result from basedosdados {it:BigQuery}

{pstd}
Stata also has other commands for manipulating basedosdados's data; see
{manhelp bd_get_table_description D}, {manhelp bd_list_dataset_tables D}, {manhelp bd_list_datasets D}, 
{manhelp bd_read_table D} or {manhelp bd_get_table_columns D}.


{marker options}{...}
{title:Options}

{phang}
{opth path(newfile)} descrição mais detalhada{p_end}

{phang}
{opth query(SQL)} descrição mais detalhada

{phang}
{opth billing_project_id(project)} descrição mais detalhada


{marker examples}{...}
{title:Examples}

    {hline}
    Setup

{pmore}{cmd:. bd_read_sql, path("~/Downloads/test.csv") query("SELECT * FROM basedosdados.br_bd_diretorios_brasil.municipio") billing_project_id("projeto-teste-302617")}{p_end}
    {hline}

{title: Autor}
{pstd} Autor. Year. Title. Local: https://basedosdados.org/