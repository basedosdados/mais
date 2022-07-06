# -*- coding: utf-8 -*-
"""
Created on Wed Feb 10 15:48:56 2021

@author: Eduardo
"""
# pylint: disable=invalid-name,anomalous-backslash-in-string,redefined-outer-name,too-many-statements, too-many-locals, too-many-arguments, too-many-branches
import re

from bs4 import BeautifulSoup
import requests
import pandas as pd


def process_basico(df, content):
    """
    Basic process of the dataframe
    """
    new_content = {
        "estadio": content.find_all("td", attrs={"class": "hauptlink"})[0].get_text(),
        "data": re.search(
            re.compile("\d+/\d+/\d+"),
            content.find("a", text=re.compile("\d+/\d+/\d")).get_text().strip(),
        ).group(0),
        "horario": content.find_all("p", attrs={"class": "sb-datum hide-for-small"})[0]
        .get_text()
        .split()[6],
        "rodada": re.search(
            re.compile("\d+. Matchday"),
            content.find("a", text=re.compile("\d.")).get_text().strip(),
        )
        .group(0)
        .split(".", 1)[0],
        "publico": None,
        "publico_max": None,
        "arbitro": None,
        "hthg": None,
        "htag": None,
        "hs": None,
        "as": None,
        "hsofft": None,
        "asofft": None,
        "hdef": None,
        "adef": None,
        "hf": None,
        "af": None,
        "hc": None,
        "ac": None,
        "himp": None,
        "aimp": None,
        "hfk": None,
        "afk": None,
    }

    df = df.append(new_content, ignore_index=True)
    return df


def vazio(df):
    """
    Template for empty dataframe
    """
    null_content = {
        "estadio": None,
        "data": None,
        "horario": None,
        "rodada": None,
        "publico": None,
        "publico_max": None,
        "arbitro": None,
        "hthg": None,
        "htag": None,
        "hs": None,
        "as": None,
        "hsofft": None,
        "asofft": None,
        "hdef": None,
        "adef": None,
        "hf": None,
        "af": None,
        "hc": None,
        "ac": None,
        "himp": None,
        "aimp": None,
        "hfk": None,
        "afk": None,
    }
    df = df.append(null_content, ignore_index=True)
    return df


def main():
    """
    Execution of the program
    """
    # Armazena informações do site  em um único dataframe.
    base_url = "https://www.transfermarkt.com/campeonato-brasileiro-serie-a/gesamtspielplan/wettbewerb/BRA1?saison_id={season}&spieltagVon=1&spieltagBis=38"
    headers = {
        "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36"
    }
    base_link = "https://www.transfermarkt.com"
    links = []

    ht_tag = []
    at_tag = []
    result_tag = []

    ht = []
    at = []
    fthg = []
    ftag = []

    pattern_fthg = re.compile("\d:")
    pattern_ftag = re.compile(":\d")

    df = pd.DataFrame(
        {"ht": [], "at": [], "fthg": [], "ftag": [], "col_home": [], "col_away": []}
    )

    # Pegar o link das partidas

    for season in range(2002, 2006):
        # Para cada temporada, adiciona os links dos jogos em `links`
        print(f"Obtendo links: temporada {season}", end="\r")
        site_data = requests.get(base_url.format(season=season), headers=headers)
        soup = BeautifulSoup(site_data.content, "html.parser")
        link_tags = soup.find_all("a", attrs={"title": "Match preview"})
        link_tags2 = soup.find_all("a", attrs={"class": "ergebnis-link"})
        for tag in link_tags:
            links.append(re.sub(r"\s", "", tag["href"]))
        for tag in link_tags2:
            links.append(re.sub(r"\s", "", tag["href"]))

        tabela = soup.findAll("div", class_="large-6 columns")
        for i in range(1, 39):
            for row in tabela[i].findAll("tr"):  # para tudo que estiver em <tr>
                cells = row.findAll("td")  # variável para encontrar <td>
                if len(cells) == 7:
                    ht_tag.append(
                        cells[2].findAll(text=True)
                    )  # iterando sobre cada linha
                    result_tag.append(
                        cells[4].findAll(text=True)
                    )  # iterando sobre cada linha
                    at_tag.append(
                        cells[6].findAll(text=True)
                    )  # iterando sobre cada linha

    for time in range(len(links)):
        try:
            ht.append(str(ht_tag[time][2]))
        except Exception:
            ht.append(str(ht_tag[time]).replace("['", "").replace("']", ""))

    for time in range(len(links)):
        try:
            at.append(str(at_tag[time][0]))
        except Exception:
            at.append(str(at_tag[time]).replace("['", "").replace("']", ""))

    for tag in result_tag:
        fthg.append(
            str(pattern_fthg.findall(str(tag))).replace("['", "").replace(":']", "")
        )
        ftag.append(
            str(pattern_ftag.findall(str(tag))).replace("[':", "").replace("']", "")
        )
    print()

    # Salva os links caso dê algum problema no caminho.
    # with open('links_2003.txt', 'w') as f:
    #   f.write('\n'.join(links))

    new_links = []

    for link in links:
        new_link = link.replace("index", "statistik")
        new_links.append(new_link)

    n_links = len(links)
    print(f"Encontrados {n_links} partidas.")
    print("Extraindo dados...")
    for n, link in enumerate(new_links):
        link_data = requests.get(base_link + link, headers=headers)
        link_soup = BeautifulSoup(link_data.content, "html.parser")
        content = link_soup.find("div", id="main")
        if content:
            try:
                df = process_basico(df, content)
            except Exception:
                try:
                    df = process_basico(df, content)
                except Exception:
                    df = vazio(df)
        else:
            df = vazio(df)
        print(f"{n+1} dados de {n_links} extraídos.", end="\r")
    print()

    df["ht"] = ht
    df["at"] = at
    df["fthg"] = fthg
    df["ftag"] = ftag

    # limpar variaveis
    df["data"] = pd.to_datetime(df["data"]).dt.date
    df["horario"] = pd.to_datetime(df["horario"]).dt.strftime("%H:%M")

    # renomear colunas
    df = df.rename(
        columns={
            "ht": "time_man",
            "at": "time_vis",
            "fthg": "gols_man",
            "ftag": "gols_vis",
            "col_home": "colocacao_man",
            "col_away": "colocacao_vis",
            "ac": "escanteios_vis",
            "hc": "escanteios_man",
            "adef": "defesas_vis",
            "hdef": "defesas_man",
            "af": "faltas_vis",
            "afk": "chutes_bola_parada_vis",
            "aimp": "impedimentos_vis",
            "as": "chutes_vis",
            "asofft": "chutes_fora_vis",
            "hf": "faltas_man",
            "hfk": "chutes_bola_parada_man",
            "himp": "impedimentos_man",
            "hs": "chutes_man",
            "hsofft": "chutes_fora_man",
            "htag": "gols_1_tempo_vis",
            "hthg": "gols_1_tempo_man",
        }
    )

    df = df[
        [
            "data",
            "horario",
            "rodada",
            "estadio",
            "time_man",
            "time_vis",
            "gols_man",
            "gols_vis",
            "gols_1_tempo_man",
            "gols_1_tempo_vis",
            "col_man",
            "col_vis",
            "escanteios_man",
            "escanteios_vis",
            "faltas_man",
            "chutes_bola_parada_man",
            "faltas_vis",
            "chutes_bola_parada_vis",
            "defesas_man",
            "defesas_vis",
            "impedimentos_man",
            "impedimentos_vis",
            "chutes_man",
            "chutes_vis",
            "chutes_fora_man",
            "chutes_fora_vis",
            "arbitro",
            "publico",
            "publico_max",
        ]
    ]

    return df


if __name__ == "__main__":
    df = main()
    df.to_csv("brasileirao_2003.csv", index=False)
