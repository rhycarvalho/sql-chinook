-- View 1: Resumo de vendas por país (receita, nº de vendas, ticket médio)
CREATE OR REPLACE VIEW vw_resumo_vendas_pais AS
SELECT
    i.billing_country AS pais,
    COUNT(DISTINCT i.invoice_id) AS total_vendas,
    ROUND(SUM(i.total), 2) AS receita_total,
    ROUND(AVG(i.total), 2) AS ticket_medio
FROM invoice i
GROUP BY i.billing_country;

-- Consultar a view:
SELECT * FROM vw_resumo_vendas_pais ORDER BY receita_total DESC;


-- View 2: Desempenho de vendas por gênero musical
CREATE OR REPLACE VIEW vw_desempenho_genero AS
SELECT
    g.name AS genero,
    COUNT(il.invoice_line_id) AS faixas_vendidas,
    ROUND(SUM(il.unit_price * il.quantity), 2) AS receita_total
FROM invoice_line il
JOIN track t ON t.track_id = il.track_id
JOIN genre g ON g.genre_id = t.genre_id
GROUP BY g.name;

-- Consultar a view:
SELECT * FROM vw_desempenho_genero ORDER BY receita_total DESC;


-- View 3: Perfil de gasto por cliente (para uso em dashboards, ex: Power BI)
CREATE OR REPLACE VIEW vw_perfil_cliente AS
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS nome_cliente,
    c.country,
    COUNT(i.invoice_id) AS total_compras,
    ROUND(SUM(i.total), 2) AS total_gasto,
    ROUND(AVG(i.total), 2) AS ticket_medio
FROM customer c
JOIN invoice i ON i.customer_id = c.customer_id
GROUP BY c.customer_id, nome_cliente, c.country;

-- Consultar a view:
SELECT * FROM vw_perfil_cliente ORDER BY total_gasto DESC;
