
# Manual de qualidade de dados

Nessa seção listamos todos os padrões e critérios do nosso manual de qualidade de dados que usamos na [Base dos Dados](https://basedosdados.org). 

 A qualidade dos dados é fundamental para garantir que as informações coletadas e armazenadas sejam precisas, confiáveis e relevantes para a tomada de decisões. Para avaliar a qualidade dos dados, é importante considerar diversos critérios, que englobam aspectos como consistência, precisão, completude, confiabilidade, integridade, padronização e tempo. Cada conjunto de dados pode ter critérios específicos de qualidade, e a seleção dos critérios a serem avaliados dependerá do contexto e das necessidades da aplicação em questão. Este documento tem como objetivo apresentar os **principais** critérios de qualidade de dados utilizados em nossa instituição, bem como detalhar os processos de avaliação e monitoramento desses critérios.

O processo de qualidade de dados visa garantir que os dados utilizados estejam corretos, atualizados e bem documentados. Para isso, foram definidos três grandes critérios de qualidade: **Qualidade**, **Atualização** e **Documentação**.

!!! Tip "Você pode usar o menu esquerdo para navegar pelos diferentes tópicos dessa página."
<!-- **Resumo**:

- [Critérios de Qualidade](#criterios-de-qualidade)
- [Qualidade](#qualidade)
- [Atualização](#atualização)
- [Documentação](#documentação) -->

---

# Critérios de Qualidade

## Qualidade

Esse critério avalia se os dados são consistentes em diferentes fontes e sistemas, bem como se há inconsistências internas nos próprios dados, como valores inválidos ou incoerentes. Por exemplo, pode-se verificar se os dados coletados em diferentes momentos ou sistemas estão em concordância, ou se existem discrepâncias que precisam ser investigadas. A consistência dos dados é fundamental para garantir a integridade e a confiabilidade das informações. Para isso, os seguintes pontos devem ser verificados:

- Checar o tipo das colunas (comparar com a tabela de arquitetura).
- Checar existência de colunas nulas.
- Checar o número de linhas com a fonte original.
- Checar colunas iguais no BigQuery e no site.
- Checar colunas com link nos diretórios.
- Materializar todas as tabelas.

#### Checar o tipo das colunas
Para garantir a qualidade dos dados, é importante que as colunas estejam com o tipo correto. Para isso, é necessário comparar com a tabela de arquitetura e verificar se todas as colunas estão no tipo esperado.

#### Checar existência de colunas nulas
Outro ponto importante é verificar se existem colunas com valores nulos. Essa informação deve ser tratada de forma adequada, seja preenchendo os valores faltantes ou removendo as linhas.

#### Checar o número de linhas com a fonte original
Para garantir que os dados estejam corretos, é necessário verificar se o número de linhas na tabela está de acordo com o número de linhas da fonte original.

#### Checar colunas iguais no BigQuery e no site
É importante verificar se as colunas presentes no BigQuery estão iguais às do site. Isso pode evitar problemas na hora de realizar a análise dos dados.

#### Checar colunas com link nos diretórios
Para garantir a qualidade dos dados, é importante verificar se todas as colunas que deveriam ter um link nos diretórios estão com o link correto.

#### Materializar todas as tabelas
Para garantir que os dados estejam corretos e bem estruturados, é importante materializar todas as tabelas, ou seja, criar uma cópia dos dados em um novo arquivo.

## Atualização
A avaliação temporal dos dados se refere à sua atualização e à sua relevância para a tomada de decisões. É importante que os dados sejam atualizados regularmente e que estejam disponíveis para uso em tempo hábil. Dados desatualizados podem levar a análises inadequadas e decisões baseadas em informações obsoletas. Para isso, os seguintes pontos devem ser verificados:

- Atualização dos dados.
- Atualização dos dicionários.

#### Atualização dos dados para a data mais recente
É importante manter os dados atualizados para garantir a qualidade das análises. Portanto, é necessário verificar se os dados estão atualizados para a data mais recente disponível.

#### Atualização dos dicionários
Os dicionários são importantes para entender os dados e como eles estão estruturados. Por isso, é importante verificar se eles estão atualizados.


# Documentação

A confiabilidade dos dados se refere à fonte dos dados e à sua veracidade. Para avaliar a confiabilidade dos dados, pode-se verificar se a fonte é confiável e se as informações são corroboradas por outras fontes independentes. Dados de fontes não confiáveis ou que não foram verificados podem levar a análises errôneas e decisões incorretas. O critério de documentação têm como objetivo garantir que os dados estejam bem documentados. Para isso, os seguintes pontos devem ser verificados:

**(Terminar de escrever e detalhar aqui)**
- Disponibilizar arquitetura ao usuário.
- Incluir auxiliary files para todos os conjuntos.
- Revisar e comentar código de tratamento.
- Revisar o `README`.


## **Pensou em melhorias para os padrões definidos?**

Abra um [issue no nosso Github](https://github.com/basedosdados/mais/labels/docs) ou mande uma mensagem no [Discord](https://discord.gg/huKWpsVYx4) para conversarmos :)
