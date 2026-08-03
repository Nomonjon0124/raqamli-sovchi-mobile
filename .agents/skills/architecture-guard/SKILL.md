---
name: architecture-guard
description: Review Flutter code changes against this repository's architecture rules. Use before or after implementing features, during code review, when checking imports, layer boundaries, BLoC usage, dependency injection, UI organization, security, API handling, or testing gaps.
---

# Architecture Guard

## Overview

Use this skill as a project-specific review gate. It checks whether code follows `doc/ARCHITECTURE_TECHNICAL_SPEC.md` and reports concrete violations with file paths and fixes.

## Required First Step

Before reviewing, read:

- `AGENTS.md`
- `doc/ARCHITECTURE_TECHNICAL_SPEC.md`
- The changed files or target feature files

Use `git diff`, `git status`, and targeted searches to find the actual changed surface.

## Review Checklist

### Layer Boundaries

- `domain` must not import Flutter, BLoC, Dio, Firebase, WebSocket, storage, platform plugins, or UI code.
- `application` must orchestrate use cases and depend on domain contracts.
- `data` may import Dio, storage, Firebase, WebSocket, and DTO code.
- `presentation` may import Flutter and BLoC, but must not perform API parsing, caching, token handling, or raw network calls.

### State Management

- Complex flows use `Bloc<Event, State>`.
- Simple view state may use `Cubit<State>`.
- Non-trivial event/state/bloc files are separate.
- States, events, entities, and models are immutable and use `Equatable`.
- BLoC does not catch raw `DioException`, `FirebaseException`, or WebSocket exceptions.

### API and Data

- HTTP uses `dio` through data sources or API client abstractions.
- Repository methods return typed `Either<Failure, T>` or `Result<T>`.
- DTO/model and entity remain separate.
- Mapping code is explicit and testable.
- Token handling stays in secure storage/interceptors, not UI or BLoC.

### UI Organization

- Pages are lean.
- Reusable UI parts are separate widget files.
- Feature widgets live under `presentation/widgets`.
- Shared widgets live under `core/ui/widgets`.
- Feature UI does not hardcode colors, typography, spacing, or radius.
- Screens include loading, empty, error, offline, and permission states where applicable.

### Security and Privacy

- Sensitive screens enforce screenshot protection.
- Tokens and secrets are not logged or stored outside secure storage.
- `baseURL` and flavor config are treated as non-secret.
- PII, chat content, media URLs, and tokens are not printed.
- FCM token lifecycle and logout cleanup are considered when auth/notification code changes.

### Tests

- Risky changes include use case, repository, mapper, BLoC, or widget tests.
- Test gaps are reported even if not fixed.
- Relevant checks are run when feasible.

## Output Format

Lead with findings ordered by severity:

- `P0`: blocks release, data loss, security leak, broken architecture invariant.
- `P1`: likely bug, broken feature flow, missing critical error handling.
- `P2`: maintainability, missing focused test, UI state gap, moderate architecture drift.
- `P3`: small cleanup or consistency issue.

Each finding must include file path, line when available, why it matters, and the concrete fix. If no issues are found, state that clearly and mention remaining risk or tests not run.
