---
name: flutter-feature-builder
description: Build or extend Flutter features in this repository using the project architecture. Use when creating a new feature, screen flow, BLoC/Cubit, domain entity, use case, repository contract, data model, widget group, or test skeleton under lib/features.
---

# Flutter Feature Builder

## Overview

Use this skill to create feature code that follows `doc/ARCHITECTURE_TECHNICAL_SPEC.md`. Keep the feature-first layout, BLoC presentation flow, `get_it` dependency registration, immutable `Equatable` state, and separate widget files.

## Required First Step

Before editing files, read:

- `AGENTS.md`
- `doc/ARCHITECTURE_TECHNICAL_SPEC.md`
- Existing files in the target feature, if any

If the requested implementation conflicts with the architecture spec, explain the conflict before coding.

## Feature Workflow

1. Identify the bounded context: `auth`, `profile`, `discovery`, `match`, `chat`, `feed`, `notifications`, `moderation`, `settings`, or a new feature approved by the user.
2. Create or extend the standard folder structure:

```text
lib/features/<feature>/
  domain/
    entities/
    repositories/
    failures/
  application/
    use_cases/
  data/
    models/
    data_sources/
    repositories/
  presentation/
    bloc/
    pages/
    widgets/
```

3. Define domain entities and value objects first. Use immutable classes with `Equatable`.
4. Define repository contracts in `domain/repositories`.
5. Add use cases in `application/use_cases`; each use case exposes `call`.
6. Add data models, data sources, mappers, and repository implementations.
7. Add BLoC/Cubit files under `presentation/bloc`.
8. Add page files under `presentation/pages`.
9. Extract reusable UI parts into `presentation/widgets`; do not put many widgets in the page file.
10. Register dependencies in `lib/app/di/service_locator.dart` when the DI root exists.
11. Add focused tests under matching `test/features/<feature>/...` paths.

## BLoC Rules

- Use `Bloc<Event, State>` for complex flows and `Cubit<State>` for simple view state.
- Put non-trivial `bloc`, `event`, and `state` in separate files.
- BLoC imports use cases, entities, failures, and presentation state only.
- BLoC must not import `dio`, WebSocket packages, Firebase, storage, or UI widgets.
- Emit immutable `Equatable` states.
- Map `Either<Failure, T>` or `Result<T>` to UI states explicitly.

## UI Rules

- Keep pages lean and mostly layout-focused.
- Use shared design-system widgets from `core/ui/widgets` when available.
- Create feature widgets when UI is feature-specific.
- Avoid hardcoded colors, spacing, typography, and radius.
- Include loading, empty, error, offline, and permission states where relevant.
- Make text localization-ready.

## Naming

- Entity: `UserProfile`, `Conversation`, `Message`.
- Model: `UserProfileModel`.
- Repository contract: `ProfileRepository`.
- Repository implementation: `ProfileRepositoryImpl`.
- Use case: `LoadProfileUseCase`.
- BLoC: `ProfileBloc`, `ProfileEvent`, `ProfileState`.
- Page: `ProfilePage`.
- Feature widget: `ProfileHeader`, `ProfilePhotoGrid`.

## Validation

Run the narrowest useful checks after implementation. Prefer `dart format --set-exit-if-changed .`, `flutter analyze`, and relevant unit/widget/BLoC tests. If checks cannot be run, report why.
