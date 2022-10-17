"""
Settings for the project.
"""

from pathlib import Path

URL_CGU_DOWNLOADS = "http://www.portaltransparencia.gov.br/download-de-dados/servidores"
CGU_FILES = {
    "militares": {"ativos": ["Militares"], "inativos": ["Reserva_Reforma_Militares"]},
    "civis": {
        "ativos": ["Servidores_BACEN", "Servidores_SIAPE"],
        "inativos": ["Aposentados_BACEN", "Aposentados_SIAPE"],
    },
}

TMP_DIR = Path.cwd().resolve().parent / "tmp"
IN_DIR = Path.cwd().resolve().parent / "input"
