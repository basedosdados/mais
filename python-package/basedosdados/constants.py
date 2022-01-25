__all__ = ["constants"]

from enum import Enum
from loguru import logger


@dataclass
class config:
    verbose: bool = True
    billing_project_id: str = None
    project_config_path: str = None

    def __new__(self):
        logger.remove(0) # remove o default handler
        logger_level = 'INFO' if self.verbose else 'ERROR'
        logger.add(sys.stderr, format="<level>{message}</level>", level=logger_level)


class constants(Enum):
    ENV_CONFIG: str = "BASEDOSDADOS_CONFIG"
    ENV_CREDENTIALS_PREFIX: str = "BASEDOSDADOS_CREDENTIALS_"
    ENV_CREDENTIALS_PROD: str = "BASEDOSDADOS_CREDENTIALS_PROD"
    ENV_CREDENTIALS_STAGING: str = "BASEDOSDADOS_CREDENTIALS_STAGING"
