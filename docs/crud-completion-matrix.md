# CRUD Completion Matrix

Last updated: 2026-05-08

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
| user_roles | Y | Y | Y | T |
| store_supplier | Y | Y | Y | T |
| store_client | Y | Y | Y | T |
| store_user | Y | Y | Y | T |
| store_branches | Y | Y | Y | T |
| branch_product | Y | Y | Y | T |

## Sales and Finance

| Entity | Model | Controller CRUD | UI CRUD | Tests |
|---|---|---|---|---|
| store_invoice | Y | Y | Y | T |
| store_invoice_item | Y | Y | Y | T |
| store_payment_voucher | Y | Y | Y | T |
| payment_allocation | Y | Y | Y | T |
| store_return | Y | Y | Y | T |
| store_return_item | Y | Y | Y | T |
| store_financial_transaction | Y | Y | Y | T |
| inventory_movement | Y | Y | Y | T |

## ERP Extensions (Operating Model)

| Entity | Model | Controller CRUD | UI CRUD | Tests |
|---|---|---|---|---|
| purchase_order | Y | Y | Y (inventory tab) | T |
| purchase_order_item | Y | Y | Y (inventory tab) | T |
| supplier_invoice | Y | Y | Y (inventory tab) | T |
| inventory_batch | Y | Y | Y (inventory tab) | T |
| inventory_transaction | Y | Y | Y (inventory tab) | T |
| transfer_order | Y | Y | Y (inventory tab) | T |
| transfer_order_item | Y | Y | Y (inventory tab) | T |
| sales_order | Y | Y | Y (inventory tab) | T |
| sales_invoice | Y | Y | Y (inventory tab) | T |
| sales_return | Y | Y | Y (inventory tab) | T |
| branch_price | Y | Y | Y (inventory tab) | T |
| promotion_rule | Y | Y | Y (inventory tab) | T |
| staff_shift | Y | Y | Y (inventory tab) | T |
| staff_attendance | Y | Y | Y (inventory tab) | T |
| staff_activity_log | Y | Y | Y (inventory tab) | T |

## Recommended Next CRUD Steps

1. Add UI grouping improvements so the expanded inventory tabs remain easy to navigate.
2. Add focused validation tests for new enum/status transitions and edge cases.
3. Add widget and integration test assertions for the new relations tab UX.
