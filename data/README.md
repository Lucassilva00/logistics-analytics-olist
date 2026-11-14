# Dados — Brazilian E-Commerce Public Dataset by Olist

Esta pasta reúne as orientações para obter e organizar os dados utilizados no projeto **Logistics Analytics**. Os arquivos originais não são armazenados no GitHub: devem ser baixados da fonte indicada e adicionados localmente após clonar o repositório.

## Fonte dos dados

- **Dataset:** Brazilian E-Commerce Public Dataset by Olist
- **Disponibilização:** Olist, por meio do Kaggle
- **Página do dataset:** <https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce>
- **Atribuição:** Olist — *Brazilian E-Commerce Public Dataset by Olist*.
- **Licença indicada na página do Kaggle:** Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0).

Consulte a página original e os termos da licença antes de reutilizar ou redistribuir os dados. Este repositório disponibiliza os materiais analíticos e a documentação, mas não redistribui os CSVs originais.

## Por que os arquivos de dados não estão no GitHub?

Os nove CSVs são disponibilizados externamente pela Olist e podem ser obtidos diretamente no Kaggle. Para evitar duplicar os dados de origem no controle de versão e manter o repositório focado no código, nas consultas e na documentação, os arquivos são mantidos apenas no ambiente local.

As regras do arquivo `.gitignore` excluem `data/raw/` e `data/processed/` do Git. Por isso, essas pastas não aparecem no repositório publicado e precisam ser criadas localmente quando necessário. O arquivo `data/README.md` permanece versionado e contém estas instruções.

## Como preparar os dados localmente

1. Clone o repositório e abra a pasta raiz do projeto.
2. Acesse a [página do dataset no Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce), baixe o conjunto de dados e extraia o arquivo compactado.
3. Crie a pasta `data/raw/` dentro do projeto, caso ela ainda não exista.
4. Copie para `data/raw/` os nove arquivos CSV listados abaixo, preservando os nomes originais.
5. Execute o notebook `notebooks/01_exploracao_dados.ipynb` a partir da estrutura de diretórios esperada pelo projeto.

No Windows, a pasta pode ser criada pelo Explorador de Arquivos ou pelo terminal, a partir da raiz do projeto:

```powershell
New-Item -ItemType Directory -Force .\data\raw
```

Após a extração, a estrutura local ficará assim:

```text
data/
├── README.md
└── raw/
    ├── olist_customers_dataset.csv
    ├── olist_geolocation_dataset.csv
    ├── olist_order_items_dataset.csv
    ├── olist_order_payments_dataset.csv
    ├── olist_order_reviews_dataset.csv
    ├── olist_orders_dataset.csv
    ├── olist_products_dataset.csv
    ├── olist_sellers_dataset.csv
    └── product_category_name_translation.csv
```

## Arquivos utilizados

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

As quantidades representam as contagens observadas durante a preparação e validação deste projeto. Elas servem como referência para a reprodução da análise e não substituem a documentação da fonte original.

## Sobre a pasta `processed/`

A pasta `data/processed/` foi reservada para eventuais arquivos intermediários ou exportações de dados preparados. **Ela não é necessária para reproduzir a versão atual do projeto e não precisa ser criada.** No fluxo desenvolvido, a preparação ocorre no notebook e as tabelas resultantes são carregadas no PostgreSQL para uso nas consultas SQL e no relatório Power BI.

Caso versões futuras passem a exportar arquivos intermediários para essa pasta, ela poderá ser criada localmente. Assim como `data/raw/`, seu conteúdo permanece fora do Git por estar listado no `.gitignore`.
