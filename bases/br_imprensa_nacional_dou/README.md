Como capturar os dados de br_imprensa_nacional_dou?

Um código em python que monitora a página do Diário Oficial da União, captura as matérias e as
armazena no formato JSON está disponível no repositório:

<https://github.com/gabinete-compartilhado-acredito/DOUTOR>

Os arquivos HTML correspondentes a cada matéria são armazenados sob a estratégia key-value pairs,
onde a key é uma tag de HTML e o value é o seu conteúdo. Algumas outras entradas (como link para
a matéria, data de captura, entre outras) também estão presentes em cada arquivo JSON (que
corresponde a uma matéria).