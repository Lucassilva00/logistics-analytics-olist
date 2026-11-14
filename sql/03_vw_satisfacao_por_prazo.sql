-- View: public.vw_satisfacao_por_prazo

-- DROP VIEW public.vw_satisfacao_por_prazo;

CREATE OR REPLACE VIEW public.vw_satisfacao_por_prazo
 AS
 WITH pedidos_com_satisfacao AS (
         SELECT fact_order_delivery.status_entrega,
                CASE
                    WHEN fact_order_delivery.nota_media_pedido <= 2::numeric THEN 'Baixa'::text
                    WHEN fact_order_delivery.nota_media_pedido < 4::numeric THEN 'Intermediária'::text
                    ELSE 'Alta'::text
                END AS faixa_satisfacao
           FROM fact_order_delivery
          WHERE fact_order_delivery.status_entrega IS NOT NULL AND fact_order_delivery.nota_media_pedido IS NOT NULL
        ), resumo AS (
         SELECT pedidos_com_satisfacao.status_entrega,
            pedidos_com_satisfacao.faixa_satisfacao,
            count(*) AS quantidade_pedidos
           FROM pedidos_com_satisfacao
          GROUP BY pedidos_com_satisfacao.status_entrega, pedidos_com_satisfacao.faixa_satisfacao
        )
 SELECT status_entrega,
    faixa_satisfacao,
    quantidade_pedidos,
    round(100.0 * quantidade_pedidos::numeric / NULLIF(sum(quantidade_pedidos) OVER (PARTITION BY status_entrega), 0::numeric), 2) AS percentual_pct
   FROM resumo;

