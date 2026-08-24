{% docs marts_d_clientes %}

# 👤 Dimensão de Clientes

A `marts_d_clientes` representa a dimensão de clientes do modelo analítico do AdventureWorksDW2022.

Seu objetivo é disponibilizar os principais atributos cadastrais dos clientes para análises de vendas, comportamento e segmentação.

---

## 🎯 Objetivo

Centralizar as informações descritivas dos clientes utilizadas pelas
análises do modelo dimensional.

**O resultado é uma tabela preparada para responder perguntas como:**

- Qual é a quantidade de clientes por estado?
- Em quais países ou regiões estão concentrados os clientes?
- Qual é a distribuição de clientes por gênero?
- Quantos clientes são casados ou solteiros?
- Qual estado possui a maior quantidade de clientes?
- Qual é o perfil demográfico dos clientes por localização?
- Existe diferença na concentração de clientes entre homens e mulheres em cada estado?
- Como os clientes estão distribuídos geograficamente para análises comerciais e de vendas?

*Essas informações podem ser utilizadas no Power BI para criar segmentações, gráficos de distribuição geográfica, análises demográficas e cruzamentos com a tabela de vendas.*


---

## 🧱 Estrutura da Tabela

| Coluna | Descrição |
|---|---|
| `customer_id` | Identificador único do cliente no modelo analítico |
| `customer_id_alternativo` | Identificador alternativo do cliente |
| `nome` | Primeiro nome do cliente |
| `nome_meio` | Nome do meio |
| `sobrenome` | Sobrenome |
| `estado_civil` | Estado civil |
| `genero` | Gênero |

---

## 🔗 Relacionamentos

A dimensão `marts_d_clientes` é relacionada às tabelas fato por meio do identificador do cliente.

Principal relacionamento:

`dim_customer.customer_id` → `fct_internet_sales.customer_id`

Esse relacionamento permite analisar métricas de vendas sob a
perspectiva dos clientes.

---

## 🧪 Qualidade dos Dados

A dimensão possui testes de qualidade definidos no dbt para garantir a integridade dos dados.

Entre as validações estão:

- unicidade da chave do cliente
- valores não nulos
- integridade dos relacionamentos

{% enddocs %}