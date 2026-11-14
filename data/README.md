# Dados — Brazilian E-Commerce Public Dataset by Olist

Esta pasta documenta a origem dos dados utilizados no projeto **Logistics Analytics**. Os arquivos CSV originais não são incluídos neste repositório; cada pessoa deve obtê-los diretamente da fonte indicada abaixo.

## Fonte e atribuição

- **Dataset:** Brazilian E-Commerce Public Dataset by Olist
- **Disponibilização:** Olist, por meio do Kaggle
- **Página oficial:** https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
- **Atribuição:** dados disponibilizados pela Olist — *Brazilian E-Commerce Public Dataset by Olist*.
- **Licença indicada na página do Kaggle:** Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0).

Consulte a página original e os termos da licença antes de reutilizar ou redistribuir os dados. Este repositório não redistribui os CSVs originais; mantém apenas esta documentação e os materiais analíticos desenvolvidos no projeto.

## Arquivos utilizados

Coloque os nove arquivos CSV originais dentro de `data/raw/`, preservando seus nomes:

| Arquivo | Registros observados no projeto | Conteúdo principal |
|---|---:|---|
| `olist_customers_dataset.csv` | 99.441 | Identificadores e localização dos clientes |
| `olist_geolocation_dataset.csv` | 1.000.163 | Prefixos de CEP e coordenadas geográficas |
| `olist_order_items_dataset.csv` | 112.650 | Itens dos pedidos, produtos, vendedores, preços e fretes |
| `olist_order_payments_dataset.csv` | 103.886 | Informações de pagamento e parcelamento |
| `olist_order_reviews_dataset.csv` | 99.224 | Avaliações e comentários dos pedidos |
| `olist_orders_dataset.csv` | 99.441 | Status e datas dos pedidos |
| `olist_products_dataset.csv` | 32.951 | Categorias, dimensões e características dos produtos |
| `olist_sellers_dataset.csv` | 3.095 | Identificadores e localização dos vendedores |
| `product_category_name_translation.csv` | 71 | Tradução dos nomes de categorias de produtos |

As quantidades representam as contagens observadas durante a preparação e validação deste projeto. Elas não substituem a documentação da fonte original.

## Como disponibilizar os dados localmente

1. Acesse a [página do dataset no Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).
2. Baixe o conjunto de dados e extraia os arquivos compactados.
3. Copie os nove CSVs listados acima para `data/raw/`.
4. Preserve os nomes originais dos arquivos para corresponder às referências utilizadas no notebook `notebooks/01_exploracao_dados.ipynb`.

Estrutura esperada:

```text
data/
├── README.md
├── raw/
│   ├── olist_customers_dataset.csv
│   ├── olist_geolocation_dataset.csv
│   ├── olist_order_items_dataset.csv
│   ├── olist_order_payments_dataset.csv
│   ├── olist_order_reviews_dataset.csv
│   ├── olist_orders_dataset.csv
│   ├── olist_products_dataset.csv
│   ├── olist_sellers_dataset.csv
│   └── product_category_name_translation.csv
└── processed/
```

## Tratamento e armazenamento no projeto

A exploração, preparação e validação dos dados estão documentadas no notebook principal. As tabelas preparadas foram carregadas no PostgreSQL para uso nas consultas SQL e no relatório Power BI.

Na versão atual do repositório, `data/processed/` não contém arquivos exportados. A pasta está reservada para eventuais saídas intermediárias que venham a ser geradas em versões futuras.

Os diretórios `data/raw/` e `data/processed/` estão listados no `.gitignore`. Portanto, os dados permanecem no ambiente local e não são enviados ao GitHub junto com o código e a documentação.
