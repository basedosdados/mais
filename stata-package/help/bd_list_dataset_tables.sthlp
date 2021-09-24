{smcl}
{* *! version 16.1  23set2021}{...}
{vieweralsosee "" "--"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[D] bd_list_dataset_tables} {hline 2}}bd_list_dataset_tables datasets{p_end}
{p2col:}({mansection D bd_list_dataset_tables:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmdab:bd_list_dataset_t:ables} {cmd:using} {it:{help filename}}
[{it:{help filename}} {cmd:...}]
[{cmd:,} {it:options}]

{pstd} to use {cmd:bd_list_dataset_tables} you must have Stata version 16+ and Python {it:`basedosdados`} package installed and configured. If not, run {it:`pip install basedosdados`} and configure following the instructions.

{synoptset 15}{...}
{synopthdr}
{synoptline}
{synopt :{opth datas:et_id(datasetid)}} dataset id available in basedosdados. It should always come with table_id.{p_end}
{synoptline}
{p2colreset}{...}

{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > ? > ?}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bd_list_dataset_tables} download table or query result from basedosdados {it:BigQuery}

{pstd}
Stata also has other commands for manipulating basedosdados's data; see
{manhelp bd_get_table_columns D}, {manhelp bd_get_table_description D}, {manhelp bd_list_datasets D}, 
{manhelp bd_read_sql D}, {manhelp bd_read_table D} or {manhelp bd_download D}.


{marker options}{...}
{title:Options}

{phang}
{opth dataset_id(dataset)} descrição mais detalhada

{marker examples}{...}
{title:Examples}

    {hline}
    Setup

{pmore}{cmd:. bd_list_dataset_tables, dataset_id("br_bd_diretorios_brasil")}{p_end}
    {hline}

{title: Autor}
{pstd} Autor. Year. Title. Local: https://basedosdados.org/
