# Colaborando com dados na BD+

Estamos criando um repositório integrado de dados no Brasil. O desafio é grande: passa por subir bases de dados de centenas de fontes, mas também mantê-las consistentes entre si, atualizadas, e úteis.

Para chegar lá, criamos uma **priorização de bases** e um **fluxo de trabalho**.

## Priorizando bases

Se queremos sistematizar o universo de dados no Brasil, então precisamos começar de algum lugar. Para nos guiar, criamos e alimentamos uma tabela para mapear e priorizar bases de dados. Escolhemos em qual próxima base trabalhar baseado no nosso _índice de prioridade_.

<div align="center">
    <a align="center"
    href="https://docs.google.com/spreadsheets/d/1jnmmG4V6Ugh_-lhVSMIVu_EaL05y1dX9Y0YW8G8e_Wo/edit?usp=sharing"
    title="{{ lang.t('source.link.title')}}" class="md-button">
        Tabela de prioridades
    </a>
</div>

## Fluxo de trabalho

Adicionar bases novas na BD+ deve seguir nosso fluxo de trabalho:

1. Adicionar linhas referentes à base na [tabela de prioridades](https://docs.google.com/spreadsheets/d/1jnmmG4V6Ugh_-lhVSMIVu_EaL05y1dX9Y0YW8G8e_Wo/edit?usp=sharing).
    - Preencher todos os campos cuidadosamente.
    - Incluir uma linha por tabela do conjunto de dados.
2. Marcar seu usuário do Github na coluna "pessoa responsável" para aquela base.
3. Criar um issue no nosso [Github](https://github.com/basedosdados/mais).
    - Título: "Dados: Base &lt;dataset_id.table_id&gt;"
4. Baixar os dados originais.
    - Idealmente feito de forma automatizada por _scripts_.
    - Organizar dados em uma pasta `/input` com atalho relativo à pasta raiz incluindo o código.
5. [Limpar os dados](/data_clean).
6. [Subir os dados](/data_upload) no BigQuery.
7. Enviar o código e dados prontos para revisão.
8. Depois da revisão e publicação dos dados, dar um _check_ na linha referente a essa base na [tabela de prioridades](https://docs.google.com/spreadsheets/d/1jnmmG4V6Ugh_-lhVSMIVu_EaL05y1dX9Y0YW8G8e_Wo/edit?usp=sharing).
