# ETL de dados sobre servidores do executivo federal

Este código baixa dados sobre servidores do poder executivo federal do
[Portal da Transparência](http://portaltransparencia.gov.br/), os processa
para que eles estejam num formato compatível com o requisitado pelo BigQuery
e sobe os arquivos para o Google Storage.

### Instruções rápidas

O script `servidores.py` pode ser rodado em 3 modos:

* download;
* clean;
* upload.

Para mais informações, execute o script sem argumentos:

    servidores.py

**PS:** O comando `upload` está 'hard-coded' para fazer o upload para
o Google Storage do Gabinete Compartilhado Acredito, mas ele pode ser
modificado para outro projeto.

### Autores

Cristiano Froes - <https://github.com/CristianoFroes> 

Henrique Xavier - <https://github.com/hsxavier>       
