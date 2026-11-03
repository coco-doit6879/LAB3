# Flutter implementation handoff

New working specification. Figma screen exports and component instances are pending; visual fidelity cannot yet be certified.

## Global mappings

Colors → AppTokens and ThemeData.colorScheme; typography → ThemeData.textTheme; spacing/radius/content width → AppTokens. Components → AppButton, AppField, DeadlineCard, AppNavigation, AppTopBar, AppDialog, LoadingState, EmptyState, ErrorState. Screens must not use Firebase APIs directly.

All screens: SafeArea, scroll when content exceeds height, body ≥14 sp, targets ≥48 dp, label overflow wraps or truncates with accessible full text. Keyboard does not cover submit actions. Widths 360 and 412 dp require runtime checks. At ≥600 dp center forms with max width 640 dp and use rail for main destinations.

| Screen | Layout and components | States | Interactions | Navigation and Back | Constraints |
|---|---|---|---|---|---|
| Login | Brand, introduction, Google button, error message | Idle/loading/error/cancelled | Google authenticate; cancellation stays on screen | Auth gate; no authenticated routes when signed out | Disable duplicate login requests |
| Dashboard | App bar, summary cards, next deadlines, course action | Loading/empty/error/data | Open detail, create deadline, open courses/profile/notifications | Main destination; Android Back follows shell policy | Remote limit changes visible item count |
| Deadline list | App bar, search, status/course filters, scroll cards, create action | Loading/empty/error/data | Filter/sort; open detail; create | Main destination | Query by UID; no personal content in telemetry |
| Deadline detail | App bar, title/course/due/status, edit/complete/delete actions | Loading/not found/error/data/saving | Complete; edit; confirm delete | Back to source; deleted record returns list | Confirm destructive action; disable while saving |
| Create deadline | Scroll form, title/course/due fields, save | Idle/invalid/saving/error | Validate title 1–120 chars, course selected, date selected; save | Pop to created detail; dirty Back confirms discard | Preserve input on failed write |
| Edit deadline | Same reusable form populated from record | Loading/not found/dirty/saving/error | Update allowed fields | Pop to detail; dirty Back confirms discard | Handle record deleted by another client |
| Courses | List cards and add-course dialog | Loading/empty/error/data | Create course with name 1–80 and code 1–20 chars | Nested route, Back pops | Avoid deleting referenced courses without policy |
| Calendar | Date selector, deadlines and sessions for selected date | Loading/empty/error/data | Change date; open deadline/session | Main destination | Dates stored as timestamps, displayed locally |
| Study sessions | Planned/running/completed list, session form/actions | Loading/empty/error/data/saving | Plan 5–180 min; start planned session; finish running session | Nested from calendar; Back does not erase running state | Persist times; duration derived from time, not UI ticks |
| Reports | Scope summary, export action/progress, report history/open | Loading/empty/generating/uploading/error/data | Export selected data, open HTTPS URL | Main destination | Config flag controls action; never report success before metadata |
| Notifications | Message list, read status | Loading/empty/error/data | Mark read, open safe known route | Nested; Back pops | Missing/deleted/foreign target falls back safely |
| Profile | Avatar/name/email, Remote Config values/refresh, notification permission, diagnostics, sign out | Loading/data/error | Refresh config, request permission, handled error; confirm demo crash | Nested; sign out resets route stack | Demo crash debug-only; clear user state on sign out |

List top-level Back: return to Dashboard from other destinations; from Dashboard let Android exit. Route changes and per-screen business logic belong to ViewModels; services own SDK communication. Auth-state changes destroy user-scoped providers and listeners.
