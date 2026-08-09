# Análise de Vendas - Chinook Database (SQL)

Esse é um projeto de estudo de SQL que fiz usando o banco de dados Chinook, rodando em PostgreSQL. O Chinook simula uma loja de música digital (tipo um iTunes), com dados de clientes, faturas, artistas, álbuns e faixas vendidas.

## Ferramentas

- PostgreSQL
- pgAdmin 4
- Banco: [Chinook Database](https://github.com/lerocha/chinook-database)

## Estrutura do banco

O modelo é relativamente simples de entender: um artista tem vários álbuns, cada álbum tem várias faixas, e cada faixa pode aparecer em vários itens de fatura (invoice_line). Cada fatura pertence a um cliente, que por sua vez é atendido por um funcionário.

```
artist -> album -> track -> invoice_line -> invoice -> customer -> employee
                      |
                    genre
```

## Como o repositório está organizado

- `schema.sql` - script que cria e popula o banco (peguei do repositório oficial do Chinook, só tirei as linhas de DROP/CREATE DATABASE e o \c porque eu já criei o banco manualmente pelo pgAdmin)
- `queries/01_basicas.sql` - SELECT, WHERE, ORDER BY, LIMIT
- `queries/02_joins_agregacoes.sql` - JOINs, GROUP BY, HAVING
- `queries/03_subqueries_ctes.sql` - subconsultas

## Perguntas que respondi

- Quem são os clientes que mais gastaram?
- Quais países dão mais receita pra loja?
- Qual gênero musical vende mais?
- Quais clientes gastam acima da média geral?
- Como está o ranking de faturamento por funcionário?
- Como a receita evoluiu mês a mês (e qual o acumulado)?
