# Deadline Mate design specification

Selected by the student on 2026-11-03. This is a new specification, not evidence of an existing Lab 2 Figma submission. Lecturer approval of the topic change and updated Figma remain pending.

Audience: students taking six courses who need one place for deadlines and realistic study sessions. Proposed measurable goal: add a valid deadline in under 30 seconds. Measure with the running app; no result is claimed yet.

## Visual tokens

Light theme, calm academic tone, clear Vietnamese labels. Navy primary #183D47, mint accent #D7F3E8, background #F5F7F5, surface #FFFFFF, primary text #152D35, secondary text #4C6269, error #BA1A1A. Meaning must also use text/icon, not color alone. Contrast measurements remain pending.

Typography: system sans-serif; headline 28/34 bold, title 22/28 bold, subtitle 18/24 semibold, body 16/24, label 14/20 semibold. Spacing scale: 4, 8, 12, 16, 24, 32. Radius: 12 for fields/buttons, 20 for cards. Minimum interactive target 48 dp. No external photo assets required.

Bottom destinations: Tổng quan, Deadline, Lịch học, Báo cáo. Profile and Notifications are app-bar actions. Forms/details are pushed routes; Back pops one route. Dirty forms ask before discard. At ≥600 dp use a centered content area or navigation rail; preserve reading order.

## Components

Button default/pressed/disabled/loading; TextField default/focused/filled/error/disabled; Card default/pressed; Navigation each selected destination; AppBar with optional actions; Dialog confirmation/destructive/error; Loading progress and message; Empty icon/message/action; Error cause/message/retry. Implement each as a reusable widget using tokens.

## Scope

Google authentication, personal courses/deadlines/study sessions, Firestore realtime CRUD, report export and storage, notifications, configuration and diagnostics. No payments, team sharing, chatbot or custom reminder backend. FCM Console messages demonstrate push; automatic scheduled reminders are not implied.
