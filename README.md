# Store Management

Store Management is a Flutter application for retail and branch operations, backed by Supabase and prepared for offline-first persistence on IO platforms. The codebase already includes authentication, localization, domain models, validation rules, CRUD-style controllers, database migrations, and focused regression tests.

## What Exists Today

The project is currently strongest in the application core:

- authenticated app bootstrap and session recovery
- localized auth flow and dashboard shell
- structured domain models with tolerant parsing helpers
- validation and controller layers for operational modules
- Supabase schema migrations for primary and supporting records
- ObjectBox bootstrap for local persistence preparation
- focused model serialization and controller tests

Feature screens are still catching up to the model and controller layers, so the repository is well positioned for continued UI, form, and repository work.

## Core Modules

Primary operational modules:

- stores and branches
- products, categories, and tags
- clients and companies
- users and roles
- invoices, payment vouchers, returns, inventory movements, and financial transactions

Supporting records:

- relation records such as `store_branches`, `store_clients`, `store_companies`, `store_users`, and `user_roles`
- association records such as `company_products` and `products_tags`
- detail records such as `store_invoice_items`, `store_return_items`, and `payment_allocations`

The dashboard should expose only primary modules. Supporting records remain important in the data model and controller layer, but they are intentionally not top-level navigation destinations because they depend on parent entities.

## Runtime Flow

- The app starts from `lib/main.dart`.
- Supabase is initialized before the widget tree is rendered.
- Authentication state is managed with `flutter_bloc`.
- Authenticated users are routed to the main shell.
- Unauthenticated users are routed to the auth flow.
- English and Arabic localization are built in.
- On Linux desktop, email confirmation or recovery may complete in the browser, so the auth flow supports manual link handoff when needed.

On Linux desktop, auth state is persisted with file-based local storage so sessions survive restarts.

## Tech Stack

- Flutter
- Dart 3.11+
- Supabase with `supabase_flutter`
- `flutter_bloc` for auth state management
- `decimal` for money precision
- `shared_preferences` for persisted client settings
- ObjectBox for local storage bootstrap on Android, iOS, Linux, macOS, and Windows

## Project Layout

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
test/
  controllers/
  models/
tool/
```

## Architecture Summary

- `lib/models` holds entities, enum types, and parsing helpers.
- `lib/controllers` contains auth coordination and CRUD-oriented business logic.
- `lib/services` contains shared infrastructure such as auth, storage, and local database bootstrap.
- `lib/validations` contains request validation rules by model.
- `lib/views` contains auth UI, dashboard wiring, and reusable presentation components.
- `lib/localization` contains localization delegates and locale control.
- `supabase/migrations` contains schema and database evolution scripts.
- `test` contains focused regression coverage for models and controllers.

## Data Model Conventions

The current model layer follows a few important rules:

- persisted entities keep `@Id() int id = 0` for local ObjectBox identity
- business and relation links are UUID-driven in Dart payloads and models
- money fields use `Decimal` and serialize as strings for precision-safe round trips
- timestamps are stored as epoch milliseconds in maps and payloads
- sync-aware entities carry `synced`, `deletedAt`, and `syncedAt`
- model deserialization accepts both camelCase and snake_case keys for backend compatibility
- enum-backed fields parse case-insensitively to tolerate upstream payload variation

For financial records, the active Dart model uses UUID relations such as `storeUuid`, `clientUuid`, and `sourceUuid`. Numeric relation IDs are not part of the current Dart payload contract for those records.

## Offline Persistence Status

The repository is prepared for ObjectBox-backed local persistence on IO platforms.

- `lib/services/local_database.dart` exposes the platform-safe database entry point.
- `lib/services/local_database_objectbox.dart` initializes ObjectBox on supported IO targets.
- `lib/services/local_database_stub.dart` provides a safe web stub.
- `lib/models/offline_sync_record.dart` defines the local sync queue/cache record.

This is infrastructure readiness, not a complete offline sync workflow yet. Supabase remains the active remote source of truth.

## Database

Supabase schema changes currently live under:

- `supabase/migrations/20260429_000001_initial_schema.sql`

The migration set covers:

- primary entity tables
- relation and association tables
- financial and transaction-detail tables
- indexes and update triggers
- row-level security policies
- authenticated access rules

## Requirements

- Flutter SDK
- Dart SDK compatible with `pubspec.yaml`
- a Supabase project URL and anon key
- a Flutter-capable IDE such as VS Code or Android Studio

Verify the local toolchain:

```bash
flutter doctor
```

## Setup

Install dependencies:

```bash
flutter pub get
```

Provide Supabase configuration in one of these ways:

1. Pass values with `--dart-define`.
2. Pass values with `--dart-define-from-file=.env.local.json`.
3. On Linux, macOS, or Windows desktop only, place `.env.local.json` in the project root and let the app read it directly.

Optional auth redirect configuration:

- set `AUTH_REDIRECT_TO` when confirmation or recovery links should redirect to a fixed callback URL
- on web, the current page URL is used when `AUTH_REDIRECT_TO` is not supplied

Example `.env.local.json`:

```json
{
  "SUPABASE_URL": "https://your-project.supabase.co",
  "SUPABASE_ANON_KEY": "your-anon-key",
  "AUTH_REDIRECT_TO": "https://your-app.example.com/auth/callback"
}
```

If configuration is missing or invalid, the app fails during startup while initializing Supabase.

On Android and iOS, the app cannot read `.env.local.json` from the workspace root at runtime, so mobile builds must receive config through `--dart-define` or `--dart-define-from-file`.

## Running

Run with a config file:

```bash
flutter run --dart-define-from-file=.env.local.json
```

Run with inline defines:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

For web, prefer `--dart-define` or `--dart-define-from-file`. The desktop-only local file fallback does not apply to web builds.

If you launch from VS Code, use a `launch.json` profile that passes the same defines so mobile and desktop runs behave consistently.

## Useful Commands

Install packages:

```bash
flutter pub get
```

Analyze the codebase:

```bash
flutter analyze
```

Run all tests:

```bash
flutter test
```

Run focused tests:

```bash
flutter test test/models/model_serialization_test.dart
flutter test test/controllers/company_products_controller_test.dart
flutter test test/controllers/store_invoices_controller_test.dart
```

Regenerate ObjectBox code after changing ObjectBox entities:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Build common targets:

```bash
flutter build apk
flutter build web
flutter build linux
```

## Current Status

Implemented:

- authentication bootstrap and session-driven auth state handling
- localized auth flow and dashboard shell
- tolerant, tested domain model serialization
- validation and CRUD-style controller layers
- Supabase migrations for primary, relation, and transaction records
- offline persistence bootstrap for IO platforms

Still to expand:

- dedicated feature pages beyond the current shell and auth flow
- repository-style persistence wiring between controllers, Supabase, and local sync
- broader end-to-end flows for inventory, finance, and admin operations
- reporting and analytics flows
- broader validation and controller test coverage

## License

This repository does not currently define a license.

## Maintainer

@ahriyadh19
