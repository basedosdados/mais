
import requests
from os import path, rename
import zipfile

def download_file(PATH, url): 
    
    local_filename = url.split('/')[-1]
    filename = PATH + '/' + local_filename

    if not path.exists(filename):
        r = requests.get(url)
        output = open(filename, 'wb')
        output.write(r.content)
        output.close()

states = ['ac', 'al', 'am', 'ap', 'ba', 'ce', 'df', 'es', 'go',
          'ma', 'mg', 'ms', 'mt', 'pa', 'pb', 'pe', 'pi', 'pr',
          'rj', 'rn', 'ro', 'rr', 'rs', 'sc', 'se', 'sp', 'to']

parties = ['cidadania', 'dc', 'dem', 'mdb', 'novo', 'patriota',
           'pcb', 'pcdob', 'pco', 'pdt', 'phs', 'pl', 'pmb', 
           'pmn', 'pode', 'pp', 'ppl', 'pros', 'prp', 'prtb', 
           'psb', 'psc', 'psd', 'psdb', 'psl', 'psol', 'pstu', 
           'pt', 'ptb', 'ptc', 'pv', 'rede', 'republicanos', 
           'solidariedade', 'up']

for state in states:
    
    # filiacao partidaria
    for party in parties:
        
        PATH = '/path/to/dados_TSE/input/filiacao_partidaria'
        url = 'http://agencia.tse.jus.br/estatistica/sead/eleitorado/filiados/uf/filiados_{}_{}.zip'.format(party,state)
        download_file(PATH, url)

# resultados por secao eleitoral
states = ['AC', 'AL', 'AM', 'AP', 'BA', 'BR', 'CE', 'DF', 'ES', 'GO',
          'MA', 'MG', 'MS', 'MT', 'PA', 'PB', 'PE', 'PI', 'PR',
          'RJ', 'RN', 'RO', 'RR', 'RS', 'SC', 'SE', 'SP', 'TO']

for state in states:
    for year in range(1994, 2020, 2):
        
        PATH = '/path/to/dados_TSE/input/votacao_secao'
        
        if year == 2012:
            url = 'http://agencia.tse.jus.br/estatistica/sead/eleicoes/eleicoes2012/votosecao/vsec_1t_{}.zip'.format(state)
            download_file(PATH, url)
            url = 'http://agencia.tse.jus.br/estatistica/sead/eleicoes/eleicoes2012/votosecao/vsec_2t_{}_30102012194527.zip'.format(state)
            download_file(PATH, url)
            
            rename(path.join(PATH,'vsec_1t_{}.zip'.format(state)), path.join(PATH,'votacao_secao_2012_{}_1t.zip'.format(state)))
            rename(path.join(PATH,'vsec_2t_{}_30102012194527.zip'.format(state)), path.join(PATH,'votacao_secao_2012_{}_2t.zip'.format(state)))
        else:
            url  = 'http://agencia.tse.jus.br/estatistica/sead/odsele/votacao_secao/votacao_secao_{}_{}.zip'.format(year,state)
            download_file(PATH, url)
