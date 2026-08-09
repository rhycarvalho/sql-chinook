-- Quais clientes gastaram acima da média geral de gastos por cliente?
-- (subquery no WHERE)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(SUM(i.total), 2) AS total_gasto
FROM customer c
JOIN invoice i ON i.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(i.total) > (
    SELECT AVG(total_por_cliente)
    FROM (
        SELECT SUM(total) AS total_por_cliente
        FROM invoice
        GROUP BY customer_id
    ) sub
)
ORDER BY total_gasto DESC;


-- Mesma análise acima, mas usando CTE (mais legível)
WITH gastos_por_cliente AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(i.total) AS total_gasto
    FROM customer c
    JOIN invoice i ON i.customer_id = c.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
media_geral AS (
    SELECT AVG(total_gasto) AS media FROM gastos_por_cliente
)
SELECT
    g.first_name,
    g.last_name,
    ROUND(g.total_gasto, 2) AS total_gasto,
    ROUND(m.media, 2) AS media_geral
FROM gastos_por_cliente g, media_geral m
WHERE g.total_gasto > m.media
ORDER BY g.total_gasto DESC;


-- Qual a faixa mais vendida de cada gênero? (CTE + subquery correlacionada)
WITH vendas_por_faixa AS (
    SELECT
        t.track_id,
        t.name AS faixa,
        g.name AS genero,
        COUNT(il.invoice_line_id) AS qtd_vendida
    FROM track t
    JOIN genre g ON g.genre_id = t.genre_id
    JOIN invoice_line il ON il.track_id = t.track_id
    GROUP BY t.track_id, t.name, g.name
)
SELECT genero, faixa, qtd_vendida
FROM vendas_por_faixa v
WHERE qtd_vendida = (
    SELECT MAX(qtd_vendida)
    FROM vendas_por_faixa
    WHERE genero = v.genero
)
ORDER BY qtd_vendida DESC;


-- Clientes que nunca compraram faixas do gênero "Rock" (NOT IN)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM customer c
WHERE c.customer_id NOT IN (
    SELECT DISTINCT i.customer_id
    FROM invoice i
    JOIN invoice_line il ON il.invoice_id = i.invoice_id
    JOIN track t ON t.track_id = il.track_id
    JOIN genre g ON g.genre_id = t.genre_id
    WHERE g.name = 'Rock'
);
