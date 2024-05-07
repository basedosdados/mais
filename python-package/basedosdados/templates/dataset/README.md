Como capturar os dados de {{ dataset_id }}?

1. Para capturar esses dados, basta verificar o link dos dados originais indicado em `dataset_config.yaml` no item `website`.

2. Caso tenha sido utilizado algum código de captura ou tratamento, estes estarão contidos em `code/`. Se o dado publicado for em sua versão bruta, não existirá a pasta `code/`.

Os dados publicados estão disponíveis em: https://basedosdados.org/dataset/{{ dataset_id | replace("_","-") }}
