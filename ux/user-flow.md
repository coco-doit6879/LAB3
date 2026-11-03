# Deadline Mate user flows

## Flow 1 Manage a deadline

Goal: persist a deadline and mark it completed. Start: authenticated dashboard. End: completed status visible in list/detail and after reload.

```mermaid
flowchart TD
 A[Dashboard] --> B[Deadline list] --> C[Create deadline]
 C --> D{Valid title, course and due date?}
 D -->|No| E[Inline error, preserve input] --> C
 D -->|Yes| F[Save to Firestore]
 F -->|Failure| G[Explain error, retry] --> F
 F -->|Success| H[Detail] --> I[Mark completed] --> J[List shows completed]
 C --> K[Cancel, confirm discard if dirty] --> B
```

## Flow 2 Complete a study session

Goal: plan and record a session. Start: calendar. End: completed session with actual duration in calendar/dashboard.

```mermaid
flowchart TD
 A[Calendar] --> B[Plan session]
 B --> C{Valid subject and duration?}
 C -->|No| B
 C -->|Yes| D[Save planned session] --> E[Start session]
 E --> F[Running session] --> G[End and confirm] --> H[Persist completion]
 H -->|Failure| I[Keep state, retry] --> H
 H -->|Success| J[Calendar shows completed]
 F --> K[Leave screen, session remains persisted] --> A
```

Do not implement duration from widget rebuild ticks. Persist start time; reconstruct elapsed duration after navigating/restarting. Allow only valid state transitions and prevent duplicate submissions.

## Flow 3 Export a report

Goal: a valid PDF uploaded with owner metadata. Start: filtered deadline list. End: report history exposes an open action.

```mermaid
flowchart TD
 A[Deadline list filters] --> B[Reports with selected scope]
 B --> C{Export enabled?}
 C -->|No| D[Explain feature unavailable]
 C -->|Yes| E[Generate PDF] --> F[Upload with progress]
 F -->|Failure| G[Error, retry without false success] --> F
 F -->|Success| H[Save URL and metadata] --> I[Report history] --> J[Open URL]
 H -->|Failure| K[Explain metadata failure, allow recovery]
```

Screen inventory: Login; Dashboard; Deadline list; Deadline detail; Create deadline; Edit deadline; Courses; Calendar; Study sessions; Reports; Notifications; Profile. Courses reached from dashboard and forms; detail from list/calendar/notification. No dialog counts as an extra screen.
