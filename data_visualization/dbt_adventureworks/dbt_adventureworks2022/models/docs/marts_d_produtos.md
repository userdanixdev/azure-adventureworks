{% docs marts_d_produtos %}

# 📦 Dimensão de Produtos

A tabela **marts_d_produtos** é uma dimensão analítica responsável por consolidar as principais informações relacionadas aos produtos comercializados.

O modelo integra informações do produto, seu modelo e sua classificação hierárquica, organizando os dados em **categoria** e **subcategoria** para facilitar análises comerciais e de vendas.

---

## 🎯 Objetivo

O resultado é uma tabela preparada para responder perguntas como:

- Quais são os produtos mais vendidos?
- Qual categoria gera mais vendas?
- Quais produtos pertencem a cada categoria?
- Qual subcategoria possui maior volume de vendas?
- Quais produtos apresentam melhor desempenho?
- Qual categoria possui a maior variedade de produtos?
- Como as vendas estão distribuídas entre categorias e subcategorias?
- Quais produtos contribuem mais para o faturamento?
- Qual categoria ou subcategoria deve receber maior atenção comercial?

*Além disso, essa dimensão pode ser relacionada à tabela fato de vendas através do ProductID, permitindo analisar métricas como quantidade vendida, faturamento, custo e desempenho dos produtos.*


---

## 🧱 Estrutura da Tabela

| Coluna | Descrição |
|---|---|
| `produto_id` | Identificador único do produto. |
| `produto` | Nome comercial do produto. |
| `modelo` | Nome do modelo associado ao produto. |
| `subcategoria` | Nome da subcategoria à qual o produto pertence. |
| `categoria` | Nome da categoria principal do produto. |

---
{% enddocs %}
