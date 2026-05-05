# Store Management

Store Management is a Flutter application for multi-tenant retail operations. It supports owner-level tenancy, store and branch scoping, supplier and product operations, financial records, and inventory workflows backed by Supabase, with ObjectBox infrastructure for offline-first support.

## Highlights

- Multi-tenant operating model rooted at owner accounts.
- Scoped access across owner, store, branch, and user contexts.
- Core retail domains: stores, branches, products, categories, tags, clients, suppliers, users, and roles.
- Financial and operational records: invoices, returns, vouchers, transactions, and inventory movements.
- Supabase-backed data access with tenant-aware query and payload controls.
- ObjectBox local persistence bootstrap for desktop and mobile IO targets.
- English and Arabic localization.

## Tech Stack

- Flutter
- Dart SDK 3.11+
- Supabase (supabase, supabase_flutter)
- BLoC (flutter_bloc) for auth state flow
- Decimal money handling (decimal)
- ObjectBox local storage (objectbox, objectbox_flutter_libs)

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

## Data and Domain Notes

- Entities are UUID-driven for business links.
- Decimal fields are used for money-safe precision.
- Parsing is tolerant to camelCase and snake_case payload keys.
- Sync-aware models include metadata for offline reconciliation.
- Inventory architecture is transaction-led and batch-aware.

## Database Migration

Migrations are consolidated into a single file:

- supabase/migrations/20260505_000001_consolidated_schema.sql

This consolidated migration includes:

- Base schema creation.
- Sync metadata columns and related compatibility updates.
- Supplier product variation updates.
- Multi-tenant operating model upgrade, including inventory transaction structures, reporting views, and tenant security rules.

For rollout details, see:

- docs/operating-model-upgrade.md

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

Generate ObjectBox code after entity changes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Build targets:

```bash
flutter build apk
flutter build web
flutter build linux
flutter build windows
```

## Current Status

Implemented and active:

- Core auth and localization flow.
- Multi-tenant schema and tenant-aware access enforcement.
- CRUD-oriented model/controller/validation stack.
- Inventory service foundation for sale and transfer posting workflows.
- Consolidated migration strategy.

Still expanding:

- Additional dedicated UI pages for newer operational tables.
- Deeper end-to-end workflows for procurement and reporting modules.
- Broader test coverage across service and integration layers.

## License

No license is currently defined in this repository.

## Maintainer

@ahriyadh19
