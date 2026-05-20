# Project Tracking

This file is the central project tracker for Store Management.

It must be reviewed and updated:

- Before starting any new task.
- When new work begins.
- When changes are made.
- When issues or blockers are discovered.
- When a task is completed.
- When a task needs review or handoff.

Status values:

- `Pending`
- `In Progress`
- `Completed`
- `Blocked`
- `Needs Review`

Priority values:

- `Critical`
- `High`
- `Medium`
- `Low`

Assigned developer values should name the responsible person or use `Unassigned`.

## Tracking Workflow

Every tracked item should have a stable task ID using this format:

- `CORE-###` for core platform and architecture work
- `ACL-###` for security, roles, and permissions work
- `DB-###` for database and backend work
- `UI-###` for frontend and UI work
- `QA-###` for testing, debugging, and validation work

Use these workflow rules:

- Never create work without assigning a new task ID.
- Keep one primary row per task and update it over time instead of duplicating it across sections.
- When task status changes, update both the row and the changelog section.
- When a task is finished, move it to the appropriate completed section if needed.
- When a task is blocked, record the blocker clearly in Notes / Known Issues.
- If a task affects multiple areas, list all relevant modules or files in the related files column.

## Update Rules

For every tracked item, keep these fields current:

- Task or feature name
- Detailed description
- Current status
- Priority level
- Assigned developer
- Date created
- Last updated date
- Completion date
- Related modules or files
- Notes or known issues

## Change Log

| Date | Task ID | Change Summary | Updated By | Notes |
|---|---|---|---|---|
| 2026-05-20 | CORE-001 | Created central project tracking file and linked it from the README. | Copilot | Established the project-wide progress workflow. |
| 2026-05-20 | ACL-001 | Added normalized permission catalog, ACL compatibility fixes, and runtime permission loading tasks. | Copilot | Captures the current roles and permissions workstream. |
| 2026-05-20 | CORE-002 | Converted the tracker into a stricter operational document with IDs, changelog, and reusable templates. | Copilot | Use this log for every future task status update. |
| 2026-05-20 | CORE-004 | Added next-session prioritization and removed duplicate rows from category sections. | Copilot | Category sections now reference canonical task IDs instead of duplicating full task records. |
| 2026-05-20 | UI-007 | Standardized shared DataTable display/search/sort behavior and replaced the Reports placeholder with a real analytics page. | Copilot | Shared table logic now uses field metadata for display/query consistency and refetches a valid page when server-side filtering shrinks a result set. |
| 2026-05-20 | UI-002 | Completed selector-driven permission assignment workflows across shared forms and inventory relation screens. | Copilot | Permission, role, page, and store/user assignment flows now avoid manual UUID entry for stable relations. |
| 2026-05-20 | UI-003 | Completed the remaining UUID-heavy relation workflow cleanup, including the purchase receiving panel. | Copilot | Stable single-table relations now use selectors where the local cache can supply options; only scope and polymorphic IDs remain raw. |
| 2026-05-20 | ACL-005 | Added stale ACL snapshot refresh handling on app resume and navigation, then revalidated the full test suite. | Copilot | Long-lived sessions now re-check permissions instead of relying only on initial load and auth-change events. |

## Next Session Focus

Use this section to decide the next tasks before any new implementation work starts.

| Order | Task ID | Task / Feature | Current Status | Priority | Why It Is Next |
|---|---|---|---|---|---|
| 1 | DB-002 | Migration Rollout Validation | Needs Review | Critical | The canonical schema must be validated in a real Supabase environment before the migration path is considered fully safe. |
| 2 | DB-006 | Migration Deployment Verification | Pending | Critical | Staging or production-like rollout verification is still outstanding for the consolidated schema. |
| 3 | QA-001 | Permission Catalog Backfill QA | Needs Review | High | Legacy role payload backfill needs real dataset validation. |
| 4 | CORE-003 | Route Metadata Standardization | Pending | Medium | Shared route and permission metadata would reduce drift between navigation, page catalog seeding, and access checks. |
| 5 | ACL-006 | Permission Audit Trail | Pending | Medium | Auditability is the next meaningful permission-system improvement after snapshot freshness is stabilized. |

## Completed Features

| Task ID | Task / Feature | Detailed Description | Current Status | Priority | Assigned Developer | Date Created | Last Updated | Completion Date | Related Modules / Files | Notes / Known Issues |
|---|---|---|---|---|---|---|---|---|---|
| DB-001 | Canonical Supabase Migration | Consolidated schema, tenant rules, permission catalog, and compatibility helpers into a single canonical migration file. | Completed | Critical | Copilot | 2026-05-20 | 2026-05-20 | 2026-05-20 | `supabase/migrations/20260508_000001_complete_improved_schema.sql`, `README.md` | Fresh environments should apply only the canonical migration file. |
| ACL-002 | Permission Catalog Models | Added normalized permission entities for pages, permissions, role permissions, and user permissions. | Completed | High | Copilot | 2026-05-20 | 2026-05-20 | 2026-05-20 | `lib/models/access_page.dart`, `lib/models/access_permission.dart`, `lib/models/role_permission.dart`, `lib/models/user_permission.dart` | Drift schema generation remained unchanged in this tracking update. |
| UI-001 | Access Management Datatables | Added CRUD-backed access tabs for pages, permissions, role permissions, and user permissions. | Completed | High | Copilot | 2026-05-20 | 2026-05-20 | 2026-05-20 | `lib/views/pages/inventory_page.dart`, `lib/views/pages/model_module_pages.dart` | Assignment flows now use selector-backed fields for stable permission relations. |
| UI-007 | Shared Datatable Consistency And Reports Page | Refactored the shared CRUD/query pipeline so table search, sort, labels, and server pagination stay aligned with field metadata, and added a real Reports module with analytics, sync health, and recent activity sections. | Completed | High | Copilot | 2026-05-20 | 2026-05-20 | 2026-05-20 | `lib/views/components/model_form.dart`, `lib/views/pages/model_crud_page.dart`, `lib/views/pages/model_module_pages.dart`, `lib/views/pages/reports_page.dart`, `lib/views/index/index_page_registry.dart`, `test/views/model_module_pages_test.dart`, `test/views/reports_page_test.dart` | Stable relation labels now follow selection metadata when available; remaining raw IDs are intentionally scope-based or polymorphic. |
| UI-002 | Permission Assignment UX | Replaced raw UUID entry in permission-related forms with searchable selectors and clearer admin workflows. | Completed | High | Copilot | 2026-05-20 | 2026-05-20 | 2026-05-20 | `lib/views/pages/model_module_pages.dart`, `lib/views/components/model_form.dart`, `lib/views/pages/inventory_page.dart`, `test/views/model_module_pages_test.dart` | Permission and relation-management assignment flows now use selection-backed field metadata and focused coverage. |
| UI-003 | UUID-Heavy Permission Forms | Removed manual UUID-heavy relation entry from the remaining stable permission and inventory-receiving workflows. | Completed | High | Copilot | 2026-05-20 | 2026-05-20 | 2026-05-20 | `lib/views/pages/model_module_pages.dart`, `lib/views/pages/inventory_page.dart`, `test/views/model_module_pages_test.dart` | Scope fields like `ownerUuid` and polymorphic references remain raw by design. |
| ACL-005 | Permission Snapshot Refinement | Improved how permissions are refreshed across auth transitions, app resume, and navigation in long-lived sessions. | Completed | High | Copilot | 2026-05-20 | 2026-05-20 | 2026-05-20 | `lib/services/access_control_service.dart`, `lib/controllers/auth_controller.dart`, `lib/index.dart`, `test/services/access_control_service_test.dart` | Snapshot refreshes now use a staleness policy instead of relying only on initial load and sign-in/sign-out events. |
| ACL-003 | ACL Compatibility Fix | Fixed role resolution so owner/admin access is not dropped by mismatched or blank owner scoping on assigned roles. | Completed | Critical | Copilot | 2026-05-20 | 2026-05-20 | 2026-05-20 | `lib/services/access_control_service.dart`, `test/services/access_control_service_test.dart` | Focused ACL tests passed after the fix. |
| ACL-004 | Normalized Permission Loading | Access control service now merges role-based and user-specific normalized permission grants with legacy compatibility. | Completed | Critical | Copilot | 2026-05-20 | 2026-05-20 | 2026-05-20 | `lib/services/access_control_service.dart`, `test/services/access_control_service_test.dart` | User grants apply after role grants to support direct overrides. |

## Features Under Development

No active in-repo feature work is currently marked in progress.

## Bugs And Issues To Fix

| Task ID | Task / Feature | Detailed Description | Current Status | Priority | Assigned Developer | Date Created | Last Updated | Completion Date | Related Modules / Files | Notes / Known Issues |
|---|---|---|---|---|---|---|---|---|---|
| DB-002 | Migration Rollout Validation | Canonical migration has been consolidated but still needs live validation in Supabase environments. | Needs Review | Critical | Unassigned | 2026-05-20 | 2026-05-20 |  | `supabase/migrations/20260508_000001_complete_improved_schema.sql` | SQL was prepared and consolidated locally; deployment verification is still required. |
| QA-001 | Permission Catalog Backfill QA | Backfill logic from legacy `permissionsJson` to normalized role permissions needs runtime QA with real tenant data. | Needs Review | High | Unassigned | 2026-05-20 | 2026-05-20 |  | `supabase/migrations/20260508_000001_complete_improved_schema.sql`, `lib/services/access_control_service.dart` | Needs confirmation for mixed legacy/custom role payloads. |

## Planned Future Improvements

| Task ID | Task / Feature | Detailed Description | Current Status | Priority | Assigned Developer | Date Created | Last Updated | Completion Date | Related Modules / Files | Notes / Known Issues |
|---|---|---|---|---|---|---|---|---|---|
| CORE-003 | Route Metadata Standardization | Map application pages, route keys, and permission keys from one shared source to avoid duplication. | Pending | Medium | Unassigned | 2026-05-20 | 2026-05-20 |  | `lib/views/index/index_page.dart`, `lib/views/index/index_page_registry.dart`, `lib/services/access_control_service.dart` | Would reduce drift between UI navigation and permission catalog seeds. |
| ACL-006 | Permission Audit Trail | Record grant and revoke operations for roles and users in audit logs. | Pending | Medium | Unassigned | 2026-05-20 | 2026-05-20 |  | `supabase/migrations/20260508_000001_complete_improved_schema.sql`, `lib/services/access_control_service.dart` | Can build on existing audit log infrastructure. |
| ACL-007 | Bulk Permission Templates | Allow reusable templates for sales, staff, accountant, and manager permission bundles. | Pending | Medium | Unassigned | 2026-05-20 | 2026-05-20 |  | `lib/views/pages/model_module_pages.dart`, `lib/views/components/permission_visual_editor_dialog.dart`, `supabase/migrations/20260508_000001_complete_improved_schema.sql` | Useful for faster onboarding and safer defaults. |

## Database And Backend Tasks

Canonical task references for backend work:

- `DB-001` Canonical Supabase Migration
- `DB-002` Migration Rollout Validation
- `DB-003` Pages Model Creation
- `DB-004` Roles And Permissions Database Structure
- `DB-005` Legacy Permission Sync Logic
- `DB-006` Migration Deployment Verification

## Frontend / UI Tasks

Canonical task references for frontend work:

- `UI-001` Access Management Datatables
- `UI-002` Permission Assignment UX
- `UI-003` UUID-Heavy Permission Forms
- `UI-004` Sidebar / Menu Filtering By Permissions
- `UI-005` Permission Admin Screens
- `UI-006` Unauthorized State UX

## Security And Permission Tasks

Canonical task references for security and permissions work:

- `ACL-002` Permission Catalog Models
- `ACL-003` ACL Compatibility Fix
- `ACL-004` Normalized Permission Loading
- `ACL-005` Permission Snapshot Refinement
- `ACL-006` Permission Audit Trail
- `ACL-007` Bulk Permission Templates
- `ACL-008` Role-Based Middleware Validation
- `ACL-009` User Custom Permissions
- `ACL-010` Admin And Owner Full-Access Logic
- `ACL-011` Session / Cache Permission Refresh Handling
- `ACL-012` Route Protection Validation
- `QA-001` Permission Catalog Backfill QA
- `QA-002` Testing And Debugging Tasks

## Task Update Template

Use this template when adding a new row:

| Task ID | Task / Feature | Detailed Description | Current Status | Priority | Assigned Developer | Date Created | Last Updated | Completion Date | Related Modules / Files | Notes / Known Issues |
|---|---|---|---|---|---|---|---|---|---|---|
| `AREA-###` | Task name | Clear detailed description of the work. | Pending | Medium | Unassigned | YYYY-MM-DD | YYYY-MM-DD |  | `path/to/file.dart`, `path/to/other.sql` | Known risks, blockers, dependencies, or review notes. |

## Changelog Entry Template

Use this template whenever a task starts, changes status, or is completed:

| Date | Task ID | Change Summary | Updated By | Notes |
|---|---|---|---|---|
| YYYY-MM-DD | `AREA-###` | Short summary of the update. | Developer name | Optional blocker, review note, or follow-up action. |

## Working Notes

- Review this file before starting any new task.
- Update `Last Updated` whenever a task changes state or notes are added.
- Move items between sections when their lifecycle changes.
- Do not leave completed work only in chat history; reflect it here.
- Add a changelog entry for every meaningful project update.