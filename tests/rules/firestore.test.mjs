import { before, after, beforeEach, test } from 'node:test';
import { readFile } from 'node:fs/promises';
import { initializeTestEnvironment, assertSucceeds, assertFails } from '@firebase/rules-unit-testing';
import { doc, setDoc, getDoc, updateDoc, deleteDoc, serverTimestamp, Timestamp } from 'firebase/firestore';

let env;
before(async () => {
  env = await initializeTestEnvironment({ projectId: 'demo-deadlinemate', firestore: {
    host: '127.0.0.1', port: 8188,
    rules: await readFile(new URL('../../firebase/firestore.rules', import.meta.url), 'utf8'),
  }});
});
beforeEach(async () => env.clearFirestore());
after(async () => env?.cleanup());
const db = (uid = 'alice') => uid ? env.authenticatedContext(uid).firestore() : env.unauthenticatedContext().firestore();
const deadline = () => ({title: 'Lab 3', courseId: 'PRM393', dueAt: Timestamp.now(), completed: false,
  createdAt: serverTimestamp(), updatedAt: serverTimestamp()});
const session = () => ({title: 'Flutter', plannedAt: Timestamp.now(), plannedMinutes: 25,
  status: 'planned', startedAt: null, endedAt: null, createdAt: serverTimestamp()});

test('owner can create read update delete a deadline', async () => {
  const ref = doc(db(), 'users/alice/deadlines/d1');
  await assertSucceeds(setDoc(ref, deadline()));
  await assertSucceeds(getDoc(ref));
  await assertSucceeds(updateDoc(ref, {completed: true, updatedAt: serverTimestamp()}));
  await assertSucceeds(deleteDoc(ref));
});
test('another UID and signed-out users cannot read write or delete owner data', async () => {
  await setDoc(doc(db(), 'users/alice/deadlines/d1'), deadline());
  for (const uid of ['bob', null]) {
    const ref = doc(db(uid), 'users/alice/deadlines/d1');
    await assertFails(getDoc(ref));
    await assertFails(updateDoc(ref, {completed: true, updatedAt: serverTimestamp()}));
    await assertFails(deleteDoc(ref));
    await assertFails(setDoc(doc(db(uid), 'users/alice/deadlines/foreign'), deadline()));
  }
});
test('deadline schema rejects empty oversized wrong-type and injected fields', async () => {
  for (const patch of [{title: ''}, {title: 'x'.repeat(121)}, {completed: 'yes'}, {admin: true}, {courseId: ''}]) {
    await assertFails(setDoc(doc(db(), 'users/alice/deadlines/d1'), {...deadline(), ...patch}));
  }
});
test('deadline creation time cannot be rewritten', async () => {
  const ref = doc(db(), 'users/alice/deadlines/d1');
  await setDoc(ref, deadline());
  await assertFails(updateDoc(ref, {createdAt: Timestamp.fromMillis(1), updatedAt: serverTimestamp()}));
});
test('courses require owner and bounded fields', async () => {
  const valid = {name: 'Mobile Programming', code: 'PRM393', createdAt: serverTimestamp()};
  await assertSucceeds(setDoc(doc(db(), 'users/alice/courses/c1'), valid));
  await assertFails(setDoc(doc(db('bob'), 'users/alice/courses/c2'), valid));
  await assertFails(setDoc(doc(db(), 'users/alice/courses/c3'), {...valid, code: 'x'.repeat(21)}));
});
test('study session only permits planned to running to completed', async () => {
  const ref = doc(db(), 'users/alice/study_sessions/s1');
  await assertSucceeds(setDoc(ref, session()));
  await assertFails(updateDoc(ref, {status: 'completed', endedAt: serverTimestamp()}));
  await assertSucceeds(updateDoc(ref, {status: 'running', startedAt: serverTimestamp()}));
  await assertFails(updateDoc(ref, {status: 'running', title: 'Changed'}));
  await assertSucceeds(updateDoc(ref, {status: 'completed', endedAt: serverTimestamp()}));
  await assertFails(updateDoc(ref, {status: 'planned', startedAt: null, endedAt: null}));
});
test('study session duration limits and forged initial status are rejected', async () => {
  for (const patch of [{plannedMinutes: 4}, {plannedMinutes: 181}, {plannedMinutes: 25.5}, {status: 'running'}]) {
    await assertFails(setDoc(doc(db(), 'users/alice/study_sessions/s1'), {...session(), ...patch}));
  }
});
test('report metadata must use matching UID and storage path', async () => {
  const report = {fileName: 'deadline-mate-r1.pdf', url: 'https://firebasestorage.googleapis.com/v0/b/example/o/report',
    ownerId: 'alice', createdAt: serverTimestamp(), itemCount: 1,
    objectPath: 'reports/alice/deadline-mate-r1.pdf', storageProvider: 'firebase'};
  await assertSucceeds(setDoc(doc(db(), 'users/alice/reports/r1'), report));
  await assertFails(setDoc(doc(db(), 'users/alice/reports/r2'), {...report, ownerId: 'bob'}));
  await assertFails(getDoc(doc(db('bob'), 'users/alice/reports/r1')));
});
test('notification read updates cannot change message text or routing', async () => {
  const ref = doc(db(), 'users/alice/notifications/n1');
  await assertSucceeds(setDoc(ref, {title: 'Reminder', body: 'Study', targetType: 'notifications',
    targetId: null, read: false, receivedAt: serverTimestamp()}));
  await assertSucceeds(updateDoc(ref, {read: true}));
  await assertFails(updateDoc(ref, {body: 'Changed', read: true}));
  await assertFails(getDoc(doc(db('bob'), 'users/alice/notifications/n1')));
});
test('Cloudinary reports remain owner-scoped and reject unapproved delivery hosts', async () => {
  const report = {fileName: 'deadline-mate-r3.pdf',
    url: 'https://res.cloudinary.com/test-cloud/raw/upload/v1/report.pdf',
    ownerId: 'alice', createdAt: serverTimestamp(), itemCount: 2,
    objectPath: 'report.pdf', storageProvider: 'cloudinary'};
  await assertSucceeds(setDoc(doc(db(), 'users/alice/reports/r3'), report));
  await assertFails(getDoc(doc(db('bob'), 'users/alice/reports/r3')));
  await assertFails(setDoc(doc(db(), 'users/alice/reports/r4'), {...report,
    fileName: 'deadline-mate-r4.pdf', url: 'https://evil.example/report.pdf'}));
});
test('unknown collections remain denied', async () => {
  await assertFails(setDoc(doc(db(), 'users/alice/private/x'), {value: 1}));
});
