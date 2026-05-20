# Store Management

Store Management is a Flutter application for multi-tenant retail operations. It supports owner-level tenancy, store and branch scoping, supplier and product operations, financial records, and inventory workflows backed by Supabase, with Drift on SQLite providing the local offline-first data layer.

## Highlights

- Multi-tenant operating model rooted at owner accounts.
- Scoped access across owner, store, branch, and user contexts.
- Core retail domains: stores, branches, products, categories, tags, clients, suppliers, users, and roles.
- Financial and operational records: invoices, returns, vouchers, transactions, and inventory movements.
- Supabase-backed data access with tenant-aware query and payload controls.
- Drift + SQLite local persistence bootstrap for desktop and mobile IO targets.
- English and Arabic localization.

## Tech Stack

- Flutter
- Dart SDK 3.11+
- Supabase (supabase, supabase_flutter)
- BLoC (flutter_bloc) for auth state flow
- Decimal money handling (decimal)
- Drift local storage (drift, sqlite3_flutter_libs)

## Project Structure

```text
lib/
  main.dart
  index.dart
  controllers/
  localization/
  models/
  services/
  validations/
  views/
supabase/
  migrations/
docs/
test/
  controllers/
  models/
  services/
  views/
tool/
```

## Runtime Architecture

- App entrypoint is lib/main.dart.
- Supabase is initialized before rendering the widget tree.
- Authentication state controls routing between auth and main shell.
- Main shell includes live status indicators for cloud and local database connections.
- Tenant scope service resolves owner/store/branch permissions for runtime enforcement.

## Storage Strategies

The app exposes three runtime-selectable persistence modes from settings while keeping domain models and business logic independent from any storage engine.

- Online + local: recommended. Supabase remains the central backend for auth, shared data, and synchronization, while Drift on SQLite provides an offline-first local cache for fast reads and uninterrupted usage.
- Online only: Supabase acts as the single source of truth with no local reconciliation layer. This is simpler operationally, but it depends on network availability and can add latency on heavier screens.
- Local only: SQLite stores data only on the current device. This gives maximum offline speed, but it intentionally drops cross-device sync, real-time updates, and centralized control.

The mapping boundary is explicit: domain entities stay pure in `lib/models`, and `lib/data/entity_mapper.dart` converts between application entities, Supabase payloads, and local rows.

## Data and Domain Notes

- Entities are UUID-driven for business links.
- Decimal fields are used for money-safe precision.
- Parsing is tolerant to camelCase and snake_case payload keys.
- Sync-aware models include metadata for offline reconciliation.
- Inventory architecture is transaction-led and batch-aware.

## Database Migration

The repository uses one canonical Supabase migration file:

- supabase/migrations/20260508_000001_complete_improved_schema.sql

That single file now includes:

- Base schema creation for operational, finance, procurement, sales, inventory, audit, notification, and tenant tables.
- Shared database helpers such as `now_millis()`, `set_updated_at()`, generated usernames, and inventory protection functions.
- Owner-account operating model tables and access helpers for `owner_account`, `owner_user_membership`, and `owner_permission_scope`.
- Normalized permission catalog tables and RBAC support, including policy generation for owner-scoped tables.
- Inventory tables and controls, including `inventory_batch`, `inventory_transaction`, `inventory_policy`, and the `v_inventory_balance` view.
- Broad indexing coverage for owner scope, relationship joins, date filters, and unsynced-row reconciliation.
- Row-level security enablement and authenticated/owner-scoped policies across the migrated tables.

For a fresh environment, apply only this file. The older incremental migration files have been removed from the repository so the schema source of truth stays clean.

For existing deployed environments, treat this file as the canonical rebuild reference rather than replaying deleted historical fragments.

Migration review notes from the current repository state:

- Only one migration file exists under `supabase/migrations`, so README guidance should point to a single canonical schema source.
- The migration defines the original operational tables, then extends them with owner-scoped tenancy, procurement, inventory, transfer, sales, pricing, staffing, audit, and integration surfaces.
- The file also enables RLS and creates owner-access policies after the schema additions, which matches the app's multi-tenant access model.

For rollout details, see:

- docs/operating-model-upgrade.md
- docs/project-tracking.md
- docs/data-architecture.md

## Requirements

- Flutter SDK
- Dart SDK compatible with pubspec.yaml
- Supabase project URL and anon key

Verify your toolchain:

```bash
flutter doctor
```

## Configuration

Provide Supabase configuration using one of:

1. --dart-define
2. --dart-define-from-file=.env.local.json
3. Desktop fallback file .env.local.json in project root (Linux/macOS/Windows only)

Example .env.local.json:

```json
{
  "SUPABASE_URL": "https://your-project.supabase.co",
  "SUPABASE_ANON_KEY": "your-anon-key",
  "AUTH_REDIRECT_TO": "https://your-app.example.com/auth/callback"
}
```

## Setup

Install dependencies:

```bash
flutter pub get
```

## Run

Run with config file:

```bash
flutter run --dart-define-from-file=.env.local.json
```

Run with inline defines:

```bash
flutter run --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

## Development Commands

Analyze:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

Generate Drift code after schema changes:

```bash
dart run build_runner build
```

Build targets:

```bash
flutter build apk
flutter build web
flutter build linux
flutter build windows
```

## Current Status

Project tracking and task state are maintained in:

- docs/project-tracking.md

Implemented and active:

- Core auth and localization flow.
- Multi-tenant schema and tenant-aware access enforcement.
- CRUD-oriented model/controller/validation stack.
- Inventory service foundation for sale and transfer posting workflows.
- Single-file migration strategy with normalized permission catalog support.

Still expanding:

- UUID-free administration flows for permission assignment screens.
- Deeper end-to-end workflows for procurement and reporting modules.
- Broader test coverage across service and integration layers.

## Release Checklist

Before shipping a release, run this checklist:

1. Verify configuration. Confirm `SUPABASE_URL` and `SUPABASE_ANON_KEY` are set for the target environment, and confirm desktop fallback `.env.local.json` is not bundled unintentionally in release artifacts.
1. Verify quality gates. Run `flutter analyze` and `flutter test`, and resolve all failures before release.
1. Verify platform builds. Build each deployment target (`windows`, `web`, `apk`, `linux`) and confirm successful output.
1. Verify runtime smoke checks. Launch the app, confirm startup/auth flow works, and on desktop confirm the window is visible and focused after launch.
1. Verify data model safety. Confirm latest migration is applied in staging and critical CRUD flows (invoice, inventory movement, transfer order) succeed.

## License

No license is currently defined in this repository.

## Maintainer

@ahriyadh19
