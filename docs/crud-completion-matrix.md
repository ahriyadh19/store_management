# CRUD Completion Matrix

Last updated: 2026-05-07

Legend:
- `Y`: implemented
- `T`: covered by automated tests
- `N`: missing

## Core Entities

| Entity | Model | Controller CRUD | UI CRUD | Tests |
|---|---|---|---|---|
| supplier | Y | Y | Y | T |
| products | Y | Y | Y | T |
| category | Y | Y | Y | T |
| tags | Y | Y | Y | T |
| roles | Y | Y | Y | T |
| users | Y | Y | Y | T |
| store | Y | Y | Y | T |
| branch | Y | Y | Y | T |
| client | Y | Y | Y | T |
| supplier_products | Y | Y | Y | T |
| products_tags | Y | Y | Y | T |
| user_roles | Y | Y | N | T |
| store_supplier | Y | Y | N | T |
| store_client | Y | Y | N | T |
| store_user | Y | Y | N | T |
| store_branches | Y | Y | N | T |
| branch_product | Y | N | N | T (serialization only) |

## Sales and Finance

| Entity | Model | Controller CRUD | UI CRUD | Tests |
|---|---|---|---|---|
| store_invoice | Y | Y | Y | T |
| store_invoice_item | Y | Y | N | T |
| store_payment_voucher | Y | Y | Y | T |
| payment_allocation | Y | Y | N | T |
| store_return | Y | Y | Y | T |
| store_return_item | Y | Y | N | T |
| store_financial_transaction | Y | Y | Y | T |
| inventory_movement | Y | Y | Y | T |

## ERP Extensions (Operating Model)

| Entity | Model | Controller CRUD | UI CRUD | Tests |
|---|---|---|---|---|
| purchase_order | Y | Y | N | T |
| purchase_order_item | N | N | N | N |
| supplier_invoice | Y | Y | N | T |
| inventory_batch | N | N | N | N |
| inventory_transaction | service posting only | N | partial (receiving action) | T (workflow-level widget) |
| transfer_order | N | N | N | N |
| transfer_order_item | N | N | N | N |
| sales_order | N | N | N | N |
| sales_invoice | N | N | N | N |
| sales_return | N | N | N | N |
| branch_price | N | N | N | N |
| promotion_rule | N | N | N | N |
| staff_shift | N | N | N | N |
| staff_attendance | N | N | N | N |
| staff_activity_log | N | N | N | N |

## Recommended Next CRUD Steps

1. Implement `supplier_invoice` model + controller + validations + tests.
2. Implement `purchase_order_item` CRUD and connect it to `purchase_order` totals.
3. Introduce dedicated CRUD pages (or tabs) for `purchase_order` and `supplier_invoice`.
4. Add integration tests for procure-to-stock workflow:
   - create purchase order
   - create supplier invoice
   - receive inventory batch
   - verify inventory transaction effects
