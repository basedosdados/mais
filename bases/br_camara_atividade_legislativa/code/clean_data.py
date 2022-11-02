import os
import pandas as pd


INPUT_PATH = "../input/"
OUTPUT_PATH = "../output/"


def get_clean_data():
    df = get_df()
    df = clean_data(df)
    df.to_csv(OUTPUT_PATH + "evento.csv", index=False)

def get_df():
    csv_files = sorted(os.listdir(INPUT_PATH))
    csv_files = [INPUT_PATH + x for x in csv_files]

    dfs = map(lambda x: pd.read_csv(x, sep=";"), csv_files)
    df = pd.concat(dfs, axis=0)

    return df
    
def clean_data(df: pd.DataFrame):

    ################
    # Drop Columns #
    ################

    df = df.drop(
                columns=["localCamara.predio", "localCamara.sala", "localCamara.andar",
                                                                                "uri"] 
            )


    #################################
    # Rename and insert new columns #
    #################################

    # Rename
    df = df.rename(columns={
            "id": "id_evento",
            "urlDocumentoPauta": "link_pauta",
            "dataHoraInicio": "data_inicio",
            "dataHoraFim": "data_fim",
            "situacao": "situacao",
            "descricaoTipo": "tipo",
            "descricao": "descricao",
            "localExterno": "local_externo",
            "localCamara.nome": "local"
        })

    # Insert
    df["hora_inicio"] = None
    df["hora_fim"] = None
    df["externo"] = None


    #############
    # Fix dates #
    #############

    df["hora_inicio"] = pd.to_datetime(df["data_inicio"]).dt.time
    df["data_inicio"] = pd.to_datetime(df["data_inicio"]).dt.date

    df["hora_fim"] = pd.to_datetime(df["data_fim"]).dt.time
    df["data_fim"] = pd.to_datetime(df["data_fim"]).dt.date


    ##################
    # Label encoding #
    ##################

    situacao_mapping = [
        "Encerrada",
        "Encerrada (Final)",
        "Encerrada (Termo)",
        "Encerrada(Comunicado)",
        "Suspensa",
        "Cancelada"
    ]
    tipo_mapping = [
        "Reunião Deliberativa",
        "Audiência Pública",
        "Sessão Deliberativa",
        "Outro Evento",
        "Seminário",
        "Reunião de Instalação e Eleição",
        "Sessão Não Deliberativa de Debates",
        "Sessão Não Deliberativa Solene",
        "Sessão de Debates",
        "Sessão Solene",
        "Reunião Técnica",
        "Reunião",
        "Mesa Redonda",
        "Reunião de Eleição",
        "Trabalho de Comissões",
        "Reunião de Debate",
        "Diligência",
        "Palestra",
        "Comissão Geral",
        "Evento Técnico",
        "Audiência Pública e Deliberação",
        "Reunião de Comparecimento de Ministro",
        "Debate",
        "Painel",
        "Reunião de Instalação",
        "Visita Técnica",
        "Conferência",
        "Simpósio",
        "Ato Solene de Instalação",
        "Sessão Preparatória - Eleição",
        "Teste do Painel Eletrônico",
        "Sessão Preparatória - Posse",
        "Visita Oficial",
        "Sessão de Eleição"
    ]

    assert len(situacao_mapping) == len(df["situacao"].unique())
    assert len(tipo_mapping) == len(df["tipo"].unique())

    # Map each value to its position in list
    situacao_mapping = {key: value for value, key in enumerate(situacao_mapping)}
    tipo_mapping = {key: value for value, key in enumerate(tipo_mapping)}

    df["situacao"] = df["situacao"].replace(situacao_mapping)
    df["tipo"] = df["tipo"].replace(tipo_mapping)

    
    ########################################
    # Merge local_externo and local_camara #
    ########################################

    df["externo"] = df["local_externo"].fillna(False).astype("bool")
    df.loc[df["local_externo"].isna(), "externo"] = False

    # 'local_externo' if 'externo' else 'local' 
    df["local"] = df[["local", "local_externo", "externo"]]\
                    .apply(lambda x: x[1] if x[2] else x[0], axis=1)
    
    df.drop("local_externo", axis=1, inplace=True)

    ###################
    # Reorder columns #
    ###################
    col_order = [
            "id_evento",
            "data_inicio",
            "hora_inicio",
            "data_fim",
            "hora_fim",
            "link_pauta",
            "descricao",
            "situacao",
            "tipo",
            "externo",
            "local"
        ]
    assert len(df.columns) == len(col_order)
    df = df[col_order]

    return df

if __name__ == "__main__":
    get_clean_data()
