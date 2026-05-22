# Project Audit

Date: 2026-05-21

## Scope

This audit reviewed the current repository state across:

- implementation surfaces in `lib/`
- automated coverage in `test/`
- status and planning documents in `docs/` and `README.md`
- local quality checks with `flutter analyze` and `flutter test`

## Current Snapshot

- IDE diagnostics report no compile errors in the workspace.
- `flutter test` passed with 150 tests.
- `flutter analyze` reported 4 info-level issues and no analyzer errors.
- CRUD coverage appears present for the tracked core, sales/finance, and ERP entities. The codebase contains model, controller, and UI wiring for the entities listed in `docs/crud-completion-matrix.md`, especially through the shared module pages in `lib/views/pages/model_module_pages.dart`.

## What Is Missing Or Not Complete

### 1. Operational validation is still incomplete

These items are already acknowledged in `docs/project-tracking.md` and remain open from an actual delivery standpoint:

- `DB-002` Migration Rollout Validation still needs live Supabase validation.
- `DB-006` Migration Deployment Verification is still pending.
- `QA-001` Permission Catalog Backfill QA still needs confirmation against real tenant data.

These are not local code gaps, but they are still incomplete project work.

### 2. CRUD is broadly present, but quality coverage is uneven

No obvious missing CRUD page/controller pair was found for the entities tracked in the CRUD matrix. The remaining gaps are mostly around validation and polish instead of missing create/read/update/delete plumbing.

Concrete gaps found:

- No dedicated widget test was found for `SettingsPage`.
- Reports are implemented, but the page still contains several hard-coded English strings instead of using localization.
- The CRUD matrix itself is stale and no longer reflects the latest work completed on 2026-05-20.

## What Needs To Be Fixed Or Improved

### Analyzer cleanups

`flutter analyze` currently reports these cleanup items:

1. Replace deprecated `DropdownButtonFormField.value` usage with `initialValue` in `lib/views/pages/inventory_page.dart`.
2. Simplify null-aware collection usage in `lib/views/pages/model_module_pages.dart`.

These are not breaking issues, but they should be fixed to keep the codebase current with Flutter and Dart lints.

### Testing improvements

Recommended additions:

1. Add a dedicated widget test for `lib/views/pages/settings_page.dart`.
2. Expand widget coverage for user-facing configuration flows such as theme mode, language switching, app bar behavior, and storage preference persistence.

### Localization improvements

`lib/views/pages/reports_page.dart` still uses multiple hard-coded English labels and descriptions such as:

- `Operational Snapshot`
- `Sync Health`
- `Recent Activity`
- cache status copy in the hero and sync cards

These strings should be moved into the localization layer so the page matches the rest of the bilingual app.

### Documentation alignment

The docs need cleanup so they describe the current repository accurately:

1. Update `docs/crud-completion-matrix.md` because its last-updated date and next-step notes lag behind the newer completed work.
2. Update `README.md` because the `Still expanding` section still lists items that are already marked completed elsewhere.
3. Keep `docs/project-tracking.md` as the source of truth and refresh the supporting docs after major feature completion.

## What Needs To Be Removed Or Updated

### Remove stale claims from README

The following README items should be removed or rewritten because they are outdated relative to the current tracker:

- `UUID-free administration flows for permission assignment screens`
- `Deeper end-to-end workflows for procurement and reporting modules`

Those areas already have completed work recorded in `docs/project-tracking.md`.

### Remove stale status drift between docs

`docs/crud-completion-matrix.md` should be treated as outdated until refreshed. It is useful as a structure reference, but not as the latest status source.

## Bottom Line

- CRUD implementation is mostly in place for the tracked entities.
- The main unfinished work is live environment validation, documentation drift cleanup, localization polish, and focused test expansion.
- Nothing in the current local audit suggests a major missing CRUD module, but several non-blocking improvements should be scheduled before calling the project fully complete.

## Recommended Order

1. Fix the 4 analyzer cleanup items.
2. Localize `ReportsPage`.
3. Add `SettingsPage` widget coverage.
4. Refresh `README.md` and `docs/crud-completion-matrix.md`.
5. Complete Supabase rollout validation and permission backfill QA in a real environment.