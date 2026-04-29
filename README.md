# Store Management

Store Management is a Flutter application for store operations backed by Supabase. The current codebase already includes authentication, localization, a dashboard shell, domain models, validation classes, CRUD-style controllers, schema migrations, and focused model/controller tests.

## Overview

The app is organized around store administration and related business entities:

- companies and company product pricing
- products, categories, and tags
- users, roles, and role assignments
- store relationships such as store-company, store-client, and store-user
- client-linked financial records for each store:
  - invoices
  - payment vouchers
  - returns
  - financial transaction ledger entries

The UI currently covers authentication and a dashboard-style landing screen. The model and controller layers are more complete than the feature screens, so the project is in a good state for continuing page, form, and persistence work.

## Current App Flow

- The app starts in `lib/main.dart`.
- Supabase is initialized before the widget tree is rendered.
- Authentication state is managed with `flutter_bloc`.
- Authenticated users are routed to the main index screen.
- Unauthenticated users are routed to the auth flow.
- Localization is built in for English and Arabic.

On Linux desktop, Supabase auth uses file-based local storage so session state survives app restarts.

## Tech Stack

- Flutter
- Dart 3.11+
- Supabase and `supabase_flutter`
- `flutter_bloc` for auth state management
- `decimal` for precision-safe money fields
- `shared_preferences` for persisted client settings such as locale
- ObjectBox for local offline persistence bootstrap on IO platforms

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
test/
  controllers/
  models/
```

## Architecture Notes

- `lib/models` contains entities, enum types, and parsing helpers.
- `lib/controllers` contains auth state handling and CRUD-style business logic.
- `lib/services` contains shared infrastructure such as auth repository and storage helpers.
- `lib/validations` contains request validation rules by entity.
- `lib/views` contains auth UI and reusable view components.
- `lib/localization` contains the localization delegate and locale controller.
- `supabase/migrations` contains schema and database evolution scripts.
- `test` contains focused model serialization and controller tests.

## Implemented Modules

Controllers currently exist for:

- authentication
- companies
- company products
- categories
- products
- product tags
- tags
- roles
- users
- user roles
- store invoices
- store payment vouchers
- store returns
- store financial transactions

Models currently cover:

- core entities such as company, product, category, tag, client, user, role, and store
- relationship entities such as company products, product tags, store-client, store-company, store-user, and user roles
- financial entities such as store invoice, store payment voucher, store return, and store financial transaction
- transaction detail entities such as store invoice item, store return item, inventory movement, and payment allocation

## Financial Data Model

Financial records are scoped to both the store and the client. Each record carries both sides of the relationship:

- `storeId` and `storeUuid`
- `clientId` and `clientUuid`

This keeps invoices, vouchers, returns, and ledger entries attached to a specific client within a specific store rather than being generic store-level transactions.

Money values use `Decimal` in Dart to avoid precision loss, and relation-heavy models use UUID-only relation links while keeping entity-local primary `id` fields where needed.

## Offline Persistence Prep

The app is now prepared for ObjectBox-based offline storage on IO platforms.

- `lib/services/local_database.dart` exposes a platform-safe local database entry point.
- `lib/services/local_database_objectbox.dart` initializes the ObjectBox store on Android, iOS, Linux, macOS, and Windows.
- `lib/services/local_database_stub.dart` keeps web builds safe by exposing a no-op implementation.
- `lib/models/offline_sync_record.dart` provides a generic local sync record entity keyed by `modelType + uuid` for caching serialized domain records.

This is an infrastructure/bootstrap step. It does not yet replace Supabase reads and writes with repository-backed offline sync flows.

## Database

Supabase schema changes currently live in:

- `supabase/migrations/20260429_000001_initial_schema.sql`

The schema includes:

- base entity tables
- relationship tables
- financial and transaction-detail tables
- indexes and update triggers
- row-level security policies
- authenticated access rules

## Requirements

- Flutter SDK
- Dart SDK compatible with the version constraint in `pubspec.yaml`
- A Supabase project with URL and anon key
- A Flutter-capable IDE such as VS Code or Android Studio

Check the local toolchain:

```bash
flutter doctor
```

## Setup

Install dependencies:

```bash
flutter pub get
```

Provide Supabase configuration in one of these ways:

1. Pass `--dart-define` values directly.
2. Pass `--dart-define-from-file=.env.local.json`.
3. On Linux, macOS, or Windows desktop, you can also create a local `.env.local.json` file in the project root and let the app read it directly.

Optional auth redirect configuration:

- Set `AUTH_REDIRECT_TO` when you want email confirmation and password reset links to redirect to a specific URL across platforms.
- On web, the app falls back to the current page URL when `AUTH_REDIRECT_TO` is not provided.

Example `.env.local.json`:

```json
{
  "SUPABASE_URL": "https://your-project.supabase.co",
  "SUPABASE_ANON_KEY": "your-anon-key",
  "AUTH_REDIRECT_TO": "https://your-app.example.com/auth/callback"
}
```

If no valid configuration is available, the app throws a startup error during Supabase initialization.

On Android and iOS, the app cannot read `.env.local.json` from your project root at runtime, so mobile launches must use `--dart-define` or `--dart-define-from-file`.

## Running The App

Run with a local config file:

```bash
flutter run --dart-define-from-file=.env.local.json
```

If you launch from VS Code, use a `launch.json` profile that passes `--dart-define-from-file=.env.local.json` so Android and iOS builds receive the values automatically.

Run with inline defines:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

For web, prefer `--dart-define` or `--dart-define-from-file`; web builds do not use the local file fallback.

## Useful Commands

Fetch packages:

```bash
flutter pub get
```

Analyze the project:

```bash
flutter analyze
```

Run all tests:

```bash
flutter test
```

Regenerate ObjectBox code after changing ObjectBox entities:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Run focused tests:

```bash
flutter test test/models/model_serialization_test.dart
flutter test test/controllers/company_products_controller_test.dart
flutter test test/controllers/store_invoices_controller_test.dart
```

Build common targets:

```bash
flutter build apk
flutter build web
flutter build linux
```

## Current Status

Implemented:

- Supabase authentication bootstrap
- auth state handling with BLoC
- localized auth flow and dashboard shell
- domain model layer with tolerant parsing helpers
- request validation layer
- CRUD-style controller layer
- Supabase schema migrations for the core domain and transaction detail tables
- store-client-linked financial records
- focused model and controller tests

Still to expand:

- dedicated feature screens beyond auth and the current dashboard shell
- richer persistence wiring between controllers and Supabase data access
- reporting and analytics flows
- broader validation and controller test coverage

## Development Notes

- Models serialize timestamps as epoch milliseconds.
- Precision-sensitive money fields are represented with `Decimal`.
- Relation models consistently keep numeric ids and string UUIDs side by side.
- Linux email confirmation may finish in the browser, so the auth flow includes a manual link-paste path.

## License

This repository does not currently define a license.

## Developer

@ahriyadh19
