# Candidates filter flow fix plan

Status: planned

Target screen: `lib/features/discovery/presentation/pages/candidates_page.dart`

## Problem

`CandidatesPage` currently reads the active filter like this:

- if state is `DiscoveryLoaded`, use `state.selectedFilter`;
- otherwise fall back to `matches`.

Because `_onFetchCandidates` emits `DiscoveryLoading()` without the requested
filter, the UI loses the user's latest filter selection during loading.

Visible bug:

1. User is on `representative`.
2. User taps `recommended`.
3. BLoC emits `DiscoveryLoading()`.
4. Page falls back to `matches`, so the selected pill briefly moves to
   `matches`.
5. Request completes and `DiscoveryLoaded(selectedFilter: 'recommended')` is
   emitted, so the selected pill moves to `recommended`.

This creates the incorrect `representative -> matches -> recommended` visual
flow.

The filter row also uses `SingleChildScrollView + Row`. It works, but it is not
the best fit for a horizontally scrollable list of selectable filter items. It
requires manual separators, has no item builder, and makes future selected-item
scroll behavior harder to manage cleanly.

## Goals

- The selected filter must never fall back to `matches` unless `matches` is the
  actual selected filter.
- Tapping `recommended` from `representative` must show a direct
  `representative -> recommended` transition.
- Loading, empty, error, and success states must all preserve the active filter.
- Filter UI should not use `SingleChildScrollView`.
- Repeated taps on the already selected filter should not trigger unnecessary
  reloads.
- If several filter requests are started quickly, the last requested filter must
  win.
- No user-facing text should be added outside l10n.
- No new dependency should be added for this fix.

## Recommended design

### 1. Replace nullable string filters with a typed filter

Add a small enum for discovery filters, for example:

```dart
enum DiscoveryFilter {
  matches('matches'),
  recommended('recommended'),
  nearby('nearby'),
  representative('representative');

  const DiscoveryFilter(this.apiValue);

  final String apiValue;
}
```

The enum must not return UI labels. Labels stay in
`AppLocalizations`.

Preferred location:

`lib/features/discovery/domain/entities/discovery_filter.dart`

Reason: the filter is part of the discovery domain/query behavior, while its
display text remains presentation-only.

### 2. Make the active filter part of every discovery state

Refactor `DiscoveryState` to always carry `selectedFilter`.

Preferred shape:

```dart
enum DiscoveryStatus { initial, loading, success, empty, failure }

final class DiscoveryState extends Equatable {
  const DiscoveryState({
    this.status = DiscoveryStatus.initial,
    this.selectedFilter = DiscoveryFilter.matches,
    this.candidates = const [],
    this.errorMessage,
  });

  final DiscoveryStatus status;
  final DiscoveryFilter selectedFilter;
  final List<Candidate> candidates;
  final String? errorMessage;
}
```

This avoids fallback logic in the page and keeps one source of truth for the
selected filter across loading, empty, error, and success.

Alternative if keeping sealed states:

- add `selectedFilter` to `DiscoveryInitial`, `DiscoveryLoading`,
  `DiscoveryLoaded`, and `DiscoveryError`;
- make the page read `state.selectedFilter` directly.

The single immutable state class is cleaner for this screen because the page
needs shared fields in all states.

### 3. Emit loading with the requested filter immediately

Update `DiscoveryBloc._onFetchCandidates`:

- resolve the target filter from the event or current state;
- ignore the event if the target filter is already selected and the current
  status is loading/success;
- emit `DiscoveryStatus.loading` with `selectedFilter: targetFilter`;
- after the request completes, emit success, empty, or failure while keeping the
  same `targetFilter`.

Expected behavior:

```text
representative selected
tap recommended
emit loading(selectedFilter: recommended)
emit success/empty/failure(selectedFilter: recommended)
```

There is no intermediate `matches` state.

### 4. Ensure the latest filter request wins

Because users can tap filters quickly, older requests may finish after newer
requests. Add a request sequence guard inside `DiscoveryBloc`:

```dart
int _requestSerial = 0;
```

On each fetch:

- increment `_requestSerial`;
- capture the local request id;
- after awaiting `_getCandidates`, compare the local id with `_requestSerial`;
- if it is not the latest request, do not emit.

This avoids stale results replacing the latest selected filter without adding a
new package.

### 5. Replace `SingleChildScrollView + Row`

Extract the filter row from `CandidatesPage` into:

`lib/features/discovery/presentation/widgets/candidates_filter_bar.dart`

Use:

```dart
SizedBox(
  height: 38,
  child: ListView.separated(
    scrollDirection: Axis.horizontal,
    physics: const BouncingScrollPhysics(),
    itemCount: filters.length,
    separatorBuilder: (_, __) => 8.g,
    itemBuilder: (context, index) {
      final filter = filters[index];
      return AppFilterPill(
        label: filter.label(l10n),
        selected: filter == selectedFilter,
        onTap: filter == selectedFilter ? null : () => onFilterSelected(filter),
      );
    },
  ),
)
```

The label helper can live in the widget file as a private extension/function so
the enum stays free of l10n/UI concerns.

Why this is better:

- the filter bar becomes a normal horizontal list;
- spacing is handled by `separatorBuilder`;
- the page file becomes leaner;
- future auto-scroll-to-selected behavior can be added in one widget;
- selected pills can disable their own tap cleanly.

### 6. Keep `CandidatesPage` focused on layout

After the refactor, `CandidatesPage` should:

- create `DiscoveryBloc`;
- render the header;
- render `CandidatesFilterBar`;
- render `SurveyPromptCard`;
- render candidates/loading/empty/error based on `DiscoveryState.status`.

It should not manually build every filter pill inline.

### 7. Remove debug logging from the BLoC

Remove these development logs from `DiscoveryBloc`:

- `debugPrint('bloc candidates count...')`
- `debugPrint('bloc candidates result...')`

Candidate data can include personal profile information, and the project privacy
rules say private user data must not be logged.

## Implementation steps

1. Add `DiscoveryFilter` enum with API values.
2. Change `GetCandidatesUseCase` and repository/data calls to accept
   `DiscoveryFilter` or convert to `apiValue` at the data boundary.
3. Refactor `DiscoveryState` so `selectedFilter` exists in every state.
4. Update `DiscoveryBloc` to emit loading/error/success with the active filter.
5. Add the request sequence guard so stale responses cannot override the newest
   filter.
6. Extract `CandidatesFilterBar` widget and replace
   `SingleChildScrollView + Row` with `ListView.separated`.
7. Update `CandidatesPage` to read `state.selectedFilter` directly.
8. Remove discovery BLoC debug prints.
9. Add or update tests.
10. Run formatting, analyzer, and relevant tests.

## Test plan

### BLoC tests

- Initial fetch uses `DiscoveryFilter.matches`.
- Fetching `recommended` emits loading with `selectedFilter: recommended`.
- `representative -> recommended` never emits a state with
  `selectedFilter: matches`.
- Error state keeps the requested filter.
- Empty state keeps the requested filter.
- Refresh uses the current selected filter.
- When two filter requests finish out of order, only the latest request emits
  the final visible result.
- Tapping the currently selected filter does not start another fetch unless it
  is an explicit refresh action.

### Widget tests

- `CandidatesFilterBar` renders all four localized filter labels.
- The selected pill matches `DiscoveryState.selectedFilter`.
- Tapping `recommended` dispatches a fetch for `DiscoveryFilter.recommended`.
- The filter list is built with `ListView`/`ListView.separated`, not
  `SingleChildScrollView`.
- Loading state keeps the selected pill on the requested filter.

### Manual QA

1. Open candidates page.
2. Scroll filter row to `representative`.
3. Tap `representative`.
4. Tap `recommended`.
5. Confirm the selected pill moves directly to `recommended`.
6. Confirm it never flashes on `matches`.
7. Rapidly tap `nearby`, `representative`, then `recommended`.
8. Confirm final selected pill and final list both belong to `recommended`.
9. Test error/empty responses and confirm selected filter remains unchanged.

## Definition of done

- `SingleChildScrollView` is no longer used for candidates filters.
- The filter selection is stable during loading/error/empty/success.
- `representative -> recommended` does not pass through `matches`.
- Stale network responses cannot overwrite the latest filter selection.
- `CandidatesPage` is leaner and filter UI is extracted to a widget file.
- Debug logs containing candidate information are removed.
- `flutter analyze` passes.
- `dart format --set-exit-if-changed .` passes.
- Relevant discovery BLoC/widget tests pass.
