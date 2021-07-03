__all__ = [
    'constants'
]

# Decorator for making immutable attributes on classes


def const(cls):
    def is_special(name): return (
        name.startswith("__") and name.endswith("__"))
    class_contents = {n: getattr(cls, n)
                      for n in vars(cls) if not is_special(n)}

    def unbind(value):
        return lambda self: value
    propertified_contents = {
        name: property(unbind(value)) for (name, value) in class_contents.items()
    }
    receptor = type(cls.__name__, (object,), propertified_contents)
    return receptor()

# Declare new constants here


@const
class constants (object):
    env_config: str = "BASEDOSDADOS_CONFIG"
    env_credentials_prefix: str = "BASEDOSDADOS_CREDENTIALS_"
    env_credentials_prod: str = "BASEDOSDADOS_CREDENTIALS_PROD"
    env_credentials_staging: str = "BASEDOSDADOS_CREDENTIALS_STAGING"
