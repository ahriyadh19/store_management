# Data Architecture

This project separates domain entities, mapping, local persistence, and remote synchronization into distinct concerns.

## Layer Boundaries

- `lib/models/` contains pure application entities. These classes represent business data and no longer declare persistence annotations.
- `lib/data/entity_mapper.dart` defines the mapping boundary used to translate between application entities and storage payloads.
- `lib/views/pages/model_module_pages.dart` assembles `EntityMapper` instances for each domain type and routes CRUD operations through local and remote adapters.
- `lib/services/local_database_drift.dart` provides the local Drift + SQLite cache layer and sync metadata store.
- Supabase remains the remote source of truth for authenticated users, tenant-scoped relational data, and synchronized writes.

## Domain Models

Domain models are shared across Flutter, web, and desktop code paths.

- Entities keep business fields, validation-friendly constructors, and value semantics.
- Persistence-specific concerns are handled outside the entity type through mapper objects.
- Form logic and table rendering work from domain entities and mapper output instead of binding directly to a database API.

## Mapping Strategy

`EntityMapper<T>` is the explicit mapping contract between layers.

- `fromDomainMap` and `toDomainMap` cover application-facing transformations.
- `fromRemotePayload` and `toRemotePayload` isolate Supabase payload formatting.
- `fromLocalPayload` and `toLocalPayload` isolate Drift row formatting.

Current mappers default local and remote payloads to the entity's canonical map shape. That keeps behavior stable while making it safe to diverge storage schemas later without rewriting UI or business logic.

## Remote Source Of Truth

Supabase is the authoritative backend.

- Authentication and session management run through Supabase Auth.
- PostgreSQL tables in `supabase/migrations/20260508_000001_complete_improved_schema.sql` define the canonical relational schema.
- Foreign keys, owner scoping, and RLS policies keep centralized data consistent.
- Remote writes update `updatedAt` timestamps and preserve tenant-aware query scoping.

## Local Offline Cache

Drift + SQLite provides the offline-first cache layer.

- Critical business tables are mirrored locally for fast reads.
- `sync_records` stores pending write metadata, conflict timestamps, and remote baseline timestamps.
- Business rows are cached separately from sync metadata so local reads do not depend on encoded sync payloads.
- Local writes can proceed when offline and are queued with sync state markers for later reconciliation.

## Synchronization Model

Synchronization keeps remote consistency while preserving newer edits.

- Remote rows are normalized with sync metadata before being cached locally.
- Pending local updates are merged with remote rows using timestamp-aware conflict checks.
- Pending deletes win over stale remote rows to avoid resurrecting deleted records.
- Conflict timestamps are recorded when incoming remote data overtakes a non-synced local edit.
- Partial sync is supported at the table and record level because local caches and sync metadata are keyed by model type and record UUID.

## Expected Data Flow

1. UI creates or edits a domain entity.
2. `EntityMapper` converts that entity into local or remote payloads.
3. Supabase persists authoritative relational data when online.
4. Drift persists local relational cache rows plus sync metadata.
5. Hybrid reads merge authoritative remote rows with still-pending local changes.

This separation keeps the app scalable, testable, and adaptable if either the remote API shape or local schema needs to evolve.