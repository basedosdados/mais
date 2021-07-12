__all__ = [
    'constants'
]

from enum import Enum


class constants (Enum):
    env_config: str = "BASEDOSDADOS_CONFIG"
    env_credentials_prefix: str = "BASEDOSDADOS_CREDENTIALS_"
    env_credentials_prod: str = "BASEDOSDADOS_CREDENTIALS_PROD"
    env_credentials_staging: str = "BASEDOSDADOS_CREDENTIALS_STAGING"
