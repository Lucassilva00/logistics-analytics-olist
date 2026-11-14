-- View: public.vw_resumo_entrega_estado

-- DROP VIEW public.vw_resumo_entrega_estado;

CREATE OR REPLACE VIEW public.vw_resumo_entrega_estado
 AS
 SELECT c.customer_state AS estado,
    count(*) AS pedidos_classificados,
    count(*) FILTER (WHERE f.status_entrega::text = 'Atrasado'::text) AS pedidos_atrasados,
    count(*) FILTER (WHERE f.status_entrega::text = 'No prazo'::text) AS pedidos_no_prazo,
    round(100.0 * count(*) FILTER (WHERE f.status_entrega::text = 'Atrasado'::text)::numeric / NULLIF(count(*), 0)::numeric, 2) AS taxa_atraso_pct,
    round(avg(f.dias_atraso) FILTER (WHERE f.status_entrega::text = 'Atrasado'::text), 2) AS atraso_medio_dias
   FROM fact_order_delivery f
     JOIN dim_customer c ON f.customer_id::text = c.customer_id::text
  WHERE f.status_entrega IS NOT NULL
  GROUP BY c.customer_state;


