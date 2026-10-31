-- 1. Qual é o percentual e o valor financeiro nominal economizado pelo governo? (diferença entre valor estimado e valor homolagado)?
SELECT 
    SUM(economia_valor) AS economia_nominal,
    ROUND(SUM(economia_valor) / SUM(CASE WHEN comparavel = 1 THEN valor_total_estimado ELSE 0 END)*100, 2) AS percentual_economia
FROM fato_item_contratado;

-- 2. Quem são os maiores fornecedores em volume financeiro e qual percentual do orçamento público está concentrado neles?
SELECT 
    d.nome_fornecedor,
    SUM(f.valor_total_homologado) AS volume_financeiro,
    SUM(f.valor_total_homologado) / (SELECT SUM(valor_total_homologado) FROM fato_item_contratado) AS percentual_orcamento
FROM fato_item_contratado f
JOIN dim_fornecedor d ON f.sk_fornecedor = d.sk_fornecedor
GROUP BY d.nome_fornecedor
ORDER BY volume_financeiro DESC
LIMIT 10;

-- 3. Quais modalidades licitatórias trazem maior deságio/economia e quais concentram o maior volume de recursos?
SELECT 
    d.nome_modalidade,
    SUM(f.valor_total_homologado) AS volume_recursos,
    ROUND(SUM(f.economia_valor) / NULLIF(SUM(CASE WHEN f.comparavel = 1 THEN f.valor_total_estimado ELSE 0 END), 0)*100, 2) AS percentual_economia
FROM fato_item_contratado f
JOIN dim_modalidade d ON f.sk_modalidade = d.sk_modalidade
GROUP BY d.nome_modalidade
ORDER BY volume_recursos DESC;

-- 4. Qual a duração média (em dias) entre o lançamento do edital e sua homologação final, segmentada por órgão?
SELECT 
    d.nome_orgao,
    ROUND(AVG(f.dias_ciclo), 0) AS ciclo_medio_dias,
    COUNT(f.dias_ciclo) AS qtd_itens_com_ciclo
FROM fato_item_contratado f
JOIN dim_orgao d ON f.sk_orgao = d.sk_orgao
WHERE f.dias_ciclo IS NOT NULL
GROUP BY d.nome_orgao
HAVING COUNT(f.dias_ciclo) >= 5
ORDER BY ciclo_medio_dias DESC;

--5A. Quais estados e regiões concentram as maiores despesas e quais apresentam os melhores indicadores de desconto?
SELECT 
    d.regiao,
    SUM(f.valor_total_homologado) AS volume_despesas,
    ROUND((SUM(f.economia_valor) / NULLIF(SUM(CASE WHEN f.comparavel = 1 THEN f.valor_total_estimado ELSE 0 END), 0)) * 100, 2) AS percentual_desconto
FROM fato_item_contratado f
JOIN dim_localidade d ON f.sk_localidade = d.sk_localidade
GROUP BY d.regiao
ORDER BY volume_despesas DESC;

-- 5B. Distribuição regional (Agrupado por Estado/UF)
SELECT 
    d.uf_sigla,
    d.regiao,
    SUM(f.valor_total_homologado) AS volume_despesas,
    ROUND((SUM(f.economia_valor) / NULLIF(SUM(CASE WHEN f.comparavel = 1 THEN f.valor_total_estimado ELSE 0 END), 0)) * 100, 2) AS percentual_desconto
FROM fato_item_contratado f
JOIN dim_localidade d ON f.sk_localidade = d.sk_localidade
GROUP BY d.uf_sigla, d.regiao
ORDER BY volume_despesas DESC;

--6. Como os recursos se distribuem entre bens, serviços e obras e engenharia?
SELECT 
    perfil_gasto,
    SUM(valor_total_homologado) AS volume_recursos,
    ROUND(SUM(valor_total_homologado) / (SELECT SUM(valor_total_homologado) FROM fato_item_contratado)*100, 1) AS percentual_distribuicao
FROM fato_item_contratado
GROUP BY perfil_gasto
ORDER BY volume_recursos DESC;