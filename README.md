# Logistics Analytics — E-commerce Olist

Projeto de análise de dados voltado à avaliação do desempenho logístico, dos custos de frete, das categorias de produtos e da satisfação dos clientes em uma operação de e-commerce.

O projeto utiliza o **Brazilian E-Commerce Public Dataset by Olist** e integra Python, PostgreSQL e Power BI em um fluxo analítico que parte dos arquivos CSV, passa pela preparação e validação dos dados e termina em um relatório interativo.

> **Escopo:** MVP de Analytics descritivo. Não fazem parte desta versão API, Docker, Machine Learning ou automações de CI/CD.

## Objetivos de negócio

O projeto foi desenvolvido para responder a perguntas como:

- Qual é a proporção de pedidos entregues no prazo e quantos sofreram atraso?
- Qual é o atraso médio e quanto tempo decorre entre a entrega pela transportadora e o recebimento pelo cliente?
- Quais estados concentram as maiores taxas e os maiores volumes de atraso?
- Como as avaliações dos clientes variam de acordo com o prazo de entrega?
- Quais categorias concentram maior volume de itens e maior valor absoluto de frete?
- Em quais categorias o frete representa uma parcela maior do valor dos produtos?

## Fonte de dados

**Dataset:** [Brazilian E-Commerce Public Dataset by Olist — Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

O conjunto reúne aproximadamente 100 mil pedidos realizados entre 2016 e 2018, com informações sobre pedidos, clientes, itens, pagamentos, avaliações, produtos, vendedores e geolocalização. A página do dataset informa a licença **CC BY-NC-SA 4.0**. Consulte a fonte e os termos da licença antes de reutilizar ou redistribuir os dados.

Foram utilizados nove arquivos CSV:

| Arquivo de origem | Registros carregados |
|---|---:|
| `olist_customers_dataset.csv` | 99.441 |
| `olist_geolocation_dataset.csv` | 1.000.163 |
| `olist_order_items_dataset.csv` | 112.650 |
| `olist_order_payments_dataset.csv` | 103.886 |
| `olist_order_reviews_dataset.csv` | 99.224 |
| `olist_orders_dataset.csv` | 99.441 |
| `olist_products_dataset.csv` | 32.951 |
| `olist_sellers_dataset.csv` | 3.095 |
| `product_category_name_translation.csv` | 71 |

As contagens correspondem aos dados carregados e analisados neste projeto.

Os CSVs originais não são versionados neste repositório. Consulte [`data/README.md`](data/README.md) para obter a fonte, a atribuição e as instruções de disponibilização local dos arquivos.

## Tecnologias utilizadas

- **Python 3.12** — exploração, preparação, validação e transformação dos dados.
- **Pandas** — manipulação e análise tabular.
- **JupyterLab** — ambiente de desenvolvimento e documentação das análises.
- **PostgreSQL 18.1** — armazenamento relacional das tabelas preparadas e execução de consultas SQL.
- **SQLAlchemy 2.1.6 e psycopg 3.3.6** — conexão e carga de dados no PostgreSQL.
- **Power BI Desktop** — modelagem, medidas DAX, indicadores e relatório interativo.

## Fluxo do projeto

```text
Arquivos CSV (Olist)
        │
        ▼
Python + Pandas
Exploração, preparação, validação e criação de indicadores auxiliares
        │
        ▼
PostgreSQL
Persistência das tabelas preparadas e criação de views analíticas
        │
        ▼
Power BI (modo Import)
Relacionamentos, medidas DAX, filtros e visualizações
        │
        ▼
Relatório interativo de Logistics Analytics
```

### Preparação e modelagem dos dados

Os arquivos originais foram carregados e analisados em Python. A preparação incluiu a criação de campos derivados para classificação das entregas, cálculo de dias de atraso e cálculo do tempo entre a entrega pela transportadora e o recebimento pelo cliente. As avaliações foram consolidadas por pedido para permitir a análise conjunta entre entrega e satisfação.

As tabelas preparadas foram carregadas no PostgreSQL e validadas por contagem de registros, chaves e relacionamentos. Também foram criadas e verificadas três views analíticas, cujos scripts estão disponíveis na pasta `sql/`:

- `vw_resumo_entrega_estado` — indicadores de entrega agrupados por estado.
- `vw_resumo_categoria_frete` — volume, valores de produtos e indicadores de frete por categoria.
- `vw_satisfacao_por_prazo` — distribuição das faixas de satisfação por status de entrega.

### Modelo analítico no Power BI

O relatório utiliza cinco tabelas principais:

| Tabela | Registros | Papel |
|---|---:|---|
| `dim_customer` | 99.441 | Dimensão de clientes e localização |
| `dim_product` | 32.951 | Dimensão de produtos e categorias |
| `dim_seller` | 3.095 | Dimensão de vendedores e localização |
| `fact_order_delivery` | 99.441 | Fato de pedidos, entrega e avaliação consolidada |
| `fact_order_item` | 112.650 | Fato de itens, preços e fretes |

Relacionamentos principais:

- `dim_customer` → `fact_order_delivery` (1:1).
- `dim_customer` → `fact_order_item` (1:N).
- `dim_product` → `fact_order_item` (1:N).
- `dim_seller` → `fact_order_item` (1:N).

Não foi criado relacionamento direto entre tabelas fato. O modelo foi construído em modo **Import**, a partir das cinco tabelas principais do PostgreSQL.

## Relatório Power BI

O arquivo [`powerbi/Logistics_Analytics.pbix`](powerbi/Logistics_Analytics.pbix) contém quatro páginas com navegação entre elas:

| Página | Conteúdo |
|---|---|
| **Visão Geral** | Indicadores gerais de pedidos e entregas e evolução mensal dos pedidos. |
| **Desempenho das Entregas** | Taxa e volume de atrasos e atraso médio por estado, com filtros de período e localização. |
| **Produtos e Frete** | Volume de itens, valor dos produtos, frete total e participação do frete por categoria. |
| **Experiência do Cliente** | Notas médias por prazo de entrega, distribuição das faixas de satisfação e baixa satisfação por estado. |

O relatório também possui tooltips personalizados para contextualizar pontos específicos, incluindo a baixa quantidade de pedidos nos últimos meses da série temporal.

## Principais indicadores e resultados

Os valores abaixo representam os resultados obtidos no conjunto completo, sem filtros de página, salvo quando a regra do próprio indicador estabelece um universo específico.

### Entregas

| Indicador | Resultado | Regra de cálculo |
|---|---:|---|
| Total de pedidos | 99.441 | Pedidos distintos |
| Pedidos classificados | 96.470 | Pedidos com status de entrega válido: no prazo ou atrasado |
| Entregas no prazo | 89.936 (93,23%) | Pedidos no prazo / pedidos classificados |
| Pedidos atrasados | 6.534 (6,77%) | Pedidos atrasados / pedidos classificados |
| Atraso médio | 10,62 dias | Média dos dias de atraso somente entre pedidos atrasados |
| Mediana do atraso | 7 dias | Mediana dos dias de atraso entre pedidos atrasados |
| Tempo médio transportadora–cliente | 8,88 dias | Média do intervalo válido para pedidos entregues (96.446 observações válidas) |

**Atenção à classificação:** 2.971 pedidos não receberam classificação de entrega válida. Eles permanecem na base, mas não entram no denominador das taxas de entrega no prazo e de atraso.

### Satisfação do cliente

| Indicador | Resultado |
|---|---:|
| Pedidos avaliados com classificação de entrega | 95.824 |
| Nota média geral | 4,16 |
| Nota média dos pedidos no prazo | 4,29 |
| Nota média dos pedidos atrasados | 2,27 |

As faixas de satisfação foram definidas da seguinte forma:

- **Baixa:** nota média do pedido menor ou igual a 2.
- **Intermediária:** nota maior que 2 e menor que 4.
- **Alta:** nota igual ou superior a 4.

Distribuição das avaliações por situação de entrega (percentual calculado dentro de cada grupo de pedidos avaliados):

| Situação | Baixa | Intermediária | Alta |
|---|---:|---:|---:|
| No prazo | 9,23% | 8,13% | 82,64% |
| Atrasado | 62,36% | 10,91% | 26,74% |

Os resultados mostram uma associação descritiva entre atraso e avaliações mais baixas. Eles não demonstram, por si só, uma relação causal.

### Produtos e frete

| Indicador | Resultado |
|---|---:|
| Itens vendidos | 112.650 |
| Valor total dos produtos | R$ 13.591.643,70 |
| Frete total | R$ 2.251.909,54 |
| Frete sobre o valor dos produtos | 16,57% |

Categorias com maior volume de itens:

| Categoria | Itens |
|---|---:|
| Bed Bath Table | 11.115 |
| Health Beauty | 9.670 |
| Sports Leisure | 8.641 |
| Furniture Decor | 8.334 |

Categorias com maior valor absoluto de frete:

| Categoria | Frete total |
|---|---:|
| Bed Bath Table | R$ 204.693,04 |
| Health Beauty | R$ 182.566,73 |
| Furniture Decor | R$ 172.749,30 |
| Sports Leisure | R$ 168.607,51 |
| Computers Accessories | R$ 147.318,08 |

Entre as categorias com pelo menos 100 itens, algumas das maiores relações entre frete e valor dos produtos foram:

| Categoria | Frete / valor dos produtos |
|---|---:|
| Christmas Supplies | 36,69% |
| Signaling Security (`signaling_security`) | 30,26% |
| Food Drink | 29,70% |
| Electronics | 29,07% |
| Living Room Furniture | 26,07% |

### Recorte regional de atrasos

Para evitar destacar taxas calculadas sobre volumes muito pequenos, os rankings de taxa de atraso e atraso médio por estado consideram estados com pelo menos **500 pedidos classificados**.

| Estado | Taxa de atraso |
|---|---:|
| Maranhão (MA) | 17,43% |
| Ceará (CE) | 13,76% |
| Bahia (BA) | 12,16% |
| Rio de Janeiro (RJ) | 12,11% |

Os cinco estados com maior volume absoluto de pedidos atrasados foram:

| Estado | Pedidos atrasados | Pedidos classificados | Taxa de atraso | Participação no total de atrasos |
|---|---:|---:|---:|---:|
| São Paulo (SP) | 1.820 | 40.494 | 4,49% | 27,85% |
| Rio de Janeiro (RJ) | 1.495 | 12.350 | 12,11% | 22,88% |
| Minas Gerais (MG) | 519 | 11.354 | 4,57% | 7,94% |
| Bahia (BA) | 396 | 3.256 | 12,16% | 6,06% |
| Rio Grande do Sul (RS) | 325 | 5.344 | 6,08% | 4,97% |

São Paulo e Rio de Janeiro, juntos, concentram 50,73% dos pedidos atrasados. A comparação também mostra por que volume e taxa devem ser interpretados em conjunto: São Paulo lidera em quantidade, enquanto Bahia (12,16%) e Rio de Janeiro (12,11%) apresentam taxas proporcionalmente mais altas.

## Qualidade dos dados e decisões metodológicas

Uma parte importante do projeto foi investigar inconsistências sem remover registros apenas para melhorar a aparência dos indicadores.

### Meses finais da série temporal

A base contém somente 16 pedidos em setembro de 2018 e 4 em outubro de 2018; o último pedido foi registrado em **17/10/2018**. Entre esses 20 pedidos, 19 estavam cancelados e 1 estava enviado, sem pedidos entregues.

Esses registros foram mantidos. A baixa movimentação dos meses finais é contextualizada por um tooltip no relatório, evitando interpretar a queda como uma redução operacional sem ressalvas.

### Avaliações e identificadores repetidos

A tabela de avaliações possui 99.224 linhas e 98.410 valores distintos de `review_id`. Foram identificados 789 identificadores de avaliação associados a mais de um pedido, abrangendo 1.603 linhas e 1.412 pedidos distintos.

Também foram encontradas 64 linhas em que a data de criação da avaliação antecede a data de compra, considerando a comparação por data. A investigação não forneceu evidência suficiente para reconstruir com segurança todos os vínculos corretos entre avaliações e pedidos.

**Decisão adotada:** as avaliações foram consolidadas por `order_id`, sem tratar `review_id` como chave única, sem realocar avaliações automaticamente e sem excluir registros da base principal.

Foram feitos testes de sensibilidade. A remoção isolada das 64 linhas temporalmente inconsistentes alterou muito pouco as médias. A exclusão conservadora de todas as 1.603 linhas associadas a `review_id` repetidos também produziu mudanças pequenas nas médias, mas reduziu a quantidade de avaliações consideradas. Por isso, a análise principal preserva os registros e documenta a limitação.

Essas decisões tornam explícito que os indicadores de satisfação dependem da qualidade dos vínculos presentes na fonte original.

## Critérios de apresentação dos rankings

Alguns visuais utilizam limites mínimos de observações para evitar rankings pouco representativos:

- **500 pedidos classificados:** taxa de atraso e atraso médio por estado.
- **100 pedidos avaliados:** taxa de baixa satisfação por estado.
- **100 itens:** relação entre frete e valor dos produtos por categoria.

Os limites afetam somente a exibição dos rankings. Não removem registros das tabelas nem alteram os indicadores gerais.

## Como reproduzir

1. Baixe o [dataset da Olist no Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) e consulte a licença e as condições de uso.
2. Extraia os nove arquivos CSV e coloque-os em `data/raw/`, preservando os nomes originais. Consulte [`data/README.md`](data/README.md) para a lista completa.
3. Execute as etapas de exploração, preparação e validação em Python/JupyterLab pelo notebook `notebooks/01_exploracao_dados.ipynb`.
4. Crie o banco `logistics_analytics` no PostgreSQL e ajuste os parâmetros de conexão para o ambiente local.
5. Execute os scripts da pasta `sql/` para criar as três views analíticas. As tabelas preparadas precisam ter sido carregadas previamente no banco.
6. Abra `powerbi/Logistics_Analytics.pbix`, ajuste a conexão PostgreSQL para o ambiente local e atualize os dados.

Caminhos de arquivos e parâmetros de conexão podem precisar de ajustes conforme o ambiente de execução. Não publique senhas, tokens ou outras credenciais no repositório.

## Limitações

- O dataset representa o período de 2016 a 2018; os resultados não devem ser interpretados como retrato do e-commerce brasileiro atual.
- Os últimos meses da série temporal têm volume muito reduzido.
- Foram identificadas inconsistências nos identificadores e nas datas das avaliações, documentadas na seção de qualidade dos dados.
- A análise é descritiva. Relações entre atraso e satisfação não devem ser interpretadas como causalidade.
- Os indicadores dependem dos registros e das definições operacionais da fonte original.

## Estrutura do repositório

O repositório está organizado em quatro áreas principais: documentação da fonte de dados, exploração e preparação em Python, consultas SQL e relatório interativo.

```text
logistics-analytics-olist/
├── data/
│   └── README.md
├── notebooks/
│   └── 01_exploracao_dados.ipynb
├── powerbi/
│   └── Logistics_Analytics.pbix
├── sql/
│   ├── 01_vw_resumo_entrega_estado.sql
│   ├── 02_vw_resumo_categoria_frete.sql
│   └── 03_vw_satisfacao_por_prazo.sql
├── .gitignore
└── README.md
```

---

Projeto desenvolvido para demonstrar competências em análise de dados, preparação e validação de dados, SQL, modelagem dimensional, DAX e visualização de indicadores de negócio.
