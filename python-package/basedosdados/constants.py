__all__ = ["config", "constants"]

from enum import Enum
from dataclasses import dataclass


@dataclass
class config:
    verbose: bool = True
    billing_project_id: str = None
    project_config_path: str = None
    from_file: bool = False


class constants(Enum):
    ENV_CONFIG: str = "BASEDOSDADOS_CONFIG"
    ENV_CREDENTIALS_PREFIX: str = "BASEDOSDADOS_CREDENTIALS_"
    ENV_CREDENTIALS_PROD: str = "BASEDOSDADOS_CREDENTIALS_PROD"
    ENV_CREDENTIALS_STAGING: str = "BASEDOSDADOS_CREDENTIALS_STAGING"
