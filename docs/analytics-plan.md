# Analytics event plan

Status: event calls are implemented in code; no DebugView evidence yet. No email, name, notification text or deadline title is sent as an event parameter.

| Event | Successful trigger | Parameters | Flow |
|---|---|---|---|
| login | Firebase Google credential accepted | method=google | Entry |
| logout | Firebase sign-out completed | none | Exit |
| screen_view | Named page pushed/popped or bottom destination selected | screen_name | All |
| view_deadline | Detail resolves an existing record | item_id | 1 |
| create_deadline | Firestore create acknowledged | item_id | 1 |
| update_deadline | Firestore update acknowledged | item_id | 1 |
| delete_deadline | Firestore delete acknowledged | item_id | 1 |
| export_pdf | Upload and metadata save completed | item_count | 3 |
| start_study_session | Planned → running transaction committed | session_id | 2 |
| complete_study_session | Running → completed transaction committed | session_id | 2 |

Purpose: understand flow completion and where students stop. IDs link repeated operations without sending private titles. Analytics and Crashlytics user identifier is Firebase UID; clear on logout. Reporting errors does not reverse a successful data write.

Verification still required: enable Analytics, enable DebugView for vn.deadlinemate.deadline_mate with adb, execute each trigger, inspect parameters and attach actual screenshots. An implemented log call does not prove delivery.
