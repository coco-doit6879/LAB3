# Fidelity and accessibility verification

Verification date: 2026-11-03. No original or updated Figma frames are available, so visual fidelity is **not proven**. Do not present synthetic widget tests as app-versus-Figma screenshots.

## Token implementation

AppTheme now explicitly sets the specified primary, mint, background, surface, primary/secondary text and error colors; typography sizes/line heights/weights; card radius 20; field/button radius 12; minimum button and icon target 48 dp. Native Material pressed, focused and disabled states remain framework-derived; these states need comparison against final Figma variants.

WCAG relative luminance computation from the exact RGB tokens (sRGB linearization, ratio `(Llighter + 0.05)/(Ldarker + 0.05)`):

| Foreground / background | Ratio |
|---|---:|
| #152D35 / #FFFFFF | 14.40:1 |
| #4C6269 / #FFFFFF | 6.44:1 |
| #FFFFFF / #183D47 | 11.68:1 |
| #152D35 / #D7F3E8 | 12.25:1 |
| #BA1A1A / #FFFFFF | 6.46:1 |

These selected enabled text pairs exceed 4.5:1. This is a token calculation, not a complete contrast audit of rendered screens, overlays or all interaction states.

## Components and responsive layout

- DeadlineCard is used by Dashboard and Deadline list, with explicit text/icon completion state and full wrapping title.
- AppNavigation uses bottom navigation below 600 dp and a NavigationRail from 600 dp; destination definitions and selection callback are shared. Main content is capped at 640 dp.
- All nine named components now exist; StatusPanel delegates to LoadingState, EmptyState and ErrorState. Screen buttons, text inputs, top bars and dialogs use the shared widgets. See components.md for variants and exceptions. Visual equality with Figma variants remains unverified.
- Three widget tests render the navigation and a long-title deadline at 360×800, 412×800 and 800×800 logical pixels; no layout exception occurs, the correct navigation variant is present, and destination/card taps invoke callbacks. All 19 Flutter tests passed after this change; analysis clean.

These checks cover only the tested components. Every screen, keyboard, text scaling, TalkBack reading order, focus, touch targets and phone rotation still require runtime review.

## Required screen comparisons pending

Login, Dashboard, Deadline list, Deadline detail, Create deadline, Edit deadline, Courses, Calendar, Study sessions, Reports, Notifications and Profile each need: Figma node link and frame export, app capture at 360×800 dp, side-by-side image, measured differences, reason and correction status. Loading, empty, error and recovery variants must be included where applicable. There are no completed comparison pairs yet.
