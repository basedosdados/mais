"""
Settings for the project.
"""

from pathlib import Path

URL_CGU_DOWNLOADS = "http://www.portaltransparencia.gov.br/download-de-dados/servidores"
CGU_FILES = {
    "militar": {"ativo": ["Militares"], "reservista": ["Reserva_Reforma_Militares"]},
    "civil": {
        "ativo": ["Servidores_BACEN", "Servidores_SIAPE"],
        "inativo": ["Aposentados_BACEN", "Aposentados_SIAPE"],
    },
}

TMP_DIR = Path.cwd().resolve().parent / "tmp"
IN_DIR = Path.cwd().resolve().parent / "input"
OUT_DIR = Path.cwd().resolve().parent / "output"

REMUNERACAO_MILITARES_COLUMNS = [
    "ano",
    "mes",
    "id_servidor_portal",
    "cpf",
    "nome",
    "remuneracao_bruta_brl",
    "remuneracao_bruta_usd",
    "abate_teto_brl",
    "abate_teto_usd",
    "gratificao_natalina_brl",
    "gratificao_natalina_usd",
    "abate_teto_gratificacao_natalina_brl",
    "abate_teto_gratificacao_natalina_usd",
    "ferias_brl",
    "ferias_usd",
    "outras_remuneracoes_brl",
    "outras_remuneracoes_usd",
    "irrf_brl",
    "irrf_usd",
    "pss_rgps_brl",
    "pss_rgps_usd",
    "demais_deducoes_brl",
    "demais_deducoes_usd",
    "pensao_militar_brl",
    "pensao_militar_usd",
    "fundo_saude_brl",
    "fundo_saude_usd",
    "taxa_ocupacao_imovel_funcional_brl",
    "taxa_ocupacao_imovel_funcional_usd",
    "remuneracao_liquida_militar_brl",
    "remuneracao_liquida_militar_usd",
    "verba_indenizatoria_civil_brl",
    "verba_indenizatoria_civil_usd",
    "verba_indenizatoria_militar_brl",
    "verba_indenizatoria_militar_usd",
    "verba_indenizatoria_deslig_voluntario_brl",
    "verba_indenizatoria_deslig_voluntario_usd",
    "total_verba_indenizatoria_brl",
    "total_verba_indenizatoria_usd",
]
