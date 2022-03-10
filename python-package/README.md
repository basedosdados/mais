# Python Package

## Desenvolvimento

### Linux e Mac:

Clone o repositório principal:

```sh
git clone https://github.com/basedosdados/mais.git
```
Entre na pasta local do repositório usando `cd mais/` e suba o ambiente localmente:

```sh
make create-env
. .mais/bin/activate
cd python-package/
python setup.py develop
```

#### Desenvolva uma nova feature

1. Abra uma branch com o nome issue-<X>
2. Faça as modificações necessárias
3. Suba o Pull Request apontando para a branch `python-next-minor` ou `python-next-patch`. 
  Sendo, minor e patch referentes ao bump da versão: v1.5.7 --> v\<major>.\<minor>.\<patch>.
4. O nome do PR deve seguir o padrão
  `[infra] <titulo explicativo>`

#### O que uma modificação precisa ter
  
- Resolver o problema
- Lista de modificações efetuadas
    1. Mudei a função X para fazer Y
    2. Troquei o nome da variavel Z
- Referência aos issues atendidos
- Documentação e Docstrings
- Testes
  
#### Versionamento

Publique nova versão

```sh
poetry version [patch|minor|major]
poetry publish --build
```
