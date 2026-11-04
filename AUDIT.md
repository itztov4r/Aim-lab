# Repository audit — 4 November 2026

Source reviewed: `a5e88f132fabc01ebb87f53d2e8a5db6760b4f81` on `main`. Changes are proposed on `audit/repository-improvements-2026-11-04`; nothing was merged or deployed.

## Changes

- Restore local cosmetics into a copy of the remote profile, so local score values cannot mutate the authoritative snapshot.
- Ignore delayed profile/save lookups after account changes, cancel games/countdowns on sign-in/out and prevent duplicate starts.
- Pin the browser Supabase SDK to 2.118.0.
- Revoke all table privileges before granting only SELECT to visitors and SELECT/INSERT/UPDATE to authenticated users. Provide an existing-deployment SQL script.
- Add account isolation, metric restoration and privilege regression tests to CI.

## Verification

3 automated behavioral tests passed. All 6 recorded source/test checks passed. Local verification used Node.js 26.12.0 and Python 3.15.0; CI should also confirm the configured deployment versions.

- `node --test tests\accounts.test.js`
- `node tests/static-check.mjs`
- `node --check for repository JavaScript files`
- `node --check for executable inline HTML scripts`

Local HTML asset references were compared with the complete GitHub file inventory. Real desktop/mobile visual verification was blocked in this environment: the in-app preview could not reach the local server and the desktop browser did not expose a usable window. No claim of browser/device acceptance is made. Automated DOM/canvas simulations, where present, do not replace that check.

## Remaining limits and rollout

- Live read-only inspection confirmed owner INSERT/UPDATE policies and RLS, but both anon and authenticated still have TRUNCATE (also TRIGGER/REFERENCES) privileges on public.players. RLS does not cover TRUNCATE. The PR does not apply the live fix; review and apply database/audit-hardening.sql separately. This does not imply the REST Data API exposes a TRUNCATE operation.
- Live Auth advisor: leaked-password protection is disabled. Review https://supabase.com/docs/guides/auth/password-security#password-strength-and-leaked-password-protection .
- No real-user signup/sign-in, recovery email or score writes were performed. The leaderboard remains client-scored, so authenticated users can fabricate their own scores.
- The private backup-table advisor notices were left unchanged; no backup data was modified.
