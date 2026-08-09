-- Quais os 10 países que mais geram receita?
SELECT
    i.billing_country,
    ROUND(SUM(i.total), 2) AS receita_total,
    COUNT(DISTINCT i.invoice_id) AS total_vendas
FROM invoice i
GROUP BY i.billing_country
ORDER BY receita_total DESC
LIMIT 10;


-- Qual gênero musical vende mais faixas (em quantidade)?
SELECT
    g.name AS genero,
    COUNT(il.invoice_line_id) AS faixas_vendidas,
    ROUND(SUM(il.unit_price * il.quantity), 2) AS receita_total
FROM invoice_line il
JOIN track t ON t.track_id = il.track_id
JOIN genre g ON g.genre_id = t.genre_id
GROUP BY g.name
ORDER BY faixas_vendidas DESC;


-- Quais artistas têm mais álbuns cadastrados?
SELECT
    ar.name AS artista,
    COUNT(al.album_id) AS total_albuns
FROM artist ar
JOIN album al ON al.artist_id = ar.artist_id
GROUP BY ar.name
ORDER BY total_albuns DESC
LIMIT 10;


-- Qual o faturamento total por funcionário (via cliente atendido)?
SELECT
    e.first_name || ' ' || e.last_name AS funcionario,
    ROUND(SUM(i.total), 2) AS receita_gerada
FROM employee e
JOIN customer c ON c.support_rep_id = e.employee_id
JOIN invoice i ON i.customer_id = c.customer_id
GROUP BY funcionario
ORDER BY receita_gerada DESC;


-- Quais clientes fizeram mais de 5 compras (faturas)?
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(i.invoice_id) AS total_compras
FROM customer c
JOIN invoice i ON i.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(i.invoice_id) > 5
ORDER BY total_compras DESC;


-- Existe algum álbum sem nenhuma faixa vendida? (LEFT JOIN)
SELECT
    al.title AS album,
    COUNT(il.invoice_line_id) AS vendas
FROM album al
LEFT JOIN track t ON t.album_id = al.album_id
LEFT JOIN invoice_line il ON il.track_id = t.track_id
GROUP BY al.title
HAVING COUNT(il.invoice_line_id) = 0;
