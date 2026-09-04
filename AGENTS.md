# Agent Notes

This Swift Package provides a reusable SwiftUI app rating request flow.

## Project Purpose

AppReviewRequest helps iOS applications show a custom rating request sheet after configured application sessions. The package owns the presentation rules, stores whether the user has accepted the rating request, and opens the App Store write-review URL when the user chooses to rate the app.

## Structure

- `Sources/AppReviewRequest` contains core state, reducers, and shared persistence keys.
- `Sources/AppReviewRequestUI` contains the SwiftUI integration layer and sheet UI.
- `Tests/AppReviewRequestTests` contains tests for the core package behavior.

## Public API

The primary integration point is:

```swift
.rateRequestSheet(configuration: ReviewRequestSheetConfiguration)
```

Consumers configure the sheet with `ReviewRequestSheetConfiguration`, including localized strings, icon, tint color, App Store application ID, and session thresholds.

## Configuration Example

```swift
import SwiftUI
import AppReviewRequestUI

let reviewRequestConfiguration = ReviewRequestSheetConfiguration(
    icon: Image(systemName: "star.fill"),
    title: "Enjoying the app?",
    message: "Please take a moment to rate it on the App Store.",
    rateButtonTitle: "Rate App",
    maybeLaterButtonTitle: "Maybe Later",
    tint: .blue,
    applicationID: "1234567890",
    firstSessionPresentation: 3,
    eachNextSessionPresentation: 5
)
```

## Implementation Notes

- The package uses SwiftUI and the Composable Architecture.
- Presentation is driven by scene phase changes and session count state.
- The rating request should not be shown after `rateRequestAproved` is set to `true`.
- Keep changes scoped to the package. Do not modify vendored or checked-out dependency packages unless explicitly requested.
- Prefer Swift concurrency APIs and SwiftUI patterns already used in the package.
