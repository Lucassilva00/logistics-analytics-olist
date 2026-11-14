-- View: public.vw_resumo_categoria_frete

-- DROP VIEW public.vw_resumo_categoria_frete;

CREATE OR REPLACE VIEW public.vw_resumo_categoria_frete
 AS
 SELECT p.product_category_display AS categoria,
    count(*) AS quantidade_itens,
    count(DISTINCT i.order_id) AS pedidos_distintos,
    sum(i.price) AS valor_produtos_total,
    sum(i.freight_value) AS frete_total,
    round(avg(i.freight_value), 2) AS frete_medio_por_item,
    round(100.0 * sum(i.freight_value) / NULLIF(sum(i.price), 0::numeric), 2) AS frete_sobre_valor_produtos_pct
   FROM fact_order_item i
     JOIN dim_product p ON i.product_id::text = p.product_id::text
  GROUP BY p.product_category_display;

