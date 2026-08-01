# AI Workflow Rules

## Approach

Build Community Hands incrementally using a spec-driven workflow. Context files define what to build, how to build it, and the current state of progress. Always implement against these specs — do not infer or invent behavior from scratch.

**CRITICAL: All data is local using SwiftData.** No external APIs for core functionality.

---

## Swift/SwiftUI Specific Guidelines

### View Development

- Build views in isolation first using Preview providers
- Use sample data in previews, never production data
- Test on multiple device sizes in canvas
- Ensure previews work before marking view complete

### SwiftData Development

- **ALL persistence is local SwiftData** — no cloud, no external APIs for core data
- Define model schema completely before building views
- Test data persistence using simulator builds
- Use in-memory containers for previews and tests
- Never modify model schema after data exists (plan migrations for production)

### Working with SwiftUI

- Prefer `@Query` over manual fetching for lists
- Use `@Bindable` for editable forms
- Keep view body under 100 lines — extract subviews
- Use `NavigationStack` path-based navigation for complex flows

---

## Scoping Rules

- Work on one feature unit at a time
- Prefer small, verifiable increments over large speculative changes
- Do not combine unrelated system boundaries in a single implementation step

### Feature Units for Community Hands

1. **Data Models** — Define all SwiftData models (User, JobPosting, AcceptedJob, etc.)
2. **Auth Flow** — Welcome, SignUp, Login, Terms, Bio
3. **Homeowner (Customer) Flow** — PostJob, BrowseHelpers, MyJobs
4. **Teen (Helper) Flow** — BrowseJobs, AcceptJob, Schedule, Earnings
5. **Marketplace Core** — Job listings, categories, search, ratings
6. **Polish** — Animations, empty states, error handling

---

## When to Split Work

Split an implementation step if it combines:

- UI changes and data model changes
- Multiple unrelated features (e.g., homeowner + teen flows in one commit)
- Behavior not clearly defined in context files
- External API integration with UI changes

If a change cannot be verified end to end quickly, the scope is too broad — split it.

---

## Handling Missing Requirements

- Do not invent product behavior not defined in the context files
- If a requirement is ambiguous, resolve it in the relevant context file before implementing
- If a requirement is missing, add it as an open question in `progress-tracker.md` before continuing

---

## Protected Files

Do not modify the following unless explicitly instructed:

- `Cummunity Hands.xcodeproj/` — Xcode project internals
- `Community Hands/Assets.xcassets/AppIcon.appiconset/` — App icon assets
- `Community Hands/Info.plist` — Core app configuration
- `Community HandsTests/` and `Community HandsUITests/` — Unless writing tests
- **Tone's original WelcomeView design** — Do not redesign, only fix structural issues

---

## Keeping Docs in Sync

Update the relevant context file whenever implementation changes:

- System architecture or boundaries → `architecture.md`
- Storage model decisions → `architecture.md`
- Code conventions or standards → `code-standards.md`
- Feature scope → `project-overview.md`
- UI changes → `ui-context.md`
- Build progress → `progress-tracker.md`

---

## Before Moving to the Next Unit

1. The current unit works end to end within its defined scope
2. No invariant defined in `architecture.md` was violated
3. `progress-tracker.md` reflects the completed work
4. Preview providers work with sample data
5. App builds without warnings (Swift compiler warnings acceptable if minor)
6. **SwiftData persistence verified** — data survives app restart

---

## Swift Specific Testing

- Run in iOS Simulator to verify functionality
- Check SwiftUI previews render correctly
- **Verify SwiftData persistence across app restarts**
- Test on different device sizes (iPhone SE, iPhone Pro Max)

---

## Build Verification

Before marking a phase complete:

1. `Cmd+B` builds successfully with no errors
2. Previews show expected UI
3. Simulator run shows working functionality
4. No crash on launch or common operations
5. **SwiftData data persists after app restart**

---

## Teaching Context

This is a teaching project for interns learning Swift/SwiftUI. When making changes:

- **Add explanatory comments** explaining the block
- Use clear, descriptive variable names
- Follow the patterns shown in the Swift teaching skill
- Document architectural decisions
- Keep code clean and educational

---

## Critical Reminders

1. **Everything is LOCAL** — SwiftData only, no external APIs for core data
2. **Customer/Client side is priority** — Revenue-generating features first
3. **Do not "destroy" existing UI** — Fix structural issues, don't redesign unless instructed
4. **Branch per feature** — Never work on main branch
5. **Document everything** — Update progress-tracker after each change

---

*Community Hands — AI Workflow for Teaching Context*
