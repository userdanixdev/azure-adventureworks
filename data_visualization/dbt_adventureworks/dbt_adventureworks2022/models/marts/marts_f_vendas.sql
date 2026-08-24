WITH vendas AS (
    SELECT
        pedido_id,
        data_pedido_id,
        produto_id,
        cliente_id,
        valor_venda,
        custo_padrao_produto,
        quantidade,
        valor_frete,
        valor_imposto
    FROM {{ ref('stg_fact_internet_sales') }}
),
datas AS (
    SELECT
        data_id
    FROM {{ ref('stg_dim_date') }}
),
produtos AS (
    SELECT
        produto_id
    FROM {{ ref('stg_dim_product') }}
),
clientes AS (
    SELECT
        cliente_id
    FROM {{ ref('stg_dim_customer') }}
)
SELECT
    v.pedido_id AS venda_id,
    d.data_id,
    p.produto_id,
    c.cliente_id,
    v.valor_venda AS receita,
    (
        v.custo_padrao_produto * v.quantidade
    ) AS custo_produto,
    v.valor_frete AS frete,
    v.valor_imposto AS imposto,
    (
        v.valor_venda
        - (v.custo_padrao_produto * v.quantidade)
    ) AS lucro_bruto,
    (
        v.valor_venda
        - (v.custo_padrao_produto * v.quantidade)
        - v.valor_frete
        - v.valor_imposto
    ) AS lucro_apos_frete_imposto,
    v.quantidade
FROM vendas AS v

INNER JOIN datas AS d
    ON v.data_pedido_id = d.data_id
INNER JOIN produtos AS p
    ON v.produto_id = p.produto_id
INNER JOIN clientes AS c
    ON v.cliente_id = c.cliente_id



-- REGRAS DE NEGÓCIO — MÉTRICAS FINANCEIRAS
--
-- Nesta versão da Fact_Vendas, as métricas de custo e lucro
-- foram ajustadas para representar de forma mais adequada
-- o custo dos produtos vendidos e os diferentes níveis de
-- resultado financeiro da venda.
--
-- 1. CUSTO DO PRODUTO
--
-- A coluna ProductStandardCost representa o custo padrão
-- unitário do produto.
--
-- Como uma venda pode possuir mais de uma unidade do produto,
-- o custo total dos produtos vendidos é calculado multiplicando
-- o custo unitário pela quantidade comercializada:
--
--     Custo do Produto =
--         ProductStandardCost × OrderQuantity
--
-- No modelo staging:
--
--     custo_padrao_produto × quantidade
--
-- Esse valor representa o custo dos produtos associados à
-- respectiva linha da venda.
--
--
-- 2. FRETE
--
-- A coluna Freight representa o valor do frete associado
-- à venda.
--
-- O frete é mantido separadamente na Fact_Vendas para permitir
-- análises específicas sobre o impacto logístico nas vendas.
--
-- Dessa forma, ele não é incorporado ao custo do produto.
--
--
-- 3. IMPOSTO
--
-- A coluna TaxAmt representa o valor do imposto associado
-- à venda.
--
-- Assim como o frete, o imposto é mantido como uma métrica
-- independente para possibilitar análises tributárias e
-- financeiras.
--
--
-- 4. LUCRO BRUTO
--
-- O lucro bruto representa a diferença entre a receita obtida
-- com a venda e o custo dos produtos vendidos.
--
--     Lucro Bruto =
--         Receita - Custo do Produto
--
-- Portanto:
--
--     SalesAmount -
--     (ProductStandardCost × OrderQuantity)
--
-- Essa métrica permite avaliar o resultado da comercialização
-- dos produtos antes de considerar despesas adicionais como
-- frete e impostos.
--
--
-- 5. LUCRO APÓS FRETE E IMPOSTO
--
-- Além do custo dos produtos, uma venda também pode possuir
-- despesas relacionadas ao frete e à tributação.
--
-- Por isso, foi criada uma segunda métrica de resultado:
--
--     Lucro após Frete e Imposto =
--         Receita
--         - Custo do Produto
--         - Frete
--         - Imposto
--
-- Essa métrica representa um resultado financeiro mais
-- conservador, pois considera não apenas o custo dos produtos,
-- mas também os valores de frete e impostos associados à venda.
--
--
-- 6. DIFERENÇA ENTRE AS MÉTRICAS
--
-- A estrutura permite analisar a evolução financeira da venda:
--
--     Receita
--        ↓
--     - Custo do Produto
--        ↓
--     = Lucro Bruto
--        ↓
--     - Frete
--     - Imposto
--        ↓
--     = Lucro após Frete e Imposto
--
-- Dessa forma, as métricas ficam separadas e podem ser utilizadas
-- individualmente no Power BI, permitindo analisar:
--
--     • Receita total
--     • Custo dos produtos
--     • Lucro bruto
--     • Impacto do frete
--     • Impacto dos impostos
--     • Lucro após frete e impostos
--
-- Essa abordagem também evita tratar Frete e TaxAmt como se
-- fossem parte do custo de aquisição/fabricação do produto.
--
-- ============================================================    