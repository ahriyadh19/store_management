# Store Management

Store Management is a Flutter application for handling store operations with a Supabase-backed authentication flow and a structured domain layer for inventory, relationships, and store financial records.

The codebase already includes authentication, a dashboard shell, domain models, request/response services, validation classes, CRUD-style controllers, unit tests, and a consolidated Supabase migration for the current schema.

## What The App Covers

The project is built around store operations and related business entities:

- companies and company-product pricing
- products, categories, and tags
- users, roles, and role assignments
- store relations such as store-company and store-client
- client-linked financial records for each store:
  - invoices
  - payment vouchers
  - returns
  - financial transaction ledger entries

## Current Application Flow

- The app starts in [lib/main.dart](lib/main.dart).
- Supabase is initialized before the UI is rendered.
- Authentication state is managed with `flutter_bloc`.
- Authenticated users are routed to the main index screen.
- Unauthenticated users are routed to the auth screen.

At the moment, the UI shell is in place and the domain/controller layer is more complete than the feature screens. This makes the project a good base for continuing with forms, pages, and persistence-driven workflows.

## Architecture

The project follows a simple layered structure:

- `lib/models`: entity models, serialization, parsing helpers
- `lib/controllers`: CRUD-style business logic and auth state management
- `lib/validations`: request validation per entity
- `lib/services`: shared request, response, auth, storage, and UUID utilities
- `lib/views`: UI screens such as authentication
- `supabase/migrations`: database schema and policy definitions
- `test`: model and controller tests

## Key Modules

Implemented controller coverage currently includes:

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

Implemented model coverage currently includes:

- core entities such as `Company`, `Product`, `Categories`, `Tags`, `Client`, `User`, `Roles`
- relationship entities such as `CompanyProducts`, `ProductsTags`, `StoreCompany`, `StoreClient`, `StoreUser`, `UserRoles`
- financial entities such as `StoreInvoice`, `StorePaymentVoucher`, `StoreReturn`, `StoreFinancialTransaction`
- transactional detail entities such as `StoreInvoiceItem`, `StoreReturnItem`, `InventoryMovement`, `PaymentAllocation`

## Financial Module

The financial module is scoped to both the store and the client.

Each financial record carries:

- `storeId` and `storeUuid`
- `clientId` and `clientUuid`

This keeps invoices, vouchers, returns, and ledger transactions attached to a specific client inside a specific store rather than being store-level records only.

## Project Structure

```text
lib/
  main.dart
  index.dart
  controllers/
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

## Requirements

- Flutter SDK
- Dart SDK
- Supabase project with URL and anon key
- Android Studio, VS Code, or another Flutter-compatible IDE

Verify your environment:

```bash
flutter doctor
```

## Setup

Install dependencies:

```bash
flutter pub get
```

Provide Supabase configuration in one of these ways:

1. Use `--dart-define` values.
2. Use `--dart-define-from-file=.env.local.json`.
3. Create a local `.env.local.json` file in the project root.

Example `.env.local.json`:

```json
{
  "SUPABASE_URL": "https://your-project.supabase.co",
  "SUPABASE_ANON_KEY": "your-anon-key"
}
```

If no valid configuration is found, the app throws a startup error during Supabase initialization.

## Running The App

Run with local config file:

```bash
flutter run --dart-define-from-file=.env.local.json
```

Run with inline defines:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

## Database

The database schema lives in `supabase/migrations` and is currently consolidated into a single main migration file for the project domain.

That migration defines:

- base entity tables
- relationship tables
- financial tables
- indexes
- update triggers
- row-level security
- authenticated access policies

## Useful Commands

Install dependencies:

```bash
flutter pub get
```

Analyze the project:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

Run a focused test file:

```bash
flutter test test/models/model_serialization_test.dart
flutter test test/controllers/store_invoices_controller_test.dart
```

Build common targets:

```bash
flutter build apk
flutter build web
flutter build linux
```

## Current Status

Implemented today:

- Supabase authentication bootstrap
- auth state handling with BLoC
- base dashboard shell
- domain model layer with safer parsing helpers
- request validation layer
- CRUD-style controller layer
- consolidated Supabase schema migration
- store-client-linked financial module
- focused model and controller tests

Still worth improving:

- dedicated UI screens for domain modules
- persistence wiring between controllers and Supabase tables
- reporting and analytics flows
- broader controller and validation test coverage

## Model Improvements

The domain layer now includes:

- enum-backed financial and inventory state instead of unchecked raw strings in core transaction models
- exact decimal parsing for money fields used by pricing, credit, invoices, vouchers, returns, and ledger entries
- transactional detail models for invoice lines, return lines, stock history, and payment allocations
- richer inventory planning fields on company products such as `costPrice`, `sku`, `barcode`, `reorderLevel`, and `reorderQuantity`

## Development Notes

- Models serialize timestamps as epoch milliseconds.
- Relation-heavy models use numeric `...Id` fields and string `...Uuid` fields.
- Financial records follow the same convention and must include both store and client linkage.
- The current codebase is structured to keep models, validations, and controllers easy to test independently.

## License

This repository does not currently define a license.

## Developer

@ahriyadh19
