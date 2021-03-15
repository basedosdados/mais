import os

import pandas as pd
import numpy as np

import untangle
import requests

import scripts.manipulation as manipulation


mais_path = "../../bd+/mais_projects/data/alesp"


def parse_deputados(download=True):  # sourcery no-metrics
    if download:
        r = requests.get(
            "https://www.al.sp.gov.br/repositorioDados/deputados/deputados.xml"
        )

        obj = untangle.parse(r.text)

        cols = [
            "idDeputado",
            "nomeParlamentar",
            "aniversario",
            "partido",
            "situacao",
            "email",
            "sala",
            "placaVeiculo",
            "biografia",
            "homePage",
            "andar",
            "fax",
            "matricula",
            "IdSPL",
        ]
        l = len(obj.Deputados.Deputado)

        for i in range(l):
            line = []
            #     print(i)
            a = obj.Deputados.Deputado[i].IdDeputado.cdata
            b = obj.Deputados.Deputado[i].NomeParlamentar.cdata
            c = obj.Deputados.Deputado[i].Aniversario.cdata
            try:
                e = obj.Deputados.Deputado[i].Partido.cdata
            except:
                e = np.nan
            #     i = obj.Deputados.Deputado[i].Telefone
            f = obj.Deputados.Deputado[i].Situacao.cdata
            g = obj.Deputados.Deputado[i].Email.cdata

            try:
                h = obj.Deputados.Deputado[i].Sala.cdata
            except:
                h = np.nan
            #     i = obj.Deputados.Deputado[i].Telefone

            try:
                j = obj.Deputados.Deputado[i].PlacaVeiculo.cdata
            except:
                j = np.nan

            k = obj.Deputados.Deputado[i].Biografia.cdata

            try:
                l = obj.Deputados.Deputado[i].HomePage.cdata
            except:
                l = np.nan

            try:
                m = obj.Deputados.Deputado[i].Andar.cdata
            except:
                m = np.nan

            try:
                n = obj.Deputados.Deputado[i].Fax.cdata
            except:
                n = np.nan

            o = obj.Deputados.Deputado[i].Matricula.cdata
            p = obj.Deputados.Deputado[i].IdSPL.cdata

            line = [a, b, c, e, f, g, h, j, k, l, m, n, o, p]

            df = pd.DataFrame([line], columns=cols)

            if i == 0:
                df.to_csv(
                    "../data/servidores/deputados_alesp_aux.csv",
                    index=False,
                    encoding="utf-8",
                )

            else:
                df.to_csv(
                    "../data/servidores/deputados_alesp_aux.csv",
                    index=False,
                    encoding="utf-8",
                    header=False,
                    mode="a",
                )

    deputados = pd.read_csv("../data/servidores/deputados_alesp_aux.csv")
    deputados = deputados.drop(columns=["biografia", "fax"])
    deputados["partido"] = deputados["partido"].fillna("SEM PARTIDO")

    deputados["aniversario"] = pd.to_datetime(
        deputados["aniversario"], format="%d/%m", errors="coerce"
    )
    mask = deputados["aniversario"].notnull()
    deputados_aniversarios = deputados[mask]
    deputados_sem_aniversarios = deputados[np.logical_not(mask)]
    deputados_aniversarios["aniversario"] = (
        deputados_aniversarios["aniversario"]
        .dt.month.astype(str)
        .apply(lambda x: "0" + str(x) if len(x) == 1 else (str(x)))
        + "-"
        + deputados_aniversarios["aniversario"]
        .dt.day.astype(str)
        .apply(lambda x: "0" + str(x) if len(x) == 1 else (str(x)))
    )
    deputados = pd.concat([deputados_aniversarios, deputados_sem_aniversarios])

    rename = {
        #             'LUIZ FERNANDO T. FERREIRA':'LUIZ FERNANDO',
        "PAULO CORREA JR.": "PAULO CORREA JR"
    }

    deputados["nomeParlamentar"] = manipulation.normalize(
        deputados["nomeParlamentar"]
    ).replace(rename)

    mask = deputados["nomeParlamentar"].notnull()
    deputados = deputados[mask]

    rename_cols = {
        "idDeputado": "id_deputado",
        "nomeParlamentar": "nome_deputado",
        "placaVeiculo": "placa_veiculo",
        "homePage": "home_page",
        "IdSPL": "id_spl",
        "partido": "sigla_partido",
    }
    deputados = deputados.rename(columns=rename_cols)

    deputados.to_csv(
        "../data/servidores/deputados_alesp.csv", index=False, encoding="utf-8"
    )
    # deputados.to_csv(
    #     f"{mais_path}/raw/servidores/deputados_alesp.csv",
    #     index=False,
    #     encoding="utf-8",
    # )

    os.remove("../data/servidores/deputados_alesp_aux.csv")
    return deputados


def parse_servidores():
    url = "https://www.al.sp.gov.br/servidor/lista/?todos=true"
    html = requests.get(url).content
    df_list = pd.read_html(html)
    df = df_list[-1]

    old_cols = df.columns.tolist()
    for col in df.columns:
        df[col[1]] = df[col]

    df = df.drop(columns=old_cols)

    df.to_csv(
        "../data/servidores/servidores_locacao_cargo.csv", index=False, encoding="utf-8"
    )

    servidores = pd.read_csv("../data/servidores/servidores_locacao_cargo.csv")
    servidores = servidores[servidores["SERVIDOR"].notnull()]
    servidores["REGIME"] = (
        servidores["CARGO"].str.split(" - ").apply(lambda x: x[1]).str.strip()
    )
    servidores["CARGO"] = (
        servidores["CARGO"].str.split(" - ").apply(lambda x: x[0]).str.strip()
    )
    servidores.columns = manipulation.normalize(servidores.columns)
    mask = servidores["LOTACAO"].str.contains("GABINETE DEP.")

    rename_cols = {
        "Deputado": "nome_deputado",
    }
    servidores = servidores.rename(columns=rename_cols)

    servidores["nome_deputado"] = np.where(
        mask, servidores["LOTACAO"].str.replace("GABINETE DEP.", ""), np.nan
    )
    for col in servidores.columns:
        servidores[col] = manipulation.normalize(servidores[col])

    demais_servidores = servidores[servidores["nome_deputado"].isnull()]

    servidores = servidores[servidores["nome_deputado"].notnull()]

    servidores.columns = manipulation.normalize_cols(servidores.columns)

    ### Merge servidores e partidos
    deputados = pd.read_csv("../data/servidores/deputados_alesp.csv")

    servidores = deputados[["nome_deputado", "sigla_partido"]].merge(
        servidores, how="outer", on="nome_deputado"
    )

    servidores.to_csv(
        "../data/servidores/assessores_parlamentares.csv", index=False, encoding="utf-8"
    )
    # servidores.to_csv(
    #     f"{mais_path}/raw/servidores/assessores_parlamentares.csv",
    #     index=False,
    #     encoding="utf-8",
    # )

    ### Demais Servidores
    mask = demais_servidores["LOTACAO"].str.contains("LIDERANCA DO")
    mask2 = demais_servidores["LOTACAO"].str.contains("LIDERANCA DA")

    demais_servidores["Partido"] = np.where(
        mask, demais_servidores["LOTACAO"].str.replace("LIDERANCA DO ", ""), np.nan
    )
    demais_servidores["Partido"] = np.where(
        mask2,
        demais_servidores["LOTACAO"].str.replace("LIDERANCA DA ", ""),
        demais_servidores["Partido"],
    )

    mask = demais_servidores["Partido"].notnull()

    liderancas = demais_servidores[mask]

    rename = {
        "PARTIDO SOCIAL DEMOCRATICO": "PSD",
        "PARTIDO NOVO ": "NOVO",
        "REDE SUSTENTABILIDADE": "REDE",
        "SOLIDARIEDADE": "SD",
        "PC DO B": "PC do B",
    }

    liderancas["Partido"] = (
        liderancas["Partido"].replace(rename).str.replace("PARTIDO ", "")
    )
    # liderancas.columns = liderancas.columns.str.title()
    liderancas = liderancas.drop(["nome_deputado"], 1)
    liderancas.columns = manipulation.normalize_cols(liderancas.columns)
    rename_cols = {
        "partido": "sigla_partido",
    }
    liderancas = liderancas.rename(columns=rename_cols)

    all_cols = liderancas.columns.tolist()
    all_cols.remove("sigla_partido")
    lideranca_order = ["sigla_partido"] + all_cols
    liderancas = liderancas[lideranca_order]

    liderancas.to_csv(
        "../data/servidores/assessores_lideranca.csv", index=False, encoding="utf-8"
    )
    # liderancas.to_csv(
    #     f"{mais_path}/raw/servidores/assessores_lideranca.csv",
    #     index=False,
    #     encoding="utf-8",
    # )

    os.remove("../data/servidores/servidores_locacao_cargo.csv")
    return servidores, liderancas


def parse_despesas(download=True):
    if download:
        url = (
            "http://www.al.sp.gov.br/repositorioDados/deputados/despesas_gabinetes.xml"
        )
        r = requests.get(url)
        print("xml downloaded")
        obj = untangle.parse(r.text)
        obj = obj.despesas.despesa
        print("number of rows = ", len(obj))

        cols = [
            "Ano",
            "Matricula",
            "Mes",
            "Valor",
            "CNPJ",
            "Deputado",
            "Tipo",
            "Fornecedor",
        ]

        l = len(obj)

        for i in range(l):
            line = []

            #     print(i)

            a = obj[i].Ano.cdata
            b = obj[i].Matricula.cdata
            c = obj[i].Mes.cdata
            d = obj[i].Valor.cdata
            try:
                e = obj[i].CNPJ.cdata
            except:
                e = np.nan

            f = obj[i].Deputado.cdata
            g = obj[i].Tipo.cdata
            h = obj[i].Fornecedor.cdata

            line = [a, b, c, d, e, f, g, h]

            df = pd.DataFrame([line], columns=cols)

            if i == 0:
                df.to_csv(
                    "../data/gastos/despesas_gabinetes_aux.csv",
                    index=False,
                    encoding="utf-8",
                )

            else:
                df.to_csv(
                    "../data/gastos/despesas_gabinetes_aux.csv",
                    index=False,
                    encoding="utf-8",
                    header=False,
                    mode="a",
                )

    despesas = pd.read_csv("../data/gastos/despesas_gabinetes_aux.csv")
    deputados = pd.read_csv("../data/servidores/deputados_alesp.csv")

    ############### DESPESAS SINCE 2002
    despesas_all = despesas.copy()
    despesas_all["Data"] = pd.to_datetime(
        despesas["Ano"].astype(str) + "-" + despesas["Mes"].astype(str)
    )
    despesas_all = despesas_all.sort_values(by="Data")
    cols = [
        "Ano",
        "Mes",
        "Data",
        "Matricula",
        "Deputado",
        "CNPJ",
        "Fornecedor",
        "Tipo",
        "Valor",
    ]
    despesas_all = despesas_all[cols]
    despesas_all["CNPJ"] = despesas_all["CNPJ"].astype(str).str.replace(".0", "")
    despesas_all.columns = manipulation.normalize_cols(despesas_all.columns)
    despesas_all = despesas_all.drop(["data"], 1)
    rename_cols = {
        "partido": "sigla_partido",
        "deputado": "nome_deputado",
        "cnpj": "cpf_cnpj",
    }
    despesas_all = despesas_all.rename(columns=rename_cols)
    despesas_all.to_csv("../data/gastos/despesas_since_2002.csv", index=False)
    # despesas_all.to_csv(f"{mais_path}/raw/gastos/despesas_since_2002.csv", index=False)

    for ano in despesas_all["ano"].unique():
        partitioned_path = "../data/gastos/despesas_gabinete/"
        mask = despesas_all["ano"] == ano
        dd = despesas_all[mask]

        partitioned_path += f"ano={ano}/"
        if os.path.isdir(partitioned_path) == False:
            os.makedirs(partitioned_path)

        dd = dd.drop("ano", 1)
        dd.to_csv(
            partitioned_path + "gastos_gabinete.csv", index=False, encoding="utf-8"
        )

    print("Despesas ALL done!")

    ### inicio mandato
    despesas["CNPJ"] = despesas["CNPJ"].astype(str).str.replace(".0", "")
    despesas["Data"] = pd.to_datetime(
        despesas["Ano"].astype(str) + "-" + despesas["Mes"].astype(str)
    )

    mask = despesas["Data"] >= "2019-03-01"
    despesas = despesas[mask].sort_values(by="Data")

    deputados_list = deputados["matricula"].unique().tolist()

    df_ano_mes = pd.DataFrame()

    for i in range(2019, 2023):
        for j in range(1, 13):
            df_aux = pd.DataFrame(deputados_list, columns=["Matricula"])
            df_aux["Ano"] = i
            df_aux["Mes"] = j
            #         df_aux['cota']=33000
            df_ano_mes = pd.concat([df_ano_mes, df_aux], axis=0)

    max_year = max(despesas["Ano"])
    max_month = max(despesas["Mes"])

    mask = (df_ano_mes["Ano"] <= max_year) & (df_ano_mes["Mes"] <= max_month)

    df_ano_mes = df_ano_mes[mask]

    df_ano_mes

    df_ano_mes["Data"] = pd.to_datetime(
        df_ano_mes["Ano"].astype(str) + "-" + df_ano_mes["Mes"].astype(str)
    )

    ### inicio mandato
    mask = mask = df_ano_mes["Data"] >= "2019-03-01"
    df_ano_mes = df_ano_mes[mask]

    df_ano_mes = df_ano_mes.drop(columns=["Data"])
    despesas_final = pd.merge(
        despesas, df_ano_mes, how="outer", on=["Matricula", "Ano", "Mes"]
    ).sort_values(by=["Matricula", "Ano", "Mes"])

    despesas_final["Data"] = (
        despesas_final["Ano"].astype(str) + "-" + despesas_final["Mes"].astype(str)
    )

    despesas_final["Data"] = pd.to_datetime(despesas_final["Data"])

    despesas_final = despesas_final.drop(["Data"], 1)
    despesas_final = despesas_final.rename(columns={"Deputado": "nome_deputado"})
    despesas_final.columns = manipulation.normalize_cols(despesas_final.columns)
    despesas_final = pd.merge(
        despesas_final.drop(["nome_deputado"], 1),
        deputados[["matricula", "nome_deputado"]],
        on="matricula",
    )
    rename_cols = {
        "partido": "sigla_partido",
        "cnpj": "cpf_cnpj",
    }
    despesas_final = despesas_final.rename(columns=rename_cols)

    despesas_final = despesas_final[despesas_all.columns]
    despesas_final.to_csv(
        "../data/gastos/despesas_gabinetes_mandato.csv", index=False, encoding="utf-8"
    )

    print("Despesas Mandato done!")

    return despesas_all, despesas_final
