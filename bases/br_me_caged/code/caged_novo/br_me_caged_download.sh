#!/bin/bash

# Para rodar esse script o usuário deve rodar bash download.sh group, onde group é cagedmov | cagedfor | cagedexc.
# Ver explicação no próximo comentário:

# Os microdados resultantes da nova consolidação estão disponibilizados de acordo com o
# mês da divulgação, a partir de janeiro de 2020, contendo três arquivos para cada
# competência. Seguindo um padrão de nomes coerente, os arquivos CAGEDMOVAAAAMM
# trazem as movimentações declaradas dentro do prazo com competência de declaração
# igual a AAAAMM. Os arquivos CAGEDFORAAAAMM trazem as movimentações declaradas
# fora do prazo com competência de declaração igual a AAAAMM. Os arquivos
# CAGEDEXCAAAAMM trazem as movimentações excluídas com competência de declaração
# da exclusão igual a AAAAMM

lower_group=$1
upper_group=${lower_group^^}

mkdir -p /tmp/novo_caged/$lower_group/input
ufs=('RO' 'AC' 'AM' 'RR' 'PA' 'AP' 'TO' 'MA' 'PI' 'CE' 'RN' 'PB' 'PE' 'AL' 'SE' 'BA' 'MG' 'ES' 'RJ' 'SP' 'PR' 'SC' 'RS' 'MS' 'MT' 'GO' 'DF')
anos=(2020 2021 2022)
meses=($(seq 1 1 12))

for uf in "${ufs[@]}"
do
    for ano in "${anos[@]}"
    do
        for mes in "${meses[@]}"
        do
            mkdir -p /tmp/novo_caged/$lower_group/ano=$ano/mes=$mes/sigla_uf=$uf/
        done
    done
done

cd /tmp/novo_caged/$lower_group/input
ftp_path="ftp://anonymous:anonymous@ftp.mtps.gov.br/pdet/microdados/NOVO CAGED/"

pad_meses=($(echo {01..12}))
folders=($(seq 202001 1 202012))

for ano in "${anos[@]}"
do
    for mes in "${pad_meses[@]}"
    do
        wget "$ftp_path$ano/$ano$mes/$upper_group$ano$mes.7z"
        7z x -y $upper_group$ano$mes.7z
        rm *7z
    done
done
