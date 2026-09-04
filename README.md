# AppReviewRequest

AppReviewRequest is a Swift Package for quickly integrating an app rating request flow into an iOS application.

The package presents a custom SwiftUI review request sheet after a configured number of application sessions. It tracks whether the user has already accepted the rating request and avoids showing the prompt again after the App Store review link has been opened.

## Features

- SwiftUI integration through a view modifier.
- Configurable sheet icon, title, message, button titles, tint color, and App Store application ID.
- Session-based presentation rules.
- First prompt can be delayed until a specific session count.
- Later prompts can repeat every configured number of sessions.
- Uses App Store write-review URLs for rating flow handoff.

## Requirements

- Swift 6.3
- iOS 26.0+
- macOS 26.0+

## Installation

Add the package to your Swift Package Manager dependencies and link the `AppReviewRequestUI` library product to your application target.

```swift
.package(url: "https://github.com/Ausianovich/AppReviewRequest.git", from: "1.0.0")
```

```swift
.product(name: "AppReviewRequestUI", package: "AppReviewRequest")
```

## Usage

Import `AppReviewRequestUI`, create a `ReviewRequestSheetConfiguration`, and attach the modifier to the root view that should own the rating request flow.

```swift
import SwiftUI
import AppReviewRequestUI

struct RootView: View {
    var body: some View {
        ContentView()
            .rateRequestSheet(
                configuration: ReviewRequestSheetConfiguration(
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
            )
    }
}
```

## Presentation Rules

The request sheet is evaluated when the scene becomes active.

A sheet is presented only when all of the following are true:

- The user has not already approved the rating request.
- The current launch/session count is greater than or equal to `firstSessionPresentation`.
- The current launch/session count is divisible by `eachNextSessionPresentation`.
- The sheet has not already been presented during the same session.

When the user taps the rate button, the package opens:

```text
https://apps.apple.com/app/id<applicationID>?action=write-review
```

After opening the App Store review link, the package stores the approval state and suppresses future prompts.

## Package Structure

- `AppReviewRequest` contains the presentation state and reducer logic.
- `AppReviewRequestUI` contains the SwiftUI sheet and public view modifier.
- `AppReviewRequestTests` contains package tests.

## Dependencies

- Composable Architecture
- AppGlobalState
