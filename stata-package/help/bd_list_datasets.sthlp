{smcl}
{* *! version 16.0  23set2021}{...}
{vieweralsosee "" "--"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[D] bd_list_datasets} {hline 2}}bd_list_datasets datasets{p_end}
{p2col:}({mansection D bd_list_datasets:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmdab:bd_list_d:atasets} {cmd:using} {it:{help filename}}
[{it:{help filename}} {cmd:...}]
[{cmd:,} {it:options}]

{pstd} to use {cmd:bd_list_datasets} you must have Stata version 16+ and Python {it:`basedosdados`} package installed and configured. If not, run {it:`pip install basedosdados`} and configure following the instructions.

{synoptset 15}{...}
{synopthdr}
{synoptline}
{pstd} {it:no options}
{synoptline}
{p2colreset}{...}

{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > ? > ?}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bd_list_datasets} download table or query result from basedosdados {it:BigQuery}

{pstd}
Stata also has other commands for manipulating basedosdados's data; see
{manhelp bd_get_table_columns D}, {manhelp bd_get_table_description D}, {manhelp bd_list_datasets_table D}, 
{manhelp bd_read_sql D}, {manhelp bd_read_table D} or {manhelp bd_download D}.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup

{pmore}{cmd:. bd_list_datasets}{p_end}
    {hline}

{title: Autor}
{pstd} Autor. Year. Title. Local: https://basedosdados.org/
