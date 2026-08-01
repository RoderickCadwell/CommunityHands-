# Phase 5: Homeowner (Customer) Flow

## Overview

**Objective:** Build revenue-generating customer features for homeowners.

**Priority:** High — Revenue side, most important for business

**Branch:** `feature/homeowner-flow`

---

## Problem Statement

Homeowners need to:
- Post jobs they need help with
- Browse available teen helpers
- Track their active and completed jobs
- Rate helpers after job completion

---

## Views to Create

### 1. PostJobView
```swift
struct PostJobView: View {
    @State private var title: String = ""
    @State private var category: String = "Lawn Care"
    @State private var description: String = ""
    @State private var price: Double = 0.0
    
    // Form for creating new job posting
    // Category picker, description text editor, price input
}
```

### 2. MyJobsView
```swift
struct MyJobsView: View {
    @Query(filter: \.homeownerId == currentUserId) var myJobs: [JobPosting]
    
    // Tabbed view: Active Jobs / Completed Jobs
    // Shows jobs posted by current user
}
```

### 3. HelperBrowserView
```swift
struct HelperBrowserView: View {
    @Query var helpers: [User]
    
    // List of teen helpers with ratings
    // Filter by skills, location, availability
}
```

### 4. JobDetailView
```swift
struct JobDetailView: View {
    let job: JobPosting
    
    // Full job details
    // Edit/Delete if owner
    // Accepting helpers list
}
```

---

## Changes Required

### Update MainMenuView
- Replace confusing dual-persona UI with clear Customer navigation
- Add "Post a Job" button
- Add "My Jobs" section

### Update RootView
- Navigate to Homeowner dashboard after onboarding

---

## Testing Checklist

- [ ] Homeowner can post a job
- [ ] Job appears in MyJobs list
- [ ] Can browse teen helpers
- [ ] Can view job details
- [ ] Data persists with SwiftData

---

*Phase 5: Homeowner (Customer) Flow — Revenue Priority*
