# Architecture Context

## Stack

| Layer        | Technology                  | Role                                      |
| ------------ | --------------------------- | ----------------------------------------- |
| Framework    | SwiftUI                     | UI framework, declarative views           |
| Language     | Swift 5.9+                  | Programming language                      |
| Persistence  | SwiftData                   | **LOCAL data storage** — no cloud for MVP |
| Platform     | iOS 17+                     | Target OS version                         |
| IDE          | Xcode 15+                   | Development environment                   |

---

## System Boundaries

- `CommunityHands/Models/` — SwiftData @Model classes defining the data layer
- `CommunityHands/Views/` — SwiftUI Views, composable and single-responsibility
- `CommunityHands/ViewModels/` — ObservableObject classes for complex state
- `CommunityHands/Services/` — Utilities, helpers (local only, no external APIs)

---

## Storage Model

**CRITICAL: ALL data is local using SwiftData**

- **SwiftData (SQLite)**: All user data including Users, JobPostings, AcceptedJobs, Ratings
- **UserDefaults**: Minimal app preferences (auth state, onboarding status)
- **NO external storage**: MVP uses only local persistence

---

## SwiftData Models (Proposed)

### User
```swift
@Model
class User {
    var id: UUID
    var emailOrPhone: String
    var fullName: String
    var idType: String
    var idNumber: String
    var hasAcceptedTerms: Bool
    var role: String // "Community Member", "Volunteer", "Local Vendor"
    var bio: String?
    var createdAt: Date
    var isTeen: Bool // Determines if Helper or Customer flow
}
```

### JobPosting
```swift
@Model
class JobPosting {
    var id: UUID
    var title: String
    var category: String // "Lawn Care", "Pet Care", "Babysitting", "Car Wash", "Tutoring"
    var price: Double
    var description: String
    var homeownerId: UUID // Link to User who posted
    var isActive: Bool
    var createdAt: Date
    var location: String? // For neighborhood filtering
}
```

### AcceptedJob
```swift
@Model
class AcceptedJob {
    var id: UUID
    var jobPostingId: UUID
    var teenId: UUID // Link to User who accepted
    var status: String // "Pending", "In Progress", "Completed", "Cancelled"
    var acceptedAt: Date
    var completedAt: Date?
    var homeownerRating: Int? // 1-5 stars
    var teenRating: Int? // 1-5 stars
}
```

### TermsAcceptance
```swift
@Model
class TermsAcceptance {
    var id: UUID
    var userId: UUID
    var printedName: String
    var electronicSignature: String
    var parentSignature: String? // For users under 18
    var acceptedAt: Date
}
```

---

## App Architecture

### Navigation Structure

**Current:**
```
Community_HandsApp
└── WelcomeView (entry point - needs SplashScreen before this)
    └── (has own NavigationStack)
```

**Correct Structure:**
```
Community_HandsApp
└── SplashScreen (Entry point with animation)
    └── WelcomeView (After splash completes)
        ├── Navigation to SignUpView
        ├── Navigation to LoginView
        └── (Onboarding flow: Terms → Bio → MainMenu)
```

**Note:** SplashScreen is the entry point, not RootView. WelcomeView handles its own navigation.

---

### ModelContainer Setup

Configured in `Community_HandsApp.swift` with shared model container injected into view hierarchy.

**Current Issue:** App uses `@AppStorage` only, no SwiftData models defined yet.

---

### Data Flow

1. Views use `@Query` to fetch data from SwiftData
2. Model edits use `@Bindable` for two-way binding
3. Deletions and inserts use `modelContext` operations
4. Changes automatically propagate to UI

---

## Screen Structure (Proposed)

```
Community_HandsApp
└── WindowGroup
    ├── SplashScreen (NEW - entry point with animation)
    │   └── (transitions to WelcomeView after delay)
    ├── WelcomeView (existing)
    │   └── NavigationStack
    │       ├── SignUpView (via navigationDestination)
    │       └── LoginView (via navigationDestination)
    ├── SignUpView (2-step flow)
    ├── LoginView (2-step flow)
    └── MainMenuView
```

---

## Invariants

1. **All SwiftData operations must occur on the main actor** (SwiftUI handles this)
2. **Views do not perform network requests** — everything is local
3. **No forced unwrapping** of optionals in production code
4. **Single AuthViewModel instance** shared via @EnvironmentObject
5. **SplashScreen is the entry point** — shows animation, then transitions to WelcomeView
6. **All user-facing strings** use Localization (prep for future)
7. **Preview providers must include** in-memory model containers

---

## Error Handling

- Form validation shows inline errors
- SwiftData errors log to console (MVP) — user sees generic message
- Invalid user input shows inline validation, not crashes
- Auth errors show in authViewModel.errorMessage

---

## Known Issues (Pre-Architecture)

1. **No SplashScreen:** App launches directly to WelcomeView (should show splash first)
2. **No SwiftData Models:** Only using @AppStorage, no @Model classes defined
3. **Views in Models File:** `JobPosting.swift` contains views
4. **Multiple AuthViewModels:** Created in multiple files (needs fix)

---

## Architecture Decisions

| Decision | Status | Reason |
|----------|--------|--------|
| SwiftData for persistence | Decided | Local-only per requirements |
| SplashScreen as entry point | Decided | Shows animation before WelcomeView |
| Keep WelcomeView navigation | Decided | Existing flow works, no RootView needed |
| Single AuthViewModel | Decided | Fix duplicate instances |
| Customer side priority | Decided | Revenue-generating features first |

---

*Community Hands — Architecture Documentation*
