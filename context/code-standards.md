# Code Standards

## General

- Keep views small and single-purpose — split if over 100 lines
- Fix root causes, do not layer workarounds
- Do not mix unrelated concerns in one view or model
- Prefer composition over inheritance
- **Document complex logic with inline comments** — this is a teaching project

---

## Swift

- Use `let` by default, `var` only when mutation needed
- Explicit types for public APIs, inference acceptable for locals
- Guard early returns over nested if-let pyramids
- Prefer `Codable` for JSON parsing
- Use `Result` type for async error handling
- **No implicit force unwrapping (`!`)** except in `@IBOutlet` contexts
- **No `fatalError` in production code paths**

---

## SwiftUI

- Use `@State` for view-private mutable state
- Use `@Query` for SwiftData-backed lists
- Use `@Bindable` when editing model properties (SwiftData)
- Use `@StateObject` for view-owned ObservableObjects
- Use `@ObservedObject` for injected ObservableObjects
- **Use `@EnvironmentObject` for shared AuthViewModel (single instance)**
- Prefer `NavigationStack` over deprecated `NavigationView`
- Use `sheet`, `alert`, `confirmationDialog` for overlays
- Keep preview providers up-to-date with sample data

---

## SwiftData

- Mark all persistent models with `@Model` macro
- Use `var` for all model properties (required by SwiftData)
- Provide default values or make properties optional
- Use `@Relationship` sparingly — prefer simple IDs in MVP
- Fetch with `@Query`, modify via `modelContext`
- **All data is local** — no external cloud for MVP

---

## Naming Conventions

- **Views**: `*View` suffix (e.g., `WelcomeView`, `JobListingsView`)
- **ViewModels**: `*ViewModel` suffix (e.g., `AuthViewModel`)
- **Models**: Descriptive nouns (e.g., `JobPosting`, `UserProfile`)
- **Services**: `*Service` suffix (e.g., `JobService`)
- **Protocols**: `*able` suffix or descriptive nouns
- **Extensions**: Group by purpose (e.g., `Date+Formatting.swift`)
- **Files**: Match primary type name exactly
- **Swift files**: Use PascalCase (e.g., `LoadingView.swift` not `loadingview.swift`)

---

## Styling

- Use SwiftUI modifiers for styling — no CSS/tailwind here
- Define colors in Assets.xcassets, reference by name
- Use semantic color names (e.g., `primaryComHandColor`, `secondaryComHandColor`)
- Prefer system fonts (`.body`, `.headline`) with Dynamic Type
- SF Symbols for icons — use multicolor variants where appropriate
- Consistent spacing using `padding()` modifiers

**Community Hands Colors:**
- Primary: `#25960E` (primaryComHandColor)
- Use green theme throughout

---

## Data and Storage

- **User data belongs in SwiftData** — persistent models
- Small preferences can use `@AppStorage` (UserDefaults wrapper) — auth state, onboarding
- **Never store large content directly in UserDefaults**
- All SwiftData is local — no cloud for MVP

---

## File Organization

- `CommunityHands/Models/` — All `@Model` classes
- `CommunityHands/Views/` — SwiftUI Views, grouped by feature
  - `Onboarding/` — Welcome, SignUp, Login, Terms, Bio
  - `Customer/` — Homeowner-side views (post job, browse helpers)
  - `Helper/` — Teen-side views (browse jobs, schedule)
- `CommunityHands/ViewModels/` — ObservableObject classes
- `CommunityHands/Services/` — Helpers, utilities
- `CommunityHands/Preview Content/` — Sample data for previews

---

## Preview Providers

```swift
#Preview {
    ContentView()
        .modelContainer(for: [User.self, JobPosting.self], inMemory: true)
        .environmentObject(AuthViewModel())
}
```

- Always provide in-memory model container
- Include sample data that demonstrates the view
- Use `.previewDisplayName()` for multiple previews
- Add environment objects if view requires them

---

## Comments for Teaching

**Every block of code that requires explanation should have a comment:**

```swift
// MARK: - Animation Timing
// Defines the delays for sequential animations
// Logo appears first, then text, then buttons
private let logoAnimationDelay: Double = 0.2
private let textAnimationDelay: Double = 0.4
private let totalDuration: Double = 1.8

// MARK: - Navigation State
// Tracks which step of the auth flow user is on
// Used by RootView to determine which screen to show
@Published var authDestination: AuthDestination = .welcome
```

---

## Testing

- Unit tests for model logic
- Preview-based testing for view layout validation
- Test SwiftData persistence across app restarts
- Verify on different device sizes

---

## Teaching-Specific Guidelines

### Code Clarity
- Use descriptive variable names
- Avoid abbreviations (except common ones like `id`, `url`)
- Break complex expressions into steps
- Comment the "why", not the "what"

### Examples for Interns

**Good Comment:**
```swift
// Use @EnvironmentObject to share one AuthViewModel across all views
// This ensures consistent auth state throughout the app
@EnvironmentObject var authViewModel: AuthViewModel
```

**Bad Comment:**
```swift
// This is the auth view model
@EnvironmentObject var authViewModel: AuthViewModel
```

**Good Variable Name:**
```swift
var isTermsAccepted: Bool
var homeownerId: UUID
```

**Bad Variable Name:**
```swift
var accepted: Bool  // Unclear what was accepted
var hid: UUID  // Abbreviation unclear
```

---

*Community Hands — Code Standards for Teaching Context*
