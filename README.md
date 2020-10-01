# A Base dos Dados  🗂️

O intuito do projeto é organizar e facilitar o acesso a dados brasileiros através de tabelas públicas no BigQuery.
Qualquer pessoa poderá fazer queries em bases tratadas e documentadas que estarão disponíveis e estáveis.

Uma simples consulta de SQL será o suficiente para cruzamento de bases que você desejar. Sem precisar procurar, baixar, tratar, comprar um servidor e subir clusters.

## Instale nosso CLI

`pip install basedosdados

**Incentivamos que outras instituições e pessoas contribuam**. Só é requerido que o processo de captura e tratamento sejam públicos e documentados, e a inserção dos dados no BigQuery siga nossa metodologia descrita abaixo.

#### Porque o BigQuery?

Sabemos que estruturar os dados em uma plataforma privada não é o ideal para um projeto de dados abertos. Porém o BigQuery oferece uma infraestrutura com algumas vantagens:

- É possível deixar os dados públicos, i.e., qualquer pessoa com uma conta no Google Cloud pode fazer uma query na base, quando quiser
- O usuário (quem faz a query) paga por ela. Isso deixa os custos do projeto bem baixos
- O BigQuery escala magicamente para hexabytes se necessário
- O custo é praticamente zero para usuários. São cobrados somente 5 dólares por terabyte de dados que sua query percorrer, e os primeiros 5 terabytes são gratuitos.

### Desenvolvimento

#### CLI

Suba o CLI localmente

```sh
make create-env
. .bases/bin/activate
```

#### Versionamento

Publique nova versão

```sh
poetry version [patch|minor|major]
poetry publish --build
```

#### Docs
Atualize os docs adicionando ou editando `.md` em `docs/`.

Se for adicionar um arquivo novo, adicione ele em `mkdocs.yml` sob a chave `nav`.

Para testar a documentação, rode:

```sh
mkdocs serve 
```

