import pandas as pd
import numpy as np
import os
import shutil


def file_table_reference():
    folders = [
        "alfabetizacao_homens_mulheres",
        "alfabetizacao_total",
        "basico",
        "domicilio_caracteristicas_gerais",
        "domicilio_moradores",
        "domicilio_renda",
        "entorno01",
        "entorno02",
        "entorno03",
        "entorno04",
        "entorno05",
        "idade_homens",
        "idade_mulheres",
        "idade_total",
        "pessoa_renda",
        "raca_alfabetizacao_idade_genero",
        "raca_idade_0_4_genero",
        "raca_idade_genero",
        "registro_civil",
        "relacao_parentesco_conjuges",
        "relacao_parentesco_filhos",
        "relacao_parentesco_filhos_enteados",
        "relacao_parentesco_outros",
        "responsavel_domicilios_homens_total",
        "responsavel_domicilios_mulheres",
        "responsavel_renda",
    ]

    files = [
        "pessoa02",
        "pessoa01",
        "basico",
        "domicilio01",
        "domicilio02",
        "domiciliorenda",
        "entorno01",
        "entorno02",
        "entorno03",
        "entorno04",
        "entorno05",
        "pessoa11",
        "pessoa12",
        "pessoa13",
        "pessoarenda",
        "pessoa04",
        "pessoa05",
        "pessoa03",
        "pessoa10",
        "pessoa06",
        "pessoa07",
        "pessoa08",
        "pessoa09",
        "responsavel02",
        "responsavel01",
        "responsavelrenda",
    ]

    return dict(zip(files, folders))


def make_dirs(path, folder):
    if not os.path.exists(f"{path}/{folder}"):
        os.mkdir(f"{path}/{folder}")


def create_dataset_folders(
    file_table_reference, path="../data/censo/bases/tratado/organized"
):
    # shutil.rmtree(path)
    if not os.path.exists(path):
        os.mkdir(path)

    for folder in list(file_table_reference.values()):
        make_dirs(path, folder)


def rename_and_move_files(xls_files, datasets_path):
    for xls_file in xls_files:
        try:
            tipo = uf_folder = xls_file.split("/")[-1].split("_")[1][2:]
            uf_folder = xls_file.split("/")[-1].split("_")[1][-6:][:2]
            filename = xls_file.split("/")[-1].split("_")[0]
        except:
            tipo = uf_folder = xls_file.split("/")[-1].split("-")[1][2:]
            uf_folder = xls_file.split("/")[-1].split("-")[1][:2]
            filename = xls_file.split("/")[-1].split("-")[0]

        if uf_folder == "P1":
            uf_folder = "SP1"
        if uf_folder == "P2":
            uf_folder = "SP2"

        save_folder = file_table_reference[filename.lower()]

        file_path = "/".join(xls_file.split("/")[:-1])
        rename_file = f"{file_path}/{filename.lower()}_{uf_folder.lower()}.xls"

        os.rename(xls_file, rename_file)
        xls_file = rename_file

        delete_file = f"{datasets_path}/{save_folder.lower()}/{filename.lower()}_{uf_folder.lower()}.xls"
        if os.path.exists(delete_file):
            os.remove(delete_file)

        shutil.move(xls_file, f"{datasets_path}/{save_folder}")
