# Python Package

## Desenvolvimento Linux e Mac: 

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

### Desenvolva uma nova feature

1. Abra uma branch com o nome issue-<X>
2. Faça as modificações necessárias
3. Suba o Pull Request apontando para a branch `python-next-minor` ou `python-next-patch`. 
    Sendo, minor e patch referentes ao bump da versão: v1.5.7 --> v\<major>.\<minor>.\<patch>.
4. O nome do PR deve seguir o padrão
    `[infra] <titulo explicativo>`


### O que uma modificação precisa ter

  
- Resolver o problema
- Lista de modificações efetuadas
    1. Mudei a função X para fazer Y
    2. Troquei o nome da variavel Z
- Referência aos issues atendidos
- Documentação e Docstrings
- Testes
  

## Versionamento

**Para publicar uma nova versão do pacote é preciso seguir os seguintes passos:**

1. Fazer o pull da branch:

    ```bash
    git pull origin [python-version]
    ```
  
    Onde `[python-version]` é a branch da nova versão do pacote.

2. Se necessario adicionar novas dependências:
    ```bash
      poetry add <package-name>
    ```

3. Gerar novo `requirements-dev.txt` 

    ```bash
    poetry export -f requirements.txt --output requirements-dev.txt --without-hashes
    ```

4. Editar `pyproject.toml`:

    O arquivo `pyproject.toml` contém, entre outras informações, a versão do pacote em python da **BD**. Segue excerto do arquivo:

    ```toml
    description = "Organizar e facilitar o acesso a dados brasileiros através de tabelas públicas no BigQuery."
    homepage = "https://github.com/base-dos-dados/bases"
    license = "MIT"
    name = "basedosdados"
    packages = [
      {include = "basedosdados"},
    ]
    readme = "README.md"
    repository = "https://github.com/base-dos-dados/bases"
    version = "1.6.1-beta.2"
    ```
    
    O campo `version` deve ser alterado para o número da versão sendo lançada.

5. Push para branch:

    ```bash
    git push origin [python-version]
    ```

6. Publicação do pacote no PyPI (exige usuário e senha):

    Para publicar o pacote no PyPI, use:
    
    ```bash
    poetry version [python-version]
    poetry publish --build
    ```

7. Faz merge da branch para a master
8. Faz release usando a UI do GitHub
9. Atualizar versão do pacote usada internamente



