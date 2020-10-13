
cd "/path/to/dados_TSE/input/votacao_secao"
for i in *.zip; do
    unp -u "$i"
done
