-- Ranking de funcionários por receita gerada
SELECT
    e.first_name || ' ' || e.last_name AS funcionario,
    ROUND(SUM(i.total), 2) AS receita_total,
    RANK() OVER (ORDER BY SUM(i.total) DESC) AS ranking
FROM employee e
JOIN customer c ON c.support_rep_id = e.employee_id
JOIN invoice i ON i.customer_id = c.customer_id
GROUP BY funcionario
ORDER BY ranking;


-- Top 3 clientes que mais gastaram, por país (RANK particionado)
WITH gastos AS (
    SELECT
        c.country,
        c.first_name,
        c.last_name,
        SUM(i.total) AS total_gasto
    FROM customer c
    JOIN invoice i ON i.customer_id = c.customer_id
    GROUP BY c.country, c.first_name, c.last_name
),
ranking AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY country ORDER BY total_gasto DESC) AS posicao
    FROM gastos
)
SELECT country, first_name, last_name, ROUND(total_gasto, 2) AS total_gasto, posicao
FROM ranking
WHERE posicao <= 3
ORDER BY country, posicao;


-- Receita mensal e receita acumulada (running total) ao longo do tempo
WITH receita_mensal AS (
    SELECT
        DATE_TRUNC('month', invoice_date)::date AS mes,
        SUM(total) AS receita_do_mes
    FROM invoice
    GROUP BY DATE_TRUNC('month', invoice_date)
)
SELECT
    mes,
    ROUND(receita_do_mes, 2) AS receita_do_mes,
    ROUND(SUM(receita_do_mes) OVER (ORDER BY mes), 2) AS receita_acumulada
FROM receita_mensal
ORDER BY mes;


-- Variação de receita mês a mês (LAG)
WITH receita_mensal AS (
    SELECT
        DATE_TRUNC('month', invoice_date)::date AS mes,
        SUM(total) AS receita_do_mes
    FROM invoice
    GROUP BY DATE_TRUNC('month', invoice_date)
)
SELECT
    mes,
    ROUND(receita_do_mes, 2) AS receita_atual,
    ROUND(LAG(receita_do_mes) OVER (ORDER BY mes), 2) AS receita_mes_anterior,
    ROUND(receita_do_mes - LAG(receita_do_mes) OVER (ORDER BY mes), 2) AS variacao
FROM receita_mensal
ORDER BY mes;


-- Numerar as compras de cada cliente em ordem cronológica (ROW_NUMBER)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    i.invoice_date,
    i.total,
    ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY i.invoice_date) AS numero_da_compra
FROM customer c
JOIN invoice i ON i.customer_id = c.customer_id
ORDER BY c.customer_id, numero_da_compra;
