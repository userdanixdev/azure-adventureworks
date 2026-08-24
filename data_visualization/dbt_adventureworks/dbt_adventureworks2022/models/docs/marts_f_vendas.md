{% docs marts_f_vendas %}

# 💰 Fato de Vendas pela Internet

A tabela **marts_f_vendas** é a principal tabela fato do modelo analítico e contém as vendas realizadas por meio do canal de internet.

Cada registro representa uma **linha de produto pertencente a um pedido de venda**. Portanto, um mesmo pedido pode estar associado a múltiplos registros, caso possua mais de um produto.

---

## 🎯 Objetivo

Centralizar as métricas financeiras e quantitativas das vendas, permitindo análises relacionadas a:

- Qual foi a receita em 2013 e 2014?
- Qual produto vendeu mais?
- Qual cliente gerou mais receita?
- Qual categoria e subcategoria geraram maior receita?
- Qual produto apresentou maior lucro bruto?
- Quais produtos possuem maior rentabilidade?
- Qual cliente gerou maior lucro para o negócio?
- Qual foi o custo total dos produtos vendidos?
- Qual foi o impacto do frete sobre o resultado financeiro?
- Qual foi o valor total de impostos associados às vendas?
- Qual foi o lucro bruto por período?
- Qual foi o lucro após a dedução de frete e impostos?
- Qual período apresentou maior receita e maior rentabilidade?
- Como a receita evoluiu ao longo do tempo?
- Como o lucro bruto evoluiu ao longo dos meses e anos?
- Como o resultado financeiro se comportou após considerar custos, frete e impostos?
- Quais produtos possuem alta receita, mas baixa rentabilidade?
- Quais categorias apresentam melhor margem de lucro?
- Qual foi a quantidade total de produtos vendidos?
- Qual produto teve maior volume de vendas?
- Existe relação entre volume de vendas e lucratividade?
- Quais períodos apresentaram maior quantidade de produtos vendidos?
- Qual produto ou categoria concentra maior participação na receita total?

*A tabela fato é o ponto central para análises comerciais e pode ser relacionada às dimensões de **data**, **produto** e **cliente**.*

---

## 🧱 Granularidade da Tabela

A granularidade da **marts_f_vendas** é:

> **Uma linha de produto dentro de um pedido de venda realizado pela internet.**

Isso significa que:

```text
Pedido 1001
├── Produto A
├── Produto B
└── Produto C

{% enddocs %}