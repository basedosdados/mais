"""
Parser for tramitação data
"""
# pylint: disable=invalid-name,too-many-locals,too-many-statements,too-many-branches,too-many-lines,import-error
import os
from zipfile import ZipFile
from io import BytesIO

import pandas as pd
import numpy as np
import untangle
import requests
from manipulation import normalize, normalize_cols

mais_path = "../../bd+/mais_projects/data/alesp"


def download_unzip(url, path_to_save):
    """
    Download and unzip a file
    """
    # unzip the content
    r = requests.get(url)
    with ZipFile(BytesIO(r.content)) as f:
        f.extractall(path_to_save)
        file_name = f.namelist()[0]
    f.extractall(path=path_to_save)
    return file_name.replace(".xml", "")


def parse_autores(download=True):
    """
    Parser for autores data
    """
    if download:
        url = "http://www.al.sp.gov.br/repositorioDados/processo_legislativo/documento_autor.zip"
        path_to_save = "../data/tramitacoes/"
        file_name = download_unzip(url, path_to_save)
        print("path_to_save = ", path_to_save)

        print("file_name = ", file_name)

        obj = untangle.parse("{}{}.xml".format(path_to_save, file_name))
        obj = obj.documentos_autores.DocumentoAutor
        print("rows: ", len(obj))
        print("Sample:", obj[0])

        cols = ["IdAutor", "IdDocumento", "NomeAutor"]
        l = len(obj)

        for i in range(l):
            line = []

            a = obj[i].IdAutor.cdata

            try:
                b = obj[i].IdDocumento.cdata
            except Exception:
                b = np.nan

            try:
                c = obj[i].NomeAutor.cdata
            except Exception:
                c = np.nan

            line = [a, b, c]

            df = pd.DataFrame([line], columns=cols)

            if i == 0:
                df.to_csv(
                    "../data/tramitacoes/documento_autor.csv",
                    index=False,
                    encoding="utf-8",
                )

            else:
                df.to_csv(
                    "../data/tramitacoes/documento_autor.csv",
                    index=False,
                    encoding="utf-8",
                    header=False,
                    mode="a",
                )
        os.remove(f"{path_to_save}{file_name}.xml")

    df = pd.read_csv("../data/tramitacoes/documento_autor.csv")
    rename_cols = {
        "IdAutor": "id_autor",
        "IdDocumento": "id_documento",
        "NomeAutor": "nome_autor",
    }
    df = df.rename(columns=rename_cols)

    rename = {
        "LUIZ FERNANDO T. FERREIRA": "LUIZ FERNANDO",
        "PAULO CORREA JR.": "PAULO CORREA JR",
    }

    df["nome_autor"] = normalize(df["nome_autor"]).replace(rename)

    df.to_csv("../data/tramitacoes/documento_autor.csv", index=False, encoding="utf-8")


def parse_comissoes(download=True):
    """
    Parser for comissoes data
    """
    if download:
        url = "http://www.al.sp.gov.br/repositorioDados/processo_legislativo/comissoes.xml"
        r = requests.get(url)
        obj = untangle.parse(r.text)
        obj = obj.Comissoes.Comissao
        print("rows: ", len(obj))
        print("Sample:", obj[0])

        cols = ["DataFimComissao", "IdComissao", "NomeComissao", "SiglaComissao"]
        l = len(obj)

        for i in range(l):
            line = []

            try:
                a = obj[i].DataFimComissao.cdata
            except Exception:
                a = np.nan

            try:
                b = obj[i].IdComissao.cdata
            except Exception:
                b = np.nan
            c = obj[i].NomeComissao.cdata

            try:
                d = obj[i].SiglaComissao.cdata
            except Exception:
                d = np.nan

            line = [a, b, c, d]

            df = pd.DataFrame([line], columns=cols)

            if i == 0:
                df.to_csv(
                    "../data/tramitacoes/comissoes.csv", index=False, encoding="utf-8"
                )

            else:
                df.to_csv(
                    "../data/tramitacoes/comissoes.csv",
                    index=False,
                    encoding="utf-8",
                    header=False,
                    mode="a",
                )
    df = pd.read_csv("../data/tramitacoes/comissoes.csv")
    rename_cols = {
        "DataFimComissao": "data_fim_comissao",
        "IdComissao": "id_comissao",
        "NomeComissao": "nome_comissao",
        "SiglaComissao": "sigla_comissao",
    }
    df = df.rename(columns=rename_cols)

    df.to_csv("../data/tramitacoes/comissoes.csv", index=False, encoding="utf-8")


def parse_deliberacoes_comissoes(download=True):
    """
    Parser for deliberacoes comissoes data
    """
    if download:
        url = "http://www.al.sp.gov.br/repositorioDados/processo_legislativo/comissoes_permanentes_deliberacoes.xml"
        r = requests.get(url)
        obj = untangle.parse(r.text)
        obj = obj.ComissoesReunioesDeliberacoes.ReuniaoComissaoDeliberacao

        print("rows: ", len(obj))
        print("Sample:", obj[0])
        cols = [
            "Deliberacao",
            "DataInclusao",
            "DataSaida",
            "IdDeliberacao",
            "IdDocumento",
            "IdPauta",
            "IdReuniao",
            "NrOrdem",
        ]
        l = len(obj)

        for i in range(l):
            line = []

            try:
                a = obj[i].Deliberacao.cdata
            except Exception:
                a = np.nan

            try:
                b = obj[i].DataInclusao.cdata
            except Exception:
                b = np.nan

            try:
                c = obj[i].DataSaida.cdata
            except Exception:
                c = np.nan

            try:
                d = obj[i].IdDeliberacao.cdata
            except Exception:
                d = np.nan

            try:
                e = obj[i].IdDocumento.cdata
            except Exception:
                e = np.nan

            try:
                f = obj[i].IdPauta.cdata
            except Exception:
                f = np.nan

            try:
                g = obj[i].IdReuniao.cdata
            except Exception:
                g = np.nan

            try:
                h = obj[i].NrOrdem.cdata
            except Exception:
                h = np.nan

            line = [a, b, c, d, e, f, g, h]

            df = pd.DataFrame([line], columns=cols)

            if i == 0:
                df.to_csv(
                    "../data/tramitacoes/comissoes_permanentes_deliberacoes.csv",
                    index=False,
                    encoding="utf-8",
                )

            else:
                df.to_csv(
                    "../data/tramitacoes/comissoes_permanentes_deliberacoes.csv",
                    index=False,
                    encoding="utf-8",
                    header=False,
                    mode="a",
                )
    df = pd.read_csv("../data/tramitacoes/comissoes_permanentes_deliberacoes.csv")
    df.columns = normalize_cols(df.columns)
    rename_cols = {
        "datainclusao": "data_inclusao",
        "datasaida": "data_saida",
        "iddeliberacao": "id_deliberacao",
        "iddocumento": "id_documento",
        "idpauta": "id_pauta",
        "idreuniao": "id_reuniao",
        "nrordem": "nuumero_ordem",
    }
    df = df.rename(columns=rename_cols)

    df.to_csv(
        "../data/tramitacoes/comissoes_permanentes_deliberacoes.csv",
        index=False,
        encoding="utf-8",
    )


def parse_comissoes_membros(download=True):
    """
    Parser for comissoes membros data
    """
    if download:
        url = "http://www.al.sp.gov.br/repositorioDados/processo_legislativo/comissoes_membros.xml"
        r = requests.get(url)
        obj = untangle.parse(r.text)
        obj = obj.ComissoesMembros.MembroComissao
        print("rows: ", len(obj))
        print("Sample:", obj[0])

        cols = [
            "DataInicio",
            "Efetivo",
            "IdComissao",
            "IdMembro",
            "IdPapel",
            "NomeMembro",
            "Papel",
            "SiglaComissao",
        ]
        l = len(obj)

        for i in range(l):
            line = []

            try:
                a = obj[i].DataInicio.cdata
            except Exception:
                a = np.nan

            try:
                b = obj[i].Efetivo.cdata
            except Exception:
                b = np.nan

            try:
                c = obj[i].IdComissao.cdata
            except Exception:
                c = np.nan

            try:
                d = obj[i].IdMembro.cdata
            except Exception:
                d = np.nan

            try:
                e = obj[i].IdPapel.cdata
            except Exception:
                e = np.nan

            try:
                f = obj[i].NomeMembro.cdata
            except Exception:
                f = np.nan

            try:
                g = obj[i].Papel.cdata
            except Exception:
                g = np.nan

            try:
                h = obj[i].SiglaComissao.cdata
            except Exception:
                h = np.nan

            line = [a, b, c, d, e, f, g, h]

            df = pd.DataFrame([line], columns=cols)

            if i == 0:
                df.to_csv(
                    "../data/tramitacoes/comissoes_membros.csv",
                    index=False,
                    encoding="utf-8",
                )

            else:
                df.to_csv(
                    "../data/tramitacoes/comissoes_membros.csv",
                    index=False,
                    encoding="utf-8",
                    header=False,
                    mode="a",
                )
    df = pd.read_csv("../data/tramitacoes/comissoes_membros.csv")
    df.columns = normalize_cols(df.columns)
    rename_cols = {
        "datainicio": "data_inicio",
        "idcomissao": "id_comissao",
        "idmembro": "id_membro",
        "idpapel": "id_papel",
        "nomemembro": "nome_membro",
        "siglacomissao": "sigla_comissao",
    }
    df = df.rename(columns=rename_cols)

    df.to_csv(
        "../data/tramitacoes/comissoes_membros.csv",
        index=False,
        encoding="utf-8",
    )


def parse_naturezasSpl(download=True):
    """
    Parser for naturezas SPL data
    """
    if download:
        url = "http://www.al.sp.gov.br/repositorioDados/processo_legislativo/naturezasSpl.xml"
        r = requests.get(url)
        obj = untangle.parse(r.text)
        obj = obj.natureza.natureza
        print("rows: ", len(obj))
        print("Sample:", obj[0])

        cols = ["idNatureza", "nmNatureza", "sgNatureza", "tpNatureza"]
        l = len(obj)

        for i in range(l):
            line = []

            try:
                a = obj[i].idNatureza.cdata
            except Exception:
                a = np.nan

            try:
                b = obj[i].nmNatureza.cdata
            except Exception:
                b = np.nan
            try:
                c = obj[i].sgNatureza.cdata
            except Exception:
                c = np.nan

            try:
                d = obj[i].tpNatureza.cdata
            except Exception:
                d = np.nan

            line = [a, b, c, d]

            df = pd.DataFrame([line], columns=cols)

            if i == 0:
                df.to_csv(
                    "../data/tramitacoes/naturezasSpl.csv",
                    index=False,
                    encoding="utf-8",
                )

            else:
                df.to_csv(
                    "../data/tramitacoes/naturezasSpl.csv",
                    index=False,
                    encoding="utf-8",
                    header=False,
                    mode="a",
                )
    df = pd.read_csv("../data/tramitacoes/naturezasSpl.csv")
    df.columns = normalize_cols(df.columns)
    rename_cols = {
        "idnatureza": "id_natureza",
        "nmnatureza": "nome_natureza",
        "sgnatureza": "sigla_natureza",
        "tpnatureza": "tipo_natureza",
    }
    df = df.rename(columns=rename_cols)

    df.to_csv(
        "../data/tramitacoes/naturezasSpl.csv",
        index=False,
        encoding="utf-8",
    )


def parse_documento_palavras(download=True):
    """
    Parser for documento palavras data
    """
    if download:
        url = "http://www.al.sp.gov.br/repositorioDados/processo_legislativo/documento_palavras.zip"
        path_to_save = "../data/tramitacoes/"
        file_name = download_unzip(url, path_to_save)
        print("path_to_save = ", path_to_save)

        print("file_name = ", file_name)

        obj = untangle.parse("{}{}.xml".format(path_to_save, file_name))
        obj = obj.documentos_palavras.DocumentoPalavra

        print("rows: ", len(obj))
        print("Sample:", obj[0])

        cols = ["IdDocumento", "IdPalavra"]
        l = len(obj)

        for i in range(l):
            line = []

            a = obj[i].IdDocumento.cdata

            try:
                b = obj[i].IdPalavra.cdata
            except Exception:
                b = np.nan

            line = [a, b]

            df = pd.DataFrame([line], columns=cols)

            if i == 0:
                df.to_csv(
                    "../data/tramitacoes/documento_palavras.csv",
                    index=False,
                    encoding="utf-8",
                )

            else:
                df.to_csv(
                    "../data/tramitacoes/documento_palavras.csv",
                    index=False,
                    encoding="utf-8",
                    header=False,
                    mode="a",
                )
        os.remove(f"{path_to_save}{file_name}.xml")
    df = pd.read_csv("../data/tramitacoes/documento_palavras.csv")
    df.columns = normalize_cols(df.columns)
    rename_cols = {
        "iddocumento": "id_documento",
        "idpalavra": "id_palavra",
    }
    df = df.rename(columns=rename_cols)

    df.to_csv(
        "../data/tramitacoes/documento_palavras.csv",
        index=False,
        encoding="utf-8",
    )


def parse_documento_index_palavras(download=True):
    """
    Parser for documento index palavras data
    """
    if download:
        url = "http://www.al.sp.gov.br/repositorioDados/processo_legislativo/palavras_chave.xml"
        r = requests.get(url)
        obj = untangle.parse(r.text)
        obj = obj.palavras_chave.PalavraChave

        print("rows: ", len(obj))
        print("Sample:", obj[0])

        cols = ["IdPalavra", "Palavra", "PalavraSemAcento"]
        l = len(obj)

        for i in range(l):
            line = []

            a = obj[i].IdPalavra.cdata

            try:
                b = obj[i].Palavra.cdata
            except Exception:
                b = np.nan

            try:
                c = obj[i].PalavraSemAcento.cdata
            except Exception:
                c = np.nan

            line = [a, b, c]

            df = pd.DataFrame([line], columns=cols)

            if i == 0:
                df.to_csv(
                    "../data/tramitacoes/index_palavras_chave.csv",
                    index=False,
                    encoding="utf-8",
                )

            else:
                df.to_csv(
                    "../data/tramitacoes/index_palavras_chave.csv",
                    index=False,
                    encoding="utf-8",
                    header=False,
                    mode="a",
                )
    df = pd.read_csv("../data/tramitacoes/index_palavras_chave.csv")
    df.columns = normalize_cols(df.columns)
    rename_cols = {
        "idpalavra": "id_palavra",
        "palavrasemacento": "palavra_sem_acento",
    }
    df = df.rename(columns=rename_cols)

    df.to_csv(
        "../data/tramitacoes/index_palavras_chave.csv",
        index=False,
        encoding="utf-8",
    )


def parse_propositura_parecer(download=True):
    """
    Parser for propositura parecer data
    """
    if download:
        url = "http://www.al.sp.gov.br/repositorioDados/processo_legislativo/propositura_parecer.zip"
        path_to_save = "../data/tramitacoes/"
        file_name = download_unzip(url, path_to_save)
        print("path_to_save = ", path_to_save)
        print("file_name = ", file_name)

        obj = untangle.parse("{}{}.xml".format(path_to_save, file_name))
        obj = obj.pareceres.ProposituraParecerComissao
        print("rows: ", len(obj))
        print("Sample:", obj[0])

        cols = [
            "AnoParecer",
            "Descricao",
            "Data",
            "AdReferendum",
            "RelatorEspecial",
            "VotoVencido",
            "IdComissao",
            "IdDocumento",
            "IdParecer",
            "IdTipoParecer",
            "TipoParecer",
            "NrParecer",
            "SiglaComissao",
            "TpParecer",
            "URL",
        ]
        l = len(obj)
        i = 0
        for i in range(l):

            line = []

            try:
                a = obj[i].AnoParecer.cdata
            except Exception:
                a = np.nan

            try:
                b = obj[i].Descricao.cdata
            except Exception:
                b = np.nan
            try:
                c = obj[i].Data.cdata
            except Exception:
                c = np.nan

            try:
                d = obj[i].AdReferendum.cdata
            except Exception:
                d = np.nan

            try:
                e = obj[i].RelatorEspecial.cdata
            except Exception:
                e = np.nan

            try:
                f = obj[i].VotoVencido.cdata
            except Exception:
                f = np.nan

            try:
                g = obj[i].IdComissao.cdata
            except Exception:
                g = np.nan

            try:
                h = obj[i].IdDocumento.cdata
            except Exception:
                h = np.nan

            try:
                z = obj[i].IdParecer.cdata
            except Exception:
                z = np.nan

            try:
                j = obj[i].IdTipoParecer.cdata
            except Exception:
                j = np.nan

            try:
                k = obj[i].TipoParecer.cdata
            except Exception:
                k = np.nan

            try:
                l = obj[i].NrParecer.cdata
            except Exception:
                l = np.nan

            try:
                m = obj[i].SiglaComissao.cdata
            except Exception:
                m = np.nan

            try:
                n = obj[i].TpParecer.cdata
            except Exception:
                n = np.nan

            try:
                o = obj[i].URL.cdata
            except Exception:
                o = np.nan

            line = [a, b, c, d, e, f, g, h, z, j, k, l, m, n, o]

            df = pd.DataFrame([line], columns=cols)

            #     print(i)
            if i == 0:
                df.to_csv(
                    "../data/tramitacoes/propositura_parecer.csv",
                    index=False,
                    encoding="utf-8",
                )

            else:
                df.to_csv(
                    "../data/tramitacoes/propositura_parecer.csv",
                    index=False,
                    encoding="utf-8",
                    header=False,
                    mode="a",
                )
        os.remove(f"{path_to_save}{file_name}.xml")

    df = pd.read_csv("../data/tramitacoes/propositura_parecer.csv")
    df.columns = normalize_cols(df.columns)
    rename_cols = {
        "anoparecer": "ano_parecer",
        "adreferendum": "ad_referendum",
        "relatorespecial": "relator_especial",
        "votovencido": "voto_vencido",
        "idcomissao": "id_comissao",
        "iddocumento": "id_documento",
        "idparecer": "id_parecer",
        "idtipoparecer": "id_tipo_parecer",
        "tipoparecer": "tipo_parecer",
        "nrparecer": "numero_parecer",
        "siglacomissao": "sigla_comissao",
        "tpparecer": "tipo_parecer",
        "url": "url",
    }
    df = df.rename(columns=rename_cols)

    df.to_csv(
        "../data/tramitacoes/propositura_parecer.csv",
        index=False,
        encoding="utf-8",
    )


def parse_comissoes_permanentes_presencas(download=True):
    """
    Parser for comissoes permanentes presencas data
    """
    if download:
        url = "http://www.al.sp.gov.br/repositorioDados/processo_legislativo/comissoes_permanentes_presencas.xml"
        r = requests.get(url)

        obj = untangle.parse(r.text)
        obj = obj.ComissoesReunioesPresencas.ReuniaoComissaoPresenca
        print("rows: ", len(obj))
        print("Sample:", obj[0])

        cols = [
            "DataReuniao",
            "IdComissao",
            "IdDeputado",
            "IdPauta",
            "IdReuniao",
            "Deputado",
            "SiglaComissao",
        ]
        l = len(obj)

        for i in range(l):
            line = []

            try:
                a = obj[i].DataReuniao.cdata
            except Exception:
                a = np.nan

            try:
                b = obj[i].IdComissao.cdata
            except Exception:
                b = np.nan
            try:
                c = obj[i].IdDeputado.cdata
            except Exception:
                c = np.nan

            try:
                d = obj[i].IdPauta.cdata
            except Exception:
                d = np.nan

            try:
                e = obj[i].IdReuniao.cdata
            except Exception:
                e = np.nan

            try:
                f = obj[i].Deputado.cdata
            except Exception:
                f = np.nan

            try:
                g = obj[i].SiglaComissao.cdata
            except Exception:
                g = np.nan

            line = [a, b, c, d, e, f, g]

            df = pd.DataFrame([line], columns=cols)

            if i == 0:
                df.to_csv(
                    "../data/tramitacoes/comissoes_permanentes_presencas.csv",
                    index=False,
                    encoding="utf-8",
                )

            else:
                df.to_csv(
                    "../data/tramitacoes/comissoes_permanentes_presencas.csv",
                    index=False,
                    encoding="utf-8",
                    header=False,
                    mode="a",
                )
    df = pd.read_csv("../data/tramitacoes/comissoes_permanentes_presencas.csv")
    df.columns = normalize_cols(df.columns)
    rename_cols = {
        "datareuniao": "data_reuniao",
        "idcomissao": "id_comissao",
        "iddeputado": "id_deputado",
        "idpauta": "id_pauta",
        "idreuniao": "id_reuniao",
        "siglacomissao": "sigla_comissao",
        "deputado": "nome_deputado",
    }
    df = df.rename(columns=rename_cols)

    df.to_csv(
        "../data/tramitacoes/comissoes_permanentes_presencas.csv",
        index=False,
        encoding="utf-8",
    )

    return df


def parse_proposituras(download=True):
    """
    Parser for proposituras data
    """
    if download:
        url = "http://www.al.sp.gov.br/repositorioDados/processo_legislativo/proposituras.zip"
        path_to_save = "../data/tramitacoes/"
        file_name = download_unzip(url, path_to_save)
        print("path_to_save = ", path_to_save)
        print("file_name = ", file_name)

        obj = untangle.parse("{}{}.xml".format(path_to_save, file_name))
        obj = obj.proposituras.propositura
        print("rows: ", len(obj))
        print("Sample:", obj[0])

        cols = [
            "AnoLegislativo",
            "CodOriginalidade",
            "Ementa",
            "DtEntradaSistema",
            "DtPublicacao",
            "IdDocumento",
            "IdNatureza",
            "NroLegislativo",
        ]
        l = len(obj)

        for i in range(l):
            line = []

            try:
                a = obj[i].AnoLegislativo.cdata
            except Exception:
                a = np.nan

            try:
                b = obj[i].CodOriginalidade.cdata
            except Exception:
                b = np.nan
            c = obj[i].Ementa.cdata

            try:
                d = obj[i].DtEntradaSistema.cdata
            except Exception:
                d = np.nan

            e = obj[i].DtPublicacao.cdata
            f = obj[i].IdDocumento.cdata
            g = obj[i].IdNatureza.cdata
            h = obj[i].NroLegislativo.cdata

            line = [a, b, c, d, e, f, g, h]

            df = pd.DataFrame([line], columns=cols)

            if i == 0:
                df.to_csv(
                    "../data/tramitacoes/proposituras.csv",
                    index=False,
                    encoding="utf-8",
                )

            else:
                df.to_csv(
                    "../data/tramitacoes/proposituras.csv",
                    index=False,
                    encoding="utf-8",
                    header=False,
                    mode="a",
                )
        os.remove(f"{path_to_save}{file_name}.xml")

    df = pd.read_csv("../data/tramitacoes/proposituras.csv")
    df.columns = normalize_cols(df.columns)
    rename_cols = {
        "anolegislativo": "ano_legislativo",
        "codoriginalidade": "codigo_originalidade",
        "dtentradasistema": "data_entrada_sistema",
        "dtpublicacao": "data_publicacao",
        "iddocumento": "id_documento",
        "idnatureza": "id_natureza",
        "nrolegislativo": "numero_legislativo",
    }
    df = df.rename(columns=rename_cols)

    df.to_csv(
        "../data/tramitacoes/proposituras.csv",
        index=False,
        encoding="utf-8",
    )


def parse_documento_regime(download=True):
    """
    Parser for documento_regime data
    """
    if download:
        url = "http://www.al.sp.gov.br/repositorioDados/processo_legislativo/documento_regime.zip"
        path_to_save = "../data/tramitacoes/"
        file_name = download_unzip(url, path_to_save)
        print("path_to_save = ", path_to_save)
        print("file_name = ", file_name)

        obj = untangle.parse("{}{}.xml".format(path_to_save, file_name))
        obj = obj.documentos_regimes.DocumentoRegime
        print("rows: ", len(obj))
        print("Sample:", obj[0])

        cols = ["DataFim", "DataInicio", "IdDocumento", "IdRegime", "NomeRegime"]
        l = len(obj)

        for i in range(l):
            line = []

            try:
                a = obj[i].DataFim.cdata
            except Exception:
                a = np.nan

            try:
                b = obj[i].DataInicio.cdata
            except Exception:
                b = np.nan

            try:
                c = obj[i].IdDocumento.cdata
            except Exception:
                c = np.nan

            try:
                d = obj[i].IdRegime.cdata
            except Exception:
                d = np.nan

            try:
                e = obj[i].NomeRegime.cdata
            except Exception:
                e = np.nan

            line = [a, b, c, d, e]

            df = pd.DataFrame([line], columns=cols)

            if i == 0:
                df.to_csv(
                    "../data/tramitacoes/documento_regime.csv",
                    index=False,
                    encoding="utf-8",
                )

            else:
                df.to_csv(
                    "../data/tramitacoes/documento_regime.csv",
                    index=False,
                    encoding="utf-8",
                    header=False,
                    mode="a",
                )
        os.remove(f"{path_to_save}{file_name}.xml")

    df = pd.read_csv("../data/tramitacoes/documento_regime.csv")
    df.columns = normalize_cols(df.columns)
    rename_cols = {
        "datafim": "data_fim",
        "datainicio": "data_inicio",
        "iddocumento": "id_documento",
        "idregime": "id_regime",
        "nomeregime": "nome_regime",
    }
    df = df.rename(columns=rename_cols)

    df.to_csv(
        "../data/tramitacoes/documento_regime.csv",
        index=False,
        encoding="utf-8",
    )


def parse_comissoes_permanentes_reunioes(download=True):
    """
    Parser for comissoes_permanentes_reunioes data
    """
    if download:
        url = "http://www.al.sp.gov.br/repositorioDados/processo_legislativo/comissoes_permanentes_reunioes.xml"
        r = requests.get(url)

        obj = untangle.parse(r.text)
        obj = obj.ComissoesReunioes.ReuniaoComissao
        print("rows: ", len(obj))
        print("Sample:", obj[0])

        cols = [
            "Situacao",
            "Data",
            "IdComissao",
            "IdPauta",
            "IdReuniao",
            "Presidente",
            "NrConvocacao",
            "NrLegislatura",
            "TipoConvocacao",
            "CodSituacao",
        ]
        l = len(obj)

        for i in range(l):
            line = []

            try:
                a = obj[i].Situacao.cdata
            except Exception:
                a = np.nan

            try:
                b = obj[i].Data.cdata
            except Exception:
                b = np.nan

            try:
                c = obj[i].IdComissao.cdata
            except Exception:
                c = np.nan

            try:
                d = obj[i].IdPauta.cdata
            except Exception:
                d = np.nan

            try:
                e = obj[i].IdReuniao.cdata
            except Exception:
                e = np.nan

            try:
                f = obj[i].Presidente.cdata
            except Exception:
                f = np.nan

            try:
                g = obj[i].NrConvocacao.cdata
            except Exception:
                g = np.nan

            try:
                h = obj[i].NrLegislatura.cdata
            except Exception:
                h = np.nan

            try:
                z = obj[i].TipoConvocacao.cdata
            except Exception:
                z = np.nan

            try:
                j = obj[i].CodSituacao.cdata
            except Exception:
                j = np.nan

            line = [a, b, c, d, e, f, g, h, z, j]

            df = pd.DataFrame([line], columns=cols)

            if i == 0:
                df.to_csv(
                    "../data/tramitacoes/comissoes_permanentes_reunioes.csv",
                    index=False,
                    encoding="utf-8",
                )

            else:
                df.to_csv(
                    "../data/tramitacoes/comissoes_permanentes_reunioes.csv",
                    index=False,
                    encoding="utf-8",
                    header=False,
                    mode="a",
                )

    df = pd.read_csv("../data/tramitacoes/comissoes_permanentes_reunioes.csv")
    df.columns = normalize_cols(df.columns)
    rename_cols = {
        "idcomissao": "id_comissao",
        "idpauta": "id_pauta",
        "nrconvocacao": "numero_convocacao",
        "nrlegislatura": "numero_legislatura",
        "tipoconvocacao": "tipo_convocacao",
        "codsituacao": "codigo_situacao",
    }
    df = df.rename(columns=rename_cols)

    df.to_csv(
        "../data/tramitacoes/comissoes_permanentes_reunioes.csv",
        index=False,
        encoding="utf-8",
    )


def parse_comissoes_permanentes_votacoes(download=True):
    """
    Parser for comissoes_permanentes_votacoes data
    """
    if download:
        url = "http://www.al.sp.gov.br/repositorioDados/processo_legislativo/comissoes_permanentes_votacoes.xml"
        r = requests.get(url)

        obj = untangle.parse(r.text)
        obj = obj.ComissoesReunioesVotacao.ReuniaoComissaoVotacao
        print("rows: ", len(obj))
        print("Sample:", obj[0])

        cols = [
            "Voto",
            "IdComissao",
            "IdDeputado",
            "IdDocumento",
            "IdPauta",
            "IdReuniao",
            "Deputado",
            "TipoVoto",
        ]
        l = len(obj)

        for i in range(l):
            line = []

            try:
                a = obj[i].Voto.cdata
            except Exception:
                a = np.nan

            try:
                b = obj[i].IdComissao.cdata
            except Exception:
                b = np.nan

            try:
                c = obj[i].IdDeputado.cdata
            except Exception:
                c = np.nan

            try:
                d = obj[i].IdDocumento.cdata
            except Exception:
                d = np.nan

            try:
                e = obj[i].IdPauta.cdata
            except Exception:
                e = np.nan

            try:
                f = obj[i].IdReuniao.cdata
            except Exception:
                f = np.nan

            try:
                g = obj[i].Deputado.cdata
            except Exception:
                g = np.nan

            try:
                h = obj[i].TipoVoto.cdata
            except Exception:
                h = np.nan

            line = [a, b, c, d, e, f, g, h]

            df = pd.DataFrame([line], columns=cols)

            if i == 0:
                df.to_csv(
                    "../data/tramitacoes/comissoes_permanentes_votacoes.csv",
                    index=False,
                    encoding="utf-8",
                )

            else:
                df.to_csv(
                    "../data/tramitacoes/comissoes_permanentes_votacoes.csv",
                    index=False,
                    encoding="utf-8",
                    header=False,
                    mode="a",
                )

    df = pd.read_csv("../data/tramitacoes/comissoes_permanentes_votacoes.csv")
    df.columns = normalize_cols(df.columns)
    rename_cols = {
        "idcomissao": "id_comissao",
        "iddeputado": "id_deputado",
        "iddocumento": "id_documento",
        "idpauta": "id_pauta",
        "idreuniao": "id_reuniao",
        "tipovoto": "tipo_voto",
        "deputado": "nome_deputado",
    }
    df = df.rename(columns=rename_cols)

    df.to_csv(
        "../data/tramitacoes/comissoes_permanentes_votacoes.csv",
        index=False,
        encoding="utf-8",
    )


def parse_documento_andamento_atual(download=True):
    """
    Parser for documento_andamento_atual data
    """
    if download:
        url = "http://www.al.sp.gov.br/repositorioDados/processo_legislativo/documento_andamento_atual.zip"
        path_to_save = "../data/tramitacoes/"
        file_name = download_unzip(url, path_to_save)
        print("path_to_save = ", path_to_save)
        print("file_name = ", file_name)

        obj = untangle.parse("{}{}.xml".format(path_to_save, file_name))
        obj = obj.documentos_andamentos.DocumentoAndamento
        print("rows: ", len(obj))
        print("Sample:", obj[0])

        cols = [
            "Descricao",
            "Data",
            "IdComissao",
            "IdDocumento",
            "IdEtapa",
            "IdTpAndamento",
            "NmEtapa",
            "NrOrdem",
            "TpAndamento",
        ]
        l = len(obj)

        for i in range(l):
            line = []

            try:
                a = obj[i].Descricao.cdata
            except Exception:
                a = np.nan
            b = obj[i].Data.cdata
            c = obj[i].IdComissao.cdata
            d = obj[i].IdDocumento.cdata
            e = obj[i].IdEtapa.cdata
            f = obj[i].IdTpAndamento.cdata
            g = obj[i].NmEtapa.cdata
            h = obj[i].NrOrdem.cdata
            z = obj[i].TpAndamento.cdata

            line = [a, b, c, d, e, f, g, h, z]

            df = pd.DataFrame([line], columns=cols)

            if i == 0:
                df.to_csv(
                    "../data/tramitacoes/documento_andamento_atual.csv",
                    index=False,
                    encoding="utf-8",
                )

            else:
                df.to_csv(
                    "../data/tramitacoes/documento_andamento_atual.csv",
                    index=False,
                    encoding="utf-8",
                    header=False,
                    mode="a",
                )
        os.remove(f"{path_to_save}{file_name}.xml")

    df = pd.read_csv("../data/tramitacoes/documento_andamento_atual.csv")
    df.columns = normalize_cols(df.columns)
    rename_cols = {
        "idcomissao": "id_comissao",
        "iddocumento": "id_documento",
        "idetapa": "id_etapa",
        "idtpandamento": "id_tipo_andamento",
        "nmetapa": "nome_etapa",
        "nrordem": "numero_ordem",
        "tpandamento": "tipo_andamento",
    }
    df = df.rename(columns=rename_cols)

    df.to_csv(
        "../data/tramitacoes/documento_andamento_atual.csv",
        index=False,
        encoding="utf-8",
    )


def parse_documento_andamento(download=True):
    """
    Parser for documento_andamento data
    """
    if download:
        url = "http://www.al.sp.gov.br/repositorioDados/processo_legislativo/documento_andamento.zip"
        path_to_save = "../data/tramitacoes/"
        file_name = download_unzip(url, path_to_save)
        print("path_to_save = ", path_to_save)
        print("file_name = ", file_name)

        obj = untangle.parse("{}{}".format(path_to_save, file_name))
        obj = obj.documentos_andamentos.DocumentoAndamento
        print("rows: ", len(obj))
        print("Sample:", obj[0])

        cols = [
            "Descricao",
            "Data",
            "IdComissao",
            "IdDocumento",
            "IdEtapa",
            "IdTpAndamento",
            "NmEtapa",
            "NrOrdem",
            "TpAndamento",
        ]
        l = len(obj)

        for i in range(l):
            line = []

            try:
                a = obj[i].Descricao.cdata
            except Exception:
                a = np.nan
            b = obj[i].Data.cdata
            c = obj[i].IdComissao.cdata
            d = obj[i].IdDocumento.cdata
            e = obj[i].IdEtapa.cdata
            f = obj[i].IdTpAndamento.cdata
            g = obj[i].NmEtapa.cdata
            h = obj[i].NrOrdem.cdata
            z = obj[i].TpAndamento.cdata

            line = [a, b, c, d, e, f, g, h, z]

            df = pd.DataFrame([line], columns=cols)

            if i == 0:
                df.to_csv(
                    "../data/tramitacoes/documento_andamento.csv",
                    index=False,
                    encoding="utf-8",
                )

            else:
                df.to_csv(
                    "../data/tramitacoes/documento_andamento.csv",
                    index=False,
                    encoding="utf-8",
                    header=False,
                    mode="a",
                )
        os.remove(f"{path_to_save}{file_name}.xml")
