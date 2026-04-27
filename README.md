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

Money values use `Decimal` in Dart to avoid precision loss, and relation-heavy models consistently use numeric `...Id` fields plus string `...Uuid` fields.

## Database

Supabase schema changes currently live in:

- `supabase/migrations/20260427_000001_store_management_schema.sql`
- `supabase/migrations/20260428_000002_transaction_detail_models.sql`

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
3. Create a local `.env.local.json` file in the project root for non-web runs.

Example `.env.local.json`:

```json
{
  "SUPABASE_URL": "https://your-project.supabase.co",
  "SUPABASE_ANON_KEY": "your-anon-key"
}
```

If no valid configuration is available, the app throws a startup error during Supabase initialization.

## Running The App

Run with a local config file:

```bash
flutter run --dart-define-from-file=.env.local.json
```

Run with inline defines:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

For web, prefer `--dart-define` or `--dart-define-from-file`; the fallback `.env.local.json` file path is only read in non-web builds.

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
