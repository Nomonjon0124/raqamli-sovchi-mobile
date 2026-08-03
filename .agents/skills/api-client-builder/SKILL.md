---
name: api-client-builder
description: Build API integration code for this Flutter app using Dio, data sources, repositories, DTO models, mappers, typed Failure, and Either/Result. Use when adding endpoints, networking infrastructure, interceptors, token handling, upload/download APIs, or repository data flows.
---

# Api Client Builder

## Overview

Use this skill to connect backend APIs without leaking network concerns into domain or presentation layers. Follow `doc/ARCHITECTURE_TECHNICAL_SPEC.md` for Dio, `Either<Failure, T>`, secure token handling, and manual model/entity mapping.

## Required First Step

Before editing files, read:

- `AGENTS.md`
- `doc/ARCHITECTURE_TECHNICAL_SPEC.md`
- Existing `core/network`, `core/errors`, `core/security`, and target feature data files

Do not add API packages or generators unless the architecture spec allows them or the user explicitly approves.

## API Workflow

1. Define or reuse the domain entity.
2. Define or update the repository contract in `domain/repositories`.
3. Define the use case in `application/use_cases`.
4. Create DTO/model classes in `data/models` using manual `fromJson/toJson`.
5. Add mappers from model to entity.
6. Add remote data source methods in `data/data_sources`.
7. Implement the repository in `data/repositories`.
8. Map `DioException` and backend errors to `Failure` at the data/repository boundary.
9. Register dependencies in `lib/app/di/service_locator.dart` when the DI root exists.
10. Add unit tests for mapper, repository success/failure, and use case behavior.

## Boundary Rules

- UI and BLoC must not import `dio`.
- Domain must not import DTO/model classes.
- Repositories expose entities, not API models.
- `try/catch` stays in data sources or repository implementations.
- Raw `DioException` never reaches BLoC or UI.
- Token read/write goes through `TokenStore` or secure storage abstraction.
- Request logging is disabled in release and never logs PII, tokens, chat text, or media URLs.

## Return Types

Repository contracts use typed results:

```dart
abstract interface class ProfileRepository {
  Future<Either<Failure, UserProfile>> getMyProfile();
}
```

Use `Either<Failure, T>` or the project's `Result<T>` type consistently with existing code.

## Dio Rules

- Set connect, receive, and send timeouts.
- Use interceptors for auth headers and token refresh.
- Use `CancelToken` for cancellable screen-bound requests when needed.
- Use multipart upload with progress callbacks for media.
- Retry only idempotent requests.
- Treat upload timeout separately from normal request timeout.

## Model Rules

- Use immutable model classes with `Equatable`.
- Keep DTO field names aligned with API schema.
- Keep entity field names aligned with domain language.
- Convert model to entity explicitly.
- Write `copyWith` only when needed.
- Consider `json_serializable` only when manual DTO work becomes a real maintenance problem.

## Failure Mapping

Map these cases deliberately:

- Connection timeout.
- Receive/send timeout.
- No internet.
- Unauthorized/session expired.
- Forbidden.
- Not found.
- Validation error.
- Rate limited.
- Server error.
- Unknown error.

## Validation

Run focused tests for mapper and repository paths. Run `flutter analyze` and formatting when feasible. If the endpoint depends on backend details not available locally, use a fake data source or mock and state the assumption.
