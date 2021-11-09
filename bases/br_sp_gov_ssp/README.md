Como capturar os dados de br_sp_gov_ssp?

Todo o código usado na captura está em `code/`

- Instale os requirements utilizando o código: `pip install -r requirements.txt`
- A pasta `dados` é necessaria para uso de aquivos auxiliares e deve estar na mesma pasta do arquivos
- Para definir os anos a serem baixados basa definir o retorno da função `get_years`, que por default baixa os dados do ano atual
- Os dados serâo baixados para a pasta dados separados ano a ano
- Execute o script utilizando o comando: python `ssp_scrapy.py`

