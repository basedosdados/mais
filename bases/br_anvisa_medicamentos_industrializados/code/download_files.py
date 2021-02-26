
#---------------------------------------------------------------#
# preface
#---------------------------------------------------------------#

import os
import requests
from time import time
from multiprocessing.pool import ThreadPool

ROOT = "path/dados_EDA_industrializados"

if not os.path.exists(ROOT):
    os.mkdir(ROOT)
    os.mkdir("input")
os.chdir(ROOT)

#---------------------------------------------------------------#
# main: download data
#---------------------------------------------------------------#

# source: https://likegeeks.com/downloading-files-using-python/#Download_multiple_files_Parallelbulk_download

def url_response(url):

    path, url = url
    r = requests.get(url, stream = True)

    with open(path, 'wb') as f:
        for ch in r:
            f.write(ch)

urls = []
years = range(2014,2021)
months = ['01','02','03','04','05','06','07','08','09','10','11','12']

for year in years:
    for month in months:
        path = os.path.join("input", "EDA_Industrializados_"+str(year)+month+".csv")
        url = "https://stgdwsngpcpd01.blob.core.windows.net/dados-abertos/EDA_Industrializados_"+str(year)+month+".csv"
        urls.append((path,url))

number_threads = 10
ThreadPool(number_threads).imap_unordered(url_response, urls) # runs in background
