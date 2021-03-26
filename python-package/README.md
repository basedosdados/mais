# Python Package

## Desenvolvimento

#### CLI

Suba o CLI localmente

```sh
make create-env
. .mais/bin/activate
python setup.py develop
```

#### Versionamento

Publique nova versão

```sh
poetry version [patch|minor|major]
poetry publish --build
```