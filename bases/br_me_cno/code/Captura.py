import pandas as pd
import requests
import bs4
from tqdm import tqdm

def baixar_arquivo(url, endereco):
    resposta = requests.get(url, stream=True)
    total_size_in_bytes= int(resposta.headers.get('content-length', 0))
    block_size = 1024 #1 Kibibyte
    progress_bar = tqdm(total=total_size_in_bytes, unit='iB', unit_scale=True)
    if resposta.status_code == requests.codes.OK:
        with open(endereco, 'wb') as novo_arquivo:
            for parte in resposta.iter_content(chunk_size=2000):
                progress_bar.update(len(parte))
                novo_arquivo.write(parte)
        print("Download finalizado. Arquivo salvo em: {}".format(endereco))
    else:
        resposta.raise_for_status()
    progress_bar.close()


url = "http://200.152.38.155/CNO/"
page = requests.get(url)
soup = bs4.BeautifulSoup(page.content, "html.parser")
table = soup.find('table')
tr = table.find_all('tr')[3:7]

link= []
path = []
for i in range(len(tr)):
    href = tr[i].find('a').get('href')
    p = url + href
    link.append(p)
    path.append('./input/'+ href)
    
for i in range(len(link)):
    try:
        baixar_arquivo(link[i],path[i])
    except:
        print("Erro no download")
        