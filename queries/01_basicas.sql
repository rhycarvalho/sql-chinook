-- Quais são os 10 clientes que mais gastaram (maior total de faturas)?
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.country,
    i.total
FROM customer c
JOIN invoice i ON i.customer_id = c.customer_id
ORDER BY i.total DESC
LIMIT 10;


-- Quais faixas (tracks) custam mais de $0.99?
SELECT
    track_id,
    name,
    unit_price
FROM track
WHERE unit_price > 0.99
ORDER BY unit_price DESC;


-- Quantos clientes existem por país?
SELECT
    country,
    COUNT(*) AS total_clientes
FROM customer
GROUP BY country
ORDER BY total_clientes DESC;


-- Quais são os 5 álbuns com mais faixas?
SELECT
    al.title AS album,
    COUNT(t.track_id) AS total_faixas
FROM album al
JOIN track t ON t.album_id = al.album_id
GROUP BY al.title
ORDER BY total_faixas DESC
LIMIT 5;


-- Liste todos os clientes do Brasil
SELECT
    customer_id,
    first_name,
    last_name,
    city,
    email
FROM customer
WHERE country = 'Brazil'
ORDER BY last_name;
