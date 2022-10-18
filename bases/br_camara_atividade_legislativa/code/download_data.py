import requests

# Format can be '[csv', 'xlsx', 'ods', 'json', 'xml'], but only 'csv' is 
# supported by later scripts
def download_data(start_year=1991, end_year=2022, format="csv"):

    for year in range(start_year, end_year+1):
        
        url = f"http://dadosabertos.camara.leg.br/arquivos/eventos/{format}/eventos-{year}.{format}"
        response = requests.get(url)
        response.raise_for_status()

        # TODO fix table names
        with open(f"../input/eventos_{year}.{format}", "w") as f:
            content_as_string = response.content.decode()
            f.write(content_as_string)

        print(f"Successfully downloaded for year {year}")

if __name__ == "__main__":
    download_data()
