# Store Management

Store Management is a Flutter application for organizing core store data such as companies, products, categories, tags, users, roles, and related mappings.

The project currently includes a foundational app shell plus domain models, request and response services, input validations, and CRUD-style controllers for the main entities.

## Overview

This codebase is structured around a simple layered approach:

- `models`: domain entities and serialization helpers
- `controllers`: CRUD-oriented application logic
- `validations`: request validation for each entity
- `services`: shared request, response, and UUID utilities
- `views`: UI components and pages

At the moment, the app starts on a basic home screen and the controller layer works as an in-memory logic layer. It is ready for the next step of connecting forms, pages, and persistence.

## Features

- Flutter application scaffold with Material UI
- Centralized request and response models
- Entity models for store-related data
- Validation classes for controller input
- CRUD-style controllers for:
	- companies
	- company products
	- categories
	- products
	- tags
	- roles
	- users
	- user roles
	- product tags

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
test/
```

## Requirements

- Flutter SDK
- Dart SDK
- Android Studio, VS Code, or another Flutter-compatible IDE

To verify your environment:

```bash
flutter doctor
```

## Getting Started

Clone the repository and install dependencies:

```bash
git clone https://github.com/ahriyadh19/store_management.git
cd store_management
flutter pub get
```

Run the application:

```bash
flutter run
```

## Useful Commands

Run static analysis:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

Build release artifacts:

```bash
flutter build apk
flutter build web
```

## Current Status

This project is in an early implementation phase.

Implemented:

- base Flutter app entry point
- domain models
- validation layer
- controller layer

Planned or recommended next steps:

- connect controllers to UI forms and pages
- add local or remote data persistence
- add unit tests for controllers and validations
- expand the user interface for real store workflows

## Development Notes

- The current controllers operate on in-memory model instances.
- The project is suitable for extending into a local database or API-backed architecture.
- Input validation is separated from controller logic to keep behavior easier to maintain and test.

## License

This repository does not currently define a license.
