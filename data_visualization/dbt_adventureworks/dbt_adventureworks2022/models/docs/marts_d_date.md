{% docs marts_d_date %}

# 📅 Dimensão de Datas

A tabela **marts_d_date** é uma dimensão analítica de calendário utilizada como referência temporal para as análises de vendas do projeto.

Seu objetivo é centralizar atributos relacionados às datas, facilitando análises temporais e permitindo que as métricas sejam avaliadas por mês e ano.

*O resultado é uma tabela preparada para responder perguntas como:*

- Como as vendas evoluíram ao longo dos meses?
- Qual mês apresentou o maior volume de vendas?
- Como foi o desempenho das vendas em 2013 comparado com 2014?
- Em qual período do ano ocorreram mais vendas?
- Qual foi a evolução mensal ou anual do faturamento?
- Existem períodos de crescimento ou queda nas vendas?
- Qual foi o melhor mês de cada ano?
- Como comparar o desempenho de janeiro de 2013 com janeiro de 2014?

*Essa dimensão também serve como uma base de relacionamento temporal com a tabela de fatos de vendas, permitindo analisar métricas como faturamento, quantidade vendida e lucro ao longo do tempo. A dimensão contempla o período correspondente aos anos de **2013 e 2014**.

---

## 🧱 Estrutura da Tabela

| Coluna | Descrição |
|---|---|
| `data_id` | Identificador único da data. |
| `data` | Data completa correspondente ao registro. |
| `mes_nome` | Nome do mês em inglês. |
| `mes` | Número correspondente ao mês do calendário. |
| `ano` | Ano correspondente à data. |

---

## 🔗 Utilização no Modelo Analítico

A dimensão **marts_d_date** pode ser utilizada como referência temporal pelas tabelas fato do modelo analítico.

O relacionamento é realizado por meio da chave:

`marts_d_date.data_id`

permitindo associar os eventos de vendas às respectivas informações de calendário.

---

## 🧪 Qualidade dos Dados

Foram definidos testes de qualidade para garantir a integridade da dimensão.

### `data_id`

A chave da dimensão deve atender aos seguintes critérios:

- não pode possuir valores nulos
- deve possuir valores únicos

### `data`

O campo de data completa não pode possuir valores nulos.

### `ano`

O campo `ano` não pode possuir valores nulos e está restrito aos valores:

- `2012`
- `2013`

Essas validações garantem consistência na utilização da dimensão como referência temporal para o modelo analítico.

---

## 🏗️ Camada Analítica

*A tabela pertence à camada **Marts**, representando um modelo final preparado para consumo analítico e integração com ferramentas de Business Intelligence. Sua estrutura foi projetada para facilitar consultas e relacionamentos com tabelas fato, especialmente em análises de vendas realizadas no Power BI.*

{% enddocs %}