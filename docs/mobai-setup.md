# MobAI runner setup

Current CLI: 3.5.1 at `D:\PRM\tools\mobai\node_modules\.bin\mobai.cmd`. It can observe emulator-5554 and execute the supplemental login-gate DSL. The earlier `.mob` test command returned `testing not initialized - open a project first`. No ten-script pass is claimed.

## Windows Desktop preparation

The installed CLI exposes `desktop install` and `desktop launch`. `desktop install --dry-run --json` returned the official Windows installer URL:

https://github.com/MobAI-App/releases/releases/latest/download/MobAI.exe

Downloaded to `D:\PRM\tools\mobai\MobAI.exe`, 100170376 bytes. SHA-256: `B821DBC629344912A6FB2996E9F84383EACBCD514653B4F1907FFE039B1EAAA6`.

Windows Authenticode check returned UnknownError: “A certificate chain processed, but terminated in a root certificate which is not trusted by the trust provider.” Signer and issuer are both `CN=MobAI Dev, O=MobAI, C=US`; certificate validity dates reported 2026-01-12 through 2029-01-12. This does not establish a trusted publisher chain. The installer has **not** been run; no Windows security warning has been bypassed and no security setting changed.

Desktop installation/project initialization remains pending. Do not replace the required `.mob` tests with DSL results or count downloading this installer as setup success. If Windows presents a security barrier, the student must handle the decision manually; automation must not bypass it. After Desktop is running, initialize/open the project and rerun the existing supplemental script before authoring the ten observed signed-in flows.

The Android authentication step is currently being completed manually by the student. Do not run a fresh-app test or restart the emulator while that flow is in progress.
