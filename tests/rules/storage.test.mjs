import { before, after, beforeEach, test } from 'node:test';
import { readFile } from 'node:fs/promises';
import { initializeTestEnvironment, assertSucceeds, assertFails } from '@firebase/rules-unit-testing';
import { ref, uploadBytes, getBytes, deleteObject } from 'firebase/storage';

let env;
before(async () => {
  env = await initializeTestEnvironment({projectId: 'demo-deadlinemate', storage: {
    host: '127.0.0.1', port: 9299,
    rules: await readFile(new URL('../../firebase/storage.rules', import.meta.url), 'utf8'),
  }});
});
beforeEach(async () => env.withSecurityRulesDisabled(async (context) => {
  // v6 clearStorage() only deletes root items; our fixtures live under reports/.
  // Recursively reset this local demo bucket so test cases remain independent.
  async function clearPrefix(prefix) {
    const listing = await prefix.listAll();
    await Promise.all(listing.items.map((item) => item.delete()));
    await Promise.all(listing.prefixes.map(clearPrefix));
  }
  await clearPrefix(context.storage().ref());
}));
after(async () => env?.cleanup());
const storage = (uid = 'alice') => uid ? env.authenticatedContext(uid).storage() : env.unauthenticatedContext().storage();
const pdfBytes = new TextEncoder().encode('%PDF-1.4\n% minimal rule-test fixture, not a generated report');
const metadata = {contentType: 'application/pdf', customMetadata: {ownerId: 'alice'}};
const path = 'reports/alice/deadline-mate-test1.pdf';

test('owner can upload read and delete own PDF object', async () => {
  const object = ref(storage(), path);
  await assertSucceeds(uploadBytes(object, pdfBytes, metadata));
  await assertSucceeds(getBytes(object));
  await assertSucceeds(deleteObject(object));
});
test('other UID cannot upload read or delete owner object', async () => {
  await uploadBytes(ref(storage(), path), pdfBytes, metadata);
  const object = ref(storage('bob'), path);
  await assertFails(getBytes(object));
  await assertFails(deleteObject(object));
  await assertFails(uploadBytes(ref(storage('bob'), 'reports/alice/deadline-mate-foreign.pdf'), pdfBytes, metadata));
});
test('signed-out clients cannot read or upload', async () => {
  await uploadBytes(ref(storage(), path), pdfBytes, metadata);
  await assertFails(getBytes(ref(storage(null), path)));
  await assertFails(uploadBytes(ref(storage(null), 'reports/alice/deadline-mate-anon.pdf'), pdfBytes, metadata));
});
test('MIME, owner metadata and filename constraints are enforced', async () => {
  await assertFails(uploadBytes(ref(storage(), path), pdfBytes, {...metadata, contentType: 'text/plain'}));
  await assertFails(uploadBytes(ref(storage(), path), pdfBytes, {...metadata, customMetadata: {ownerId: 'bob'}}));
  await assertFails(uploadBytes(ref(storage(), 'reports/alice/other.pdf'), pdfBytes, metadata));
});
test('empty and oversized objects are denied', async () => {
  await assertFails(uploadBytes(ref(storage(), path), new Uint8Array(0), metadata));
  await assertFails(uploadBytes(ref(storage(), path), new Uint8Array(10 * 1024 * 1024 + 1), metadata));
});
test('existing report cannot be overwritten even by its owner', async () => {
  const object = ref(storage(), path);
  await uploadBytes(object, pdfBytes, metadata);
  await assertFails(uploadBytes(object, new TextEncoder().encode('%PDF replacement'), metadata));
});
test('unknown storage paths are denied', async () => {
  await assertFails(uploadBytes(ref(storage(), 'public/report.pdf'), pdfBytes, metadata));
});
