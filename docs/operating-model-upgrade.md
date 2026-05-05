# Operating Model Upgrade

## Scope Delivered
- Multi-tenant owner accounts with user cross-access.
- Scoped RBAC at owner/store/branch levels.
- Tenant-aware RLS predicates using owner membership.
- Audit logging for critical operational tables.
- Transaction-led inventory with computed balances.
- Batch and expiry controls for inventory lots.
- Procurement primitives: purchase orders, supplier invoices.
- Inter-branch transfer orders.
- Sales primitives: sales orders, invoices, returns.
- Pricing primitives: branch prices and promotions.
- Staff operations: shifts, attendance, activity logs.
- Reporting views: valuation, expiry, low stock, supplier performance, sales profit.
- Optional extension scaffolding: notifications, integration endpoints, conflict log.

## Key Design Decisions
- `owner_account` is the tenant root.
- Existing data is progressively backfilled using conservative defaults.
- Inventory source of truth is `inventory_transaction` + `inventory_batch`.
- Stock is computed via `v_inventory_balance` and not trusted from denormalized stock columns.
- Negative stock is blocked by trigger unless tenant policy allows it.
- Expiry requirement is enforced using product flags (`requiresExpiryDate`).

## Conflict Resolution Guidance (Offline-First)
- Low-risk profile fields: `last_write_wins`.
- Aggregate snapshots: `merge` with deterministic field rules.
- Inventory and financial flows: `event_based` only.
- Hard conflicts: `manual` with `sync_conflict_log` row and admin decision.

## Migration Notes
- This migration adds new structures and keeps old tables for compatibility.
- Existing open RLS policies should be tightened in application rollout phases.
- Application service layer should transition reads/writes to new tables incrementally.

## Next Application Steps
- Replace direct stock writes with inventory transaction posting services.
- Implement FEFO/FIFO allocation service for invoice fulfillment.
- Wire purchase receiving to batch creation and transaction posting.
- Wire transfer approval to dual inventory transactions.
- Introduce permission middleware from `owner_permission_scope`.
