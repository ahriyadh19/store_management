# RBAC Workflow Review And Permission Architecture

## 1. Reviewed Platform Scope

The application currently operates through these functional areas:

- Dashboard and reports overview.
- Master data modules: stores, branches, products, categories, tags.
- Sales modules: invoices, returns, payment vouchers.
- People and access modules: clients, suppliers, users, roles.
- Operations modules: inventory and transactions.
- Settings and platform controls.
- Generic CRUD engine powering model-backed pages and actions (read/create/update/delete/sync).

## 2. Page And Module Inventory

Page-level navigation is currently defined in the index registry and drawer sections, including:

- `dashboard`
- `reports`
- `stores`
- `branches`
- `products`
- `categories`
- `tags`
- `invoices`
- `returns`
- `paymentVouchers`
- `clients`
- `suppliers`
- `users`
- `roles`
- `inventory`
- `transactions`
- `settings`

Each page now maps to a permission key:

- `page.<pageName>.view`

Examples:

- `page.users.view`
- `page.roles.view`
- `page.inventory.view`
- `page.settings.view`

## 3. Action Surface Reviewed

The system action surface is centralized in generic CRUD pages and includes:

- View record details.
- Create records.
- Edit records.
- Delete records.
- Sync single/all records.

These are now represented by table-scoped permissions:

- `table.<tableName>.read`
- `table.<tableName>.create`
- `table.<tableName>.update`
- `table.<tableName>.delete`
- `table.<tableName>.sync`

This covers module-level operations across users, roles, inventory, finance, purchasing, sales, staff activity, and related links.

## 4. Data Access And Tenant Scope Reviewed

The app enforces tenant scope through owner/store/branch context in model delegates. RBAC is now layered on top of this:

- Tenant scope decides **which tenant data** is visible.
- RBAC decides **which page/action** a user may perform.

This separation prevents cross-tenant leakage while still supporting granular internal staff access.

## 5. First-User Bootstrap Requirement

Implemented in database migration:

- First registered profile becomes system owner/admin automatically.
- Owner account is created when no owner exists.
- Owner membership is created with full permissions.
- Default Owner/Admin/Staff roles are seeded per owner.
- User is linked to Owner and Admin roles.
- Trigger executes bootstrap on new profile insert.
- App performs best-effort bootstrap call on sign-in to guarantee eventual consistency.

## 6. Multi-Role And Dynamic Permission Model

Implemented behavior:

- User may hold multiple roles (`user_roles`).
- Effective permissions are merged from:
  - Membership `permissionsJson`.
  - Role `permissionsJson`.
  - Owner permission scopes.
- Owner/Admin imply wildcard `*` full access.
- Custom roles are dynamic via `roles.permissionsJson` (editable in UI).
- Deny keys are supported to explicitly block inherited actions.

Supported JSON patterns include:

- Key-value booleans:
  - `{ "page.users.view": true, "table.users.delete": false }`
- Allow/deny arrays:
  - `{ "allow": ["page.inventory.view"], "deny": ["table.users.delete"] }`

## 7. Navigation And UI Authorization Alignment

Implemented alignment:

- Drawer sections/pages are filtered by `page.*.view` permissions.
- Unauthorized tabs are pruned from restored workspace state.
- Opening unauthorized pages is blocked with feedback.
- Settings access is permission-gated.
- CRUD page surfaces are blocked if table `read` is denied.
- Create/edit/delete/sync controls are hidden or disabled when permission is missing.

## 8. Security And Maintainability Outcomes

The implemented architecture is:

- Least-privilege by default for non-admin users.
- Fully dynamic for role/permission changes without code edits.
- Scalable with wildcard and namespace matching (`table.users.*`, `table.*`, `*`).
- Compatible with existing owner scope and RLS policies.
- Maintainable because checks are centralized in a dedicated access-control service and generic CRUD layer.

## 9. Recommended Operational Usage

- Keep Owner/Admin roles for tenant governance only.
- Use custom roles for operational staff separation (cashier, warehouse, accountant, auditor).
- Maintain permissions at role level; use membership-level overrides only for exceptional users.
- Review role permissions during process changes (new reports, new modules, new approval steps).
