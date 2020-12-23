
#cd "/Users/ricardodahis/Downloads/dados_TSE/input/filiacao_partidaria"

cd "/Users/ricardodahis/Downloads/dados_TSE/input/votacao_secao"
for i in *.zip; do
    unp -u "$i"
done
