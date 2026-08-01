# Phase 4: SwiftData Models

## Overview

**Objective:** Create proper SwiftData models for local persistence.

**Priority:** Critical — Required for all data features

**Branch:** `feature/swiftdata-models`

---

## Problem Statement

Current app only uses `@AppStorage` for auth state. Need persistent models for:
- User profiles
- Job postings
- Accepted jobs
- Terms acceptance
- Ratings

---

## Models to Create

### 1. User Model
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
    var isTeen: Bool // Determines Helper vs Customer flow
    var hasBackgroundCheck: Bool // For homeowners
    var createdAt: Date
}
```

### 2. JobPosting Model
```swift
@Model
class JobPosting {
    var id: UUID
    var title: String
    var category: String
    var price: Double
    var description: String
    var homeownerId: UUID
    var isActive: Bool
    var createdAt: Date
    var location: String?
}
```

### 3. AcceptedJob Model
```swift
@Model
class AcceptedJob {
    var id: UUID
    var jobPostingId: UUID
    var teenId: UUID
    var status: String // "Pending", "In Progress", "Completed"
    var acceptedAt: Date
    var completedAt: Date?
    var homeownerRating: Int?
    var teenRating: Int?
}
```

### 4. TermsAcceptance Model
```swift
@Model
class TermsAcceptance {
    var id: UUID
    var userId: UUID
    var printedName: String
    var electronicSignature: String
    var parentSignature: String?
    var acceptedAt: Date
}
```

---

## Changes Required

### Update `Community_HandsApp.swift`
```swift
// Add ModelContainer to WindowGroup
WindowGroup {
    SplashScreen()
        .environmentObject(authViewModel)
        .modelContainer(for: [User.self, JobPosting.self, AcceptedJob.self, TermsAcceptance.self])
}
```

### Remove Views from `JobPosting.swift`
- Move `WorkerJobListingsView` to `Views/Helper/`
- Move `WorkerLoadingView` to `Views/Shared/`

---

## Testing Checklist

- [ ] Models compile without errors
- [ ] Data persists across app restarts
- [ ] Previews work with in-memory container
- [ ] Can create, read, update, delete records

---

*Phase 4: SwiftData Models*
