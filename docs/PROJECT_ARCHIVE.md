# ResiManage — Project Continuity Archive

Last updated: 2026-10-17

## Purpose and working rule
This file is the durable project handover log for `samyrius/ResiManage`. Read it before continuing work. Update it when requirements, implementation, tests, or decisions change. Do not restart completed setup steps or ask the user to repeat information already recorded.

## Confirmed by the user
- GitHub repository read/write access was resolved earlier. Do not revisit it unless a new, specific failure occurs.
- A prototype has already been built, installed on the user's phone, and launched successfully. Do not restart the prototype-creation phase from scratch.
- The user has additional observations and changes to discuss later. Do not request or start that critique phase yet; finish the original agreed requirements first.
- Work autonomously through implementation and testing. Ask only when a genuinely indispensable permission, secret, or decision is missing.
- Protect local and real data: back up before risky operations; preserve `rotation.db`, resident and stage histories, backups, and DEMS archive; never commit/upload database files, backups, passwords, or tokens. Do not overwrite or delete real data without explicit permission.
- Never report a task as complete without a verifiable result.

## Product requirements to finish before the critique phase

### Core workflow
- Flask-based resident rotation manager, with Arabic/French/English UI and RTL for Arabic.
- Manage residents, departments/terrains, periods, capacity, assignments, history, yearly summary, CSV export, and downloadable database backup.
- Four periods per academic year: 01 Feb–30 Apr; 01 May–30 Jul; 01 Aug–30 Oct; 01 Nov–30 Jan.
- Assignment priority: 4th year, then 3rd, 2nd, 1st.
- Enforce one assignment per resident per period and enforce capacity for each terrain/period.
- Prevent repeating a terrain until all mandatory/core terrains are completed; optional terrains are not prerequisites for repeat eligibility.
- Mismatched mandatory-year assignments must require an authorized decision with a recorded reason/audit trail.

### Terrain classification
- Optional: Sédation (7), Maxillo-faciale (8), Chirurgie cardiaque (11), Brûlés (18), CAC DBK (19).
- Gynécologie is NOT optional.
- Core/mandatory terrains include the other required departments already specified by the user, including Réanimation chirurgicale, Réanimation polyvalente, Chirurgie générale, Urologie, Orthopédie, Neurochirurgie, CCI, Obstétrique, PU Médecine, PU Chirurgie, ORL, Ophtalmologie, and Chirurgie thoracique.
- Verify seeded count is 19 and check exact category assignments. Do not infer or fabricate resident rotation history.

### Administrators and audit
- Pr Benhocine and Dr Dris are both Super Admins.
- Dr Dris has full control, including add/edit/delete, settings, assignments, archives, and authorized overrides. Benhocine is also Super Admin and department head.
- Normal users must be restricted according to role.
- Record administrative changes and override decisions in an audit log.

### Profiles, exams, archives
- Resident profiles should support surname, first name, birth details, phone, photo, exam scores by year, and complete past-stage history.
- Show completed terrains in red and not-yet-completed terrains in green; include objectives per terrain and per study year.
- First-year advancement after exams only if the overall average is at least 10/20 and no theory/practical component of any module is below 10/20.
- Advancement in years 2–4 is decided by Dr Dris and Pr Benhocine.
- After four years, DEMS success moves the resident and history to a graduation archive, not deletion.
- Support importing real DOC/DOCX/PDF/XLS lists with preview and validation, grouped by academic year. Do not invent past stages; record only documented history from the start of specialty.

### Security, data, delivery
- Remove insecure hard-coded/default credentials and ensure secret configuration is safe before any shared/production deployment. Never expose passwords in public UI, source, logs, or archive.
- Verify backup and restore procedure before any operation that could affect real data.
- Preserve `rotation.db` and all backups/history; database files are excluded from Git.
- Run automated tests for authentication, assignment duplicates, capacity limits, repeat eligibility, priority, mandatory-year decisions/audit, periods, terrain seed, CSV export, backup/restore, permissions, and archive flows.
- Verify mobile usability and provide the appropriate build/run instructions for the already established prototype. Do not claim a new APK or hosted demo exists unless its artifact/link has been verified.

## Resolved — do not repeat
- GitHub repository read/write access setup.
- Initial prototype creation, installation on the user's phone, and successful launch (confirmed by user).
- User-side pairing/token/setup walkthroughs.

## Current engineering state (verified 2026-10-13)
- Main branch baseline noted previously at commit `97ca43634f09a9506f929f7405595d09b8439306`.
- Isolated working branch: `prototype/verification-2026-10-13`.
- Pull request #8: https://github.com/samyrius/rotation-app/pull/8
- PR #8 merged into `main` in merge commit `52127b58aa1bcc7f86f320c34f7de35f0c63922e`. The changes include GitHub Actions CI, smoke/regression tests, the corrected CAC DBK seed and terrain classification, and this continuity archive.
- First CI attempt failed during collection because pytest could not import `app`; the test import path was fixed in commit `c5d80651051ed254308b8177ea72c8730372086d`.
- Historical baseline run for commit `c8774e679fcd34b4287026f1dc6d67a461bd588a` passed 7 initial tests. This has been superseded by the expanded verification recorded below.
- Do not merge this branch until the tests pass and changes are reviewed. No database files or real resident data were committed.

## Next steps (continue without asking the user to repeat context)
1. Continue adding isolated tests for mandatory-year overrides/audit, and role permissions.
2. Inspect admin authorization and replace insecure shared/default credential behavior with a safe migration path that does not lock out the existing phone prototype or touch real database files.
3. Implement/verify profile, exam progression, DEMS archive/import, objectives, audit log, and backup/restore requirements that are still absent.
4. Validate priority ordering, four-period rollover, and annual advancement rules.
5. Keep this archive current with commits, test evidence, remaining gaps, and completed tasks.
6. Only after the original requirements are addressed, invite the user to provide the critique and adjustments they have intentionally deferred.

## Expanded implementation and verification update (2026-10-13)

- Latest verified code/test commit: `49924478a7ee81a5a0a81de6c4768dfa75b597e6`. GitHub Actions run `38454544015` completed successfully: **25 tests passed in 8.38 seconds**. Tests use isolated temporary databases; no resident database or real resident records were committed.
- Implemented on the isolated branch:
  - PBKDF2 password hashing, migration of legacy SHA-256 hashes after a successful login, no default password displayed in the login page, first-run administrator password setup, and a locally generated Flask secret stored in ignored `.rotation_secret` unless `ROTATION_SECRET` is configured.
  - Individual user accounts with Super Admin/standard roles; sensitive pages are restricted; accounts can be deactivated safely while preventing deactivation of the current account or the last active Super Admin.
  - Add/edit/deactivate terrains without deleting history; deactivated terrains are excluded from new assignment/capacity/history/objective selectors.
  - Audited assignment cancellation rather than physical deletion, so the record remains available for audit/history.
  - Resident profiles with editable identity/contact/birth fields, photo upload validation (PNG/JPG/WEBP, 4 MB maximum), history, assignment status, terrain completion colors, exam marks, and objectives.
  - First-year exam progression rule: calculated average at least 10/20 and no theory/practical component below 10/20. The evaluation screen requires confirmation that all module marks have been entered. Years 2–3 progression requires a Super Admin decision; exam records can be corrected without creating duplicate module rows.
  - DEMS success archive stores the resident profile, stage history, assignments and exam snapshot, while preserving the original resident/history records.
  - Import preview/validation for CSV, XLS/XLSX, DOC/DOCX and text-based PDF; imported rows are grouped/sorted by study year and name. Import does not fabricate prior stages. Legacy .doc conversion requires antiword or LibreOffice; scanned PDFs without extractable text need OCR outside the app.
  - CSV export includes residents, terrains, periods, capacities, assignments, history, decisions, exams, objectives, DEMS archive and audit data, but excludes user credential hashes.
  - SQLite-consistent backup and validated restore. Restore checks SQLite integrity and required tables and creates a separate pre-restore backup before replacement.
  - Academic-year format validation, four-period creation with previous periods retained, year-priority ordering, exact five optional terrain classification, audit records for key administrative changes, and French/Arabic/English navigation labels for the added workflows.
- Updated `README.md` with local launch instructions, import limitations, backup/restore safety and branch status.
- The reviewed work was merged from `prototype/verification-2026-10-13` through PR #8. The user-confirmed existing phone prototype and local database were not accessed or modified by these repository changes.
- The CI test suite now covers the main rules, profile/objective workflows, first-year progression, DEMS archive, user roles, backup/restore, CSV/XLSX/DOCX import preview, CSV export, mandatory-year override/audit, priority, academic-year periods, photo upload, terrain deactivation, assignment cancellation, user deactivation, first-run setup and legacy password migration.

## Remaining real-world verification (do not claim complete until checked)
1. Perform a mobile smoke test of this updated branch against a copy of the existing prototype database. Back up first; never overwrite the user's actual database without explicit approval. This remote repository workflow cannot inspect or operate the user's phone database.
2. In the running app, create separate accounts for Pr Benhocine and Dr Dris in **Users**, assign both Super Admin, and set private passwords individually. The repository does not contain their passwords and must not.
3. Confirm the expected module list and enter the actual objectives for each terrain/year; the app provides data-entry forms but no official module/objective list was supplied to seed.
4. Test real DOC/XLS/PDF examples in the target Termux environment. Legacy DOC needs antiword or LibreOffice, and scanned PDF OCR is not included.
5. Review the final diff and CI status before deciding whether to merge PR #8. No new APK or hosted demo has been built or verified in this branch.
6. Only after these original requirements and checks are addressed should the user's deferred critique/adjustments be discussed.

## Post-merge status (2026-10-13)

- PR #8 is merged into `main`; merge commit: `52127b58aa1bcc7f86f320c34f7de35f0c63922e`.
- Before merge, the reviewed code commit `49924478a7ee81a5a0a81de6c4768dfa75b597e6` passed **25 automated tests in 8.38 seconds**. The archive-only branch commit also passed 25 tests in 6.93 seconds. Post-merge CI for merge commit `52127b58aa1bcc7f86f320c34f7de35f0c63922e` passed **25 tests in 6.76 seconds**. The subsequent documentation-only commit `37e585471d3444fedb8a9f4a601724a907374259` also passed **25 tests in 5.54 seconds**.
- No database, real resident records, backups, uploaded photos, passwords, or tokens were committed. Existing phone installation/data were not modified.
- Remaining external checks are unchanged: test the merged code against a copy of the existing phone database after backing it up; create the two named Super Admin accounts with private passwords in the app; validate real input files and populate the official module/objective data; and do not claim a new APK or hosted demo until one is actually built and tested.

## Archive limitation
This repository log captures durable project decisions and progress; it is not a verbatim recording of every voice call or every conversation. Do not store credentials, access tokens, personal secrets, or real resident records here.


## Bug log — 2026-10-14

### BUG-UI-001: Mobile layout overflows screen (reported from phone screenshot)
- **Observed:** content/header appear clipped horizontally; navigation and labels crowd/overlap; page does not adapt cleanly to a narrow phone viewport.
- **Action taken:** updated the shared CSS in `app.py` on `main` at commit `a7833ab582a84b9d4828742a58d35006d8408bbf`. Added global box sizing and horizontal overflow protection, responsive padding and grid sizing, wrapping for labels/buttons, scroll containment for wide tables, image sizing, and RTL navigation handling.
- **Status:** code change committed; **not yet runtime-verified on the user's phone**. Treat as pending verification, not confirmed fixed. Next: run automated tests/CI, inspect all rendered pages at narrow viewport widths, then install/build a test package only after the remaining recorded defects are addressed.
- **Process rule confirmed by user:** every newly discovered defect must be added to this Resistage project log with a unique ID, observed behavior, fix, test evidence, and status. Do not declare a defect fixed until it has been tested. Do not produce a new app build for the user until all logged defects have been corrected and the required tests pass.


## Navigation simplification — 2026-10-14

### UX-NAV-001: Too many top-level navigation buttons
- **Request:** keep Home, Departments/Services, Capacity/Seats, Assignments/Distribution, History, Decisions, and Resident Summary as primary navigation items. Group resident-related actions under a Residents dropdown: manage/add residents, objectives, import residents, promotion/exam decisions, and DEMS-success graduates. Group app/admin actions under Settings: app settings, admin accounts, audit log, database backup, CSV export, restore, and logout.
- **Implementation:** updated the shared navigation in `app.py` at commit `093e075051b4cee2c25fa87904880be8456d153e`. Added native expandable `<details>/<summary>` menus and Arabic/French/English labels. Existing route URLs were retained; only navigation grouping/labels/styles changed.
- **Design detail:** submenu entries are shown only after opening the corresponding dropdown, reducing top-level clutter. Mobile sizing and menu scroll limits are included; Arabic RTL is inherited from the page shell.
- **Status:** implementation committed; automated tests and rendered/mobile viewport checks are **pending**. Do not call this verified until tests and smoke checks pass.

### UX-NAV-001 test checklist
- [ ] Run the complete automated test suite / inspect latest CI status.
- [ ] Check authenticated navigation contains only the agreed primary buttons plus Residents and Settings dropdowns.
- [ ] Open both dropdowns and verify all requested links preserve their original routes.
- [ ] Verify Arabic RTL, French, and English labels.
- [ ] Inspect narrow mobile viewport for clipping, overlap, and submenu reachability.


## ResiTrack branding — 2026-10-14

### BRAND-001: Consistent application name and medical icon
- **Request:** use the chosen name ResiTrack and give the application a polished, clearly dimensional medical identity focused on resident rotations, medicine, and anaesthesia/intensive care.
- **Implementation:** added a scalable SVG icon at `static/resitrack-icon.svg` with a dimensional shield, medical cross, ECG line, gradient, and depth shadow; wired it as the browser favicon and the shared page-header icon. Updated the application name across Arabic, French, and English labels and added a localized descriptive tagline. Existing route names, database paths, and stored data are untouched.
- **Verification:** GitHub Actions and browser/mobile rendering checks must be confirmed on this branch before the change is called verified. This is a web-app branding change, not an Android APK build.
- **Status:** implementation submitted for automated checks; visual/runtime verification pending.

## Continuity update — 2026-10-17

- Confirmed current working baseline was `main` at `2e737efe` before the no-cross icon change.
- PR #17 merged as `ef02c485647aca35a273f8d58320390554b272c3`: updated the Android launcher vector and `static/resitrack-icon.svg` with the ResiManage name and clinician/ICU-monitor/ECG design without a cross. No database or resident-history files changed.
- GitHub's Android APK workflow ran automatically on that merge and succeeded, even though no manual build was requested. To respect the standing instruction, `.github/workflows/android-apk.yml` was changed in commit `81a242c757f61192fb028537825fc94c6105e71d` to `workflow_dispatch` only. Future APK builds must be explicitly started by the user; ordinary pushes and PRs no longer trigger that workflow.
- Annual leave and external rotation functionality was ported from the stale PR #12 branch onto a fresh branch based on current main, without copying its obsolete icon assets or old UI styles. It adds tables only (no existing rows are deleted), 30-day annual leave tracking with carry-forward and overlap checks, external-rotation records, server-side blocking of overlapping local assignments, dashboard shortcuts, and regression tests.
- PR #18: `https://github.com/samyrius/ResiManage/pull/18`. Python GitHub Actions test suite passed on the current PR head before this archive update; recheck the latest run before merge.
- Outstanding validation: test the new leave/external-rotation screens on a phone; visually verify the launcher icon on-device. Do not claim the APK was manually built or installed. Continue preserving `rotation.db`, resident and stage histories, DEMS archive, photos and backups; never commit personal data or secrets.

## Continuity / defect log update — 2026-10-17

### BRAND-002: Login and registration still showed the retired ResiTrack name
- **Observed:** the shared header, Android label, and SVG used ResiManage, but the login/register/verification hero markup still rendered `Resi<span>Track</span>`; login hero used a warm pink/orange palette that no longer matched the approved navy/electric-blue/cyan/teal identity.
- **Fix applied on branch:** replace the remaining hero wordmark with ResiManage; align hero lighting, orbit glow, wordmark gradient, motto accent and footer separators with navy/cyan/teal; include ResiManage in the trilingual copyright line. Existing reduced-motion handling is retained.
- **Test:** add `test_login_branding_uses_resimanage_and_navy_cyan_identity` covering rendered login branding, no retired name, navy/cyan/teal color markers, reduced-motion CSS, trilingual rights line and absence of the cross-like `✚` glyph in login output.
- **Status:** merged in PR #20; current `main` contains the ResiManage login branding and navy/cyan regression test.

### VERIFIED-001: Current main regression suite
- **Evidence:** GitHub Actions Python application checks passed on commit `0287366dead0586867345dfb260f21b9f932be37`; the run covered the 29 current tests, including resident import/profile, promotion, DEMS archive, backup/restore, admin access, leave and external-rotation checks.
- **Limit:** passing automated tests do not verify physical Android installation, icon rendering on the launcher, real SMTP delivery, or visual layout on the user's phone.

### Remaining release gates (not falsely marked complete)
- [ ] Add deeper leave tests for multiple-year carry-forward, overlap rejection, and exact balance boundaries; review the meaning of the balance year (calendar vs academic year) with the written requirement.
- [ ] Verify external-rotation boundary dates and that assignment choices exclude a resident during an overlapping period (not just server-side rejection).
- [ ] Inspect/close obsolete PRs #12, #13 and #14 after confirming their useful changes have been recovered; review PR #7 selectively, never merge its divergent branch wholesale.
- [ ] Confirm real SMTP delivery only after authorized SMTP settings/test mailbox are available.
- [ ] Validate icon/UI on a physical phone and confirm Android package installability only after the user explicitly authorizes a build. Do not build an APK without that authorization.
- [ ] Keep all real databases, resident photos, backups, credentials and tokens out of Git.

### LEAVE-001 / EXT-001: Deeper leave accounting and external-rotation controls
- **Observed:** prior tests checked only one leave entry and a single active external rotation. The external assignment guard considered only status 'active', so a rotation marked 'returned' could fail to block an assignment entered later for the historical period it covered. The assignment dropdown also showed all residents even where a selected period overlapped an external rotation. External rotation records had no edit/cancel controls.
- **Fix applied on branch:** overlap checks now include active and returned external rotations and ignore only cancelled records; the assignment form marks conflicting resident options disabled based on the selected period; external rotation edit and cancel actions validate dates/required fields, preserve records, and write audit events. Added regression tests for multi-year leave carry-forward/overdraw, overlapping leave entries, returned-rotation period conflicts, assignment dropdown filtering, and audited edit/cancel.
- **Status:** merged in PR #21; current `main` contains the leave/external-rotation fixes. The PR's Python CI run succeeded (run 39020608604).
### CI-LEAVE-001: Refactor recovery and regression follow-up — 2026-10-17
- The first CI run for PR #21 exposed a source-refactor boundary error: the annual-leave route's final response template had been truncated while replacing the following external-rotation route. This was caught before merge; no changes reached main.
- Restored the complete annual-leave route verbatim from the current main baseline, then rechecked the boundary between the leave and external-rotation routes. The latest branch head is `097ed46032323368b82d5ab650ee785af02c0164`.
- **Status:** resolved before merge. The corrected changes were included in PR #21, whose Python CI run succeeded (run 39020608604).

### SEC-001: CSRF protection and official administrator safeguards
- **Observed:** current main had no CSRF validation on state-changing POST requests, and the user-management route allowed the official accounts named `benhocine` and `drdris` to be created with a normal-user role or deactivated.
- **Fix applied on branch:** add session-bound CSRF tokens to POST forms at render time, validate tokens before POST handlers, and reject missing/invalid tokens. Require official accounts to be created as Super Admins and prevent deactivation. Test client now obtains a real rendered token for ordinary form submissions; a separate test explicitly submits without a token.
- **Status:** merged in PR #22; the Python CI run succeeded (run 39020964223). No APK build was started.

### GOV-001: Dual-official decisions for progression and DEMS
- **Observed:** the current exams route advanced year-2/year-3 residents immediately after a single Super Admin click, and the DEMS route archived a year-4 resident after one administrator action. This did not meet the requirement that Pr Benhocine and Dr Dris jointly decide progression/final graduation.
- **Fix applied on branch:** added additive vote tables; restrict progression and DEMS votes to active Super Admin sessions for the exact official usernames `benhocine` and `drdris`; require a reason; keep the first vote pending; apply year advancement or DEMS-success archive only after both officials approve; if either rejects, do not advance/archive; log every vote and final decision to audit/decision records. Pending votes are visible on the corresponding pages.
- **Status:** merged in PR #23; the Python CI run succeeded (run 39020964223). DEMS archives preserve profile/history/exams and finalize only after dual approval.

### BACKUP-001 / EXPORT-001: Include all new records and resident photos
- **Observed:** CSV export did not include the new leave/external-rotation/official-vote tables. The database backup did not package resident photos, so restoring it on another device could leave profile photo paths broken.
- **Fix applied on branch:** CSV export includes leave balances, leave entries, external rotations, and pending/final official vote tables while continuing to exclude user password records. The backup is now a ZIP containing a consistent SQLite snapshot and all files in `resident_photos/`; restore accepts both this ZIP and legacy .db/.sqlite backups, validates archive paths and database integrity, creates a pre-restore full ZIP and DB copy, and restores photos only when the ZIP includes the photo folder. Added tests for database and photo restoration, and expanded export coverage.
- **Status:** merged in PR #24; the Python CI run succeeded (run 39021172710). No APK build or real resident-data change was part of the PR.


## ResiManage 1 / ResiManage 2 handover — 2026-10-17

- Repository verified: `samyrius/ResiManage`; current `main` tip at handover is `5a7dad81b81381a059a5fe698cadd0c1693a49a6`.
- Created `resimanage-1-backup` from that exact `main` commit. It is the frozen baseline; do not commit application changes to it.
- Created `resimanage-2-work` from `resimanage-1-backup`. Initial comparison confirmed both branches were identical to `main`; the backup branch remains identical to `main`.
- Recent merged work already present in that baseline includes PRs #15–#24: ResiManage display branding, navy/cyan UI, no-cross medical icon and removal of cross-like UI glyphs, annual leave and external rotations, hardening of leave/external rules, CSRF protection and protected official admins, dual-official progression/DEMS votes, and ZIP backups including resident photos plus expanded CSV export. Do not re-merge stale/divergent branches wholesale.
- Added a one-line CI trigger change on `resimanage-2-work` so the Python test workflow can run on this work branch; opened draft PR #25 (`https://github.com/samyrius/ResiManage/pull/25`) for review. It is intentionally not merged. GitHub Actions run #326 (run ID `39023073942`) passed **40 tests in 13.71 seconds** on the PR merge commit including this branch head. The new DEMS-rejection regression test is included.
- Android build workflow remains `workflow_dispatch` only. No APK was built or requested.

### Remaining release gates — do not mark complete without evidence

1. The current code/test change set passed Python CI: run #326, 40 tests in 13.71 seconds. Re-run checks after further code changes.
2. Review the complete requirements against the current code and add regression tests for any uncovered behavior, particularly the first-year rule, dual approvals, leave carry-forward/overlap, returned external rotations, and safe backup/restore.
3. Verify the exact launcher image request: current `static/resitrack-icon.svg` is a custom SVG clinician/ICU monitor/ECG illustration without a cross; it is **not confirmed to be the exact 3D doctor image previously sent by the user**. Do not claim it is that exact image without recovering and comparing the original asset.
4. Physical phone checks remain pending for responsive layout, usable navigation/buttons, Arabic RTL, and launcher icon rendering. Remote repository operations cannot prove these on-device checks.
5. Validate real import files on the target Termux environment. Legacy `.doc` requires `antiword` or LibreOffice; scanned PDFs need OCR outside the current importer.
6. Create/configure private accounts for Pr Benhocine and Dr Dris in the running app only when the user/admin can set their private passwords. Never store passwords or tokens in Git.
7. Keep `rotation.db`, resident histories, DEMS records, resident photos, backups, and secrets out of Git. Never overwrite user data without explicit permission.
8. Do not start the Android APK workflow unless the user explicitly asks for a build.


### RESI-2 / PROGRESSION-001: Prevent inactive residents from advancing — 2026-10-17

- **Baseline preserved:** all changes below are isolated on branch `resimanage-2-eligibility-guard`, created from `resimanage-2-work`. The frozen `resimanage-1-backup` branch and `main` were not modified.
- **Issue found in code review:** the first-year exam evaluation route advanced any resident whose marks passed, even if the resident's status was inactive. It also displayed an advancement success message whenever the exam criteria passed, which could misreport the outcome for a resident not currently in year 1.
- **Fix committed:** progression now updates only a resident who is both active and currently in year 1; the SQL update repeats those conditions to guard against a status/year change. The response distinguishes failed marks, a non-year-1 resident, an inactive resident, a successful advancement, and an unexpected no-op. Audit is written only when the guarded update actually changes the year.
- **Regression coverage added:** an inactive first-year resident with passing marks is evaluated; the test asserts the resident remains inactive in year 1 and no advancement audit event is recorded.
- **Commits:** implementation `d81d20b400d5ea44dcfb588c796dbe9f869d3934`; regression test `686b481b8af33c6166e72a265d1dcd1906508356`.
- **Verification status:** GitHub Actions run #353 (`39027838776`) passed **45 tests in 19.52 seconds** on the code-change head; follow-up run #354 (`39027903216`) passed **45 tests in 20.66 seconds** on the latest documentation-updated head. No APK build, user-phone experiment, database change, icon change, or theme/image change was made.
- **Next:** compare the remaining requirements against this exact branch, fix further confirmed gaps in isolated commits, and keep `resimanage-2-work` as the integration target. Do not merge into `main` or trigger the manual Android build without the user's later instruction.


### RESI-2 / AUTH-RESIDENT-CREATE-001: Restrict resident creation — 2026-10-17

- **Issue found in code review:** editing a resident was already restricted to Super Admin, but the creation branch of `/residents` accepted POSTs from any signed-in standard user. This contradicted the requirement that normal users have limited privileges.
- **Fix committed:** resident creation now explicitly requires `role=super_admin`; surname, first name, and study year are validated before insert; invalid input does not create a resident or write a creation audit event.
- **Regression coverage added:** a standard-user session posts a new resident and must receive HTTP 403, with no resident row or creation audit event.
- **Commits:** implementation `06401822f78bc56f82884143b5320e3faa9eea55`; test `4f127db73c08496697ee3e9d8bc8d083fe657696`.
- **CI evidence:** the combined changes passed run #353 (45 tests) and the latest head passed run #354 (45 tests). PR #29 was merged into `resimanage-2-work` with squash commit `4d6608e99fbdc5a6c9844488461181f743aa1d73`. `main` and `resimanage-1-backup` remain unchanged; no APK build, user-phone experiment, database change, or visual-asset change was made.


### RESI-2 / AUTH-EXAMS-001: Restrict exam mark changes — 2026-10-17

- **Issue found in code review:** exam evaluation and dual-official votes were role-guarded, but the `action=record` branch accepted exam mark creation/updates from any signed-in user. This could let a standard user alter academic records.
- **Fix committed:** recording or updating exam marks now returns HTTP 403 unless the signed-in account is a Super Admin. Existing dual-official progression voting remains restricted to the two named official administrators.
- **Regression coverage added:** a standard-user session attempts to post 20/20 marks; the request must be rejected and neither an exam row nor an exam-recorded audit event may be created.
- **Commits:** implementation `2351b99ca233d4cd4a44aec29b94de5be2a06ae4`; test `7d4dd99f07a1073fa8fe2e877765a1a9db0fc9e4`.
- **CI status:** latest head passed run #354 (`39027903216`): **45 tests passed in 20.66 seconds**. The changes were merged into `resimanage-2-work` in squash commit `4d6608e99fbdc5a6c9844488461181f743aa1d73`; no merge to `main` was performed.


### Post-merge confirmation — 2026-10-17

- PR #29 (https://github.com/samyrius/ResiManage/pull/29) is closed as merged into `resimanage-2-work` only. Squash commit: `4d6608e99fbdc5a6c9844488461181f743aa1d73`.
- Verified latest PR CI run #354 (`39027903216`) completed successfully: **45 passed in 20.66 seconds**. The tested head contains all three fixes and regression tests.
- `main` and frozen `resimanage-1-backup` were not changed by this merge. No APK was built, no phone-side experiments were run, and no user database/backups/secrets/assets were modified.
- Continue requirement-by-requirement code review against `resimanage-2-work`; the passing suite is useful evidence, not proof that every product requirement or physical-device behavior is complete.

### RESI-2 / ELIGIBILITY-INACTIVE-TERRAIN-001 — 2026-10-17

- **Audit finding:** repeat eligibility counted every mandatory/basic terrain, including terrains deactivated by an administrator. Because inactive terrains are excluded from new assignments, a resident who could never complete that terrain could remain blocked from repeating a previously completed terrain.
- **Fix proposed on isolated branch:** the required core-terrain count and the completed-terrain count now use active core terrains only. Historical rows are retained; no resident data or database was changed.
- **Regression test added:** deactivate an uncompleted core terrain, complete every remaining active core terrain, then verify a repeat assignment passes the eligibility check.
- **Branch:** `resimanage-2-inactive-terrain-eligibility`; based on `resimanage-2-work`. CI is pending; do not describe this fix as verified until the workflow completes successfully on the final branch head.
- **Safety:** no APK build, no phone/database access, no asset/theme edits, and no change to `main` or `resimanage-1-backup`.

### RESI-2 / PENDING-APPROVAL-REVALIDATION-001 — 2026-10-17

- **Audit finding:** a pending assignment could be approved after the resident became inactive, its terrain was deactivated, or an external rotation was subsequently recorded for the same period. Approval previously rechecked capacity and duplicates only.
- **Fix proposed on isolated branch:** before confirming a pending assignment, re-check resident active status, terrain active status, and overlap with any non-cancelled external rotation. If any condition fails, keep the assignment pending and do not write an approval audit event.
- **Regression tests added:** deactivated terrain and newly overlapping external rotation each prevent confirmation.
- **Branch:** `resimanage-2-pending-assignment-revalidation`; based on the updated `resimanage-2-work`. CI pending; verify the final head before merging.
- **Safety:** no database/real resident data/secrets/assets changed; no APK build or phone test started.

### RESI-2 / TERRAIN-CLASSIFICATION-MIGRATION-001 — 2026-10-17

- **Audit finding:** the startup seed used `INSERT OR IGNORE`, so existing databases kept outdated terrain categories even though fresh databases received the corrected classification. This could make legacy installations treat optional terrains as core, or Gynécologie as optional.
- **Fix proposed on isolated branch:** a one-time settings-keyed migration corrects the five agreed optional terrains (Sédation, Maxillo-faciale, Chirurgie cardiaque, Brûlés, CAC DBK) and keeps Gynécologie core/basic. The migration marker prevents startup from overwriting future authorized admin changes.
- **Regression test added:** start from a legacy database with incorrect categories, confirm migration, then change a category and verify a later initialization preserves the authorized change.
- **Branch:** `resimanage-2-terrain-classification-migration`; based on `resimanage-2-work`. CI pending; verify before merge.
- **Safety:** no real database or resident records accessed/modified; no APK build, phone test, secrets, or visual assets changed.

### RESI-2 / PASSWORD-STRENGTH-SETTINGS-001 — 2026-10-17

- **Audit finding:** account creation and first-run setup required passwords of at least 12 characters, but the settings page accepted a shorter administrator password.
- **Fix proposed on isolated branch:** enforce the same 12-character minimum server-side in settings and add the HTML `minlength` hint. A short value is rejected without changing the stored account hash.
- **Regression test added:** submit a short password and assert the warning is shown and the stored password hash remains unchanged.
- **Branch:** `resimanage-2-password-strength-guard`; based on `resimanage-2-work`. CI pending.
- **Safety:** no credentials stored in source; no database/real resident data/assets changed; no APK build or phone test started.

### RESI-2 / EXTERNAL-LOCAL-OVERLAP-001 — 2026-10-17

- **Audit finding:** local assignment checks correctly blocked new local rotations during external placements, but the reverse workflow could still create or edit an external placement over an already confirmed/pending local assignment.
- **Fix proposed on isolated branch:** external-rotation create and edit now compare the requested date range with the resident's confirmed/pending local assignments and reject overlaps. Cancelled/rejected local assignments do not block.
- **Regression tests added:** creating and editing external rotations over a local period must fail and must not persist the conflicting dates/record.
- **Branch:** `resimanage-2-external-local-conflict-guard`; based on `resimanage-2-work`. CI pending.
- **Safety:** no database/real resident data/secrets/assets changed; no APK build or phone test started.

### RESI-2 / DEMS-STATUS-BYPASS-001 — 2026-10-17

- **Audit finding:** the resident management form accepted `status='graduated'` directly, bypassing the required two-official DEMS decision/archive flow. It also allowed already-graduated residents to be reactivated from the same form. The edit branch did not explicitly commit its update, so ordinary resident edits could be lost when the connection closed.
- **Fix proposed on isolated branch:** only active/inactive status changes are accepted through resident management; graduation status is controlled by the DEMS workflow. Already-graduated residents are shown as archived rather than an editable status form. Valid resident edits are explicitly committed.
- **Regression test added:** verify a normal edit persists, direct graduation is rejected, and an archived graduate cannot be reactivated.
- **Branch:** `resimanage-2-dems-status-guard`; based on `resimanage-2-work`. CI pending.
- **Safety:** no real database/records/secrets/assets changed; no APK build or phone test started.

### RESI-2 / FIRST-YEAR-EVALUATION-STATE-001 — 2026-10-17

- **Audit finding:** the first-year evaluation endpoint could record a Passed/Failed decision and evaluation audit for a resident whose current year was not 1, or who was inactive. The previous advancement guard prevented changing their year, but the decision log could still misleadingly say their first-year exam was evaluated.
- **Fix proposed on isolated branch:** only active residents currently in year 1 may enter first-year evaluation. Other states return a clear message and create neither a decision nor an evaluation audit event.
- **Regression tests added:** inactive first-year and active later-year residents cannot create first-year evaluation decisions/audit records.
- **Branch:** `resimanage-2-first-year-evaluation-guard`; based on `resimanage-2-work`. CI pending.
- **Remaining dependency:** the app still needs the official first-year module list/weights before it can independently verify that every required module was entered; do not invent that curriculum.
- **Safety:** no real database/records/secrets/assets changed; no APK build or phone test started.

### RESI-2 / PROMOTION-STATE-BYPASS-001 — 2026-10-17

- **Audit finding:** resident management still allowed an administrator to jump a resident directly from year 1/2/3 to any other study year, bypassing automatic first-year exam evaluation or the required dual-official promotion votes for years 2–4.
- **Fix proposed on isolated branch:** year is now displayed read-only in resident management, and the server rejects any attempted year change there. Only the exam/promotion workflow can change study year; status and repeat-year edits remain available for non-graduated residents.
- **Regression coverage updated:** ordinary status edit persists without changing year; a direct year change is rejected and leaves year/status unchanged.
- **Branch:** `resimanage-2-promotion-state-guard`; based on `resimanage-2-work`. CI pending.
- **Safety:** no real database/records/secrets/assets changed; no APK build or phone test started.

### RESI-2 / PERIOD-COMPLETENESS-MIGRATION-001 — 2026-10-17

- **Audit finding:** startup and academic-year settings created four periods only when none existed for that year. A legacy database containing one to three periods would remain incomplete indefinitely.
- **Fix proposed on isolated branch:** both initialization and academic-year settings now use idempotent `INSERT OR IGNORE` for all four canonical periods, filling only missing entries without deleting or rewriting existing periods.
- **Regression test added:** start from a legacy database with one period, verify all four exist after initialization, and verify a second initialization does not duplicate them.
- **Branch:** `resimanage-2-period-completion-migration`; based on `resimanage-2-work`. CI pending.
- **Safety:** no real database/records/secrets/assets changed; no APK build or phone test started.

### RESI-2 / IMPORT-YEAR-VALIDATION-001 — 2026-10-17

- **Audit finding:** import converted the supplied year to `int(float(value))`, silently truncating fractional values such as `2.5` to year 2 instead of rejecting the malformed row.
- **Fix proposed on isolated branch:** require the imported year value to be an integer before checking it is in 1–4. Valid spreadsheet values such as `2` or `2.0` remain accepted.
- **Regression test added:** a CSV row with year 2.5 must show a validation error and must not create a resident.
- **Branch:** `resimanage-2-import-year-validation`; based on `resimanage-2-work`. CI pending.
- **Safety:** no real database/records/secrets/assets changed; no APK build or phone test started.

### RESI-2 / SESSION-REVOCATION-001 — 2026-10-17

- **Audit finding:** user deactivation prevented future logins but an already-authenticated session remained trusted because protected routes checked only the session cookie.
- **Fix proposed on isolated branch:** every protected request now verifies that the account still exists and is active, refreshes the role from the database, and clears/redirects inactive sessions.
- **Regression test added:** log in as a standard user, deactivate that account from the admin session, then verify the existing session is redirected to login and cleared.
- **Branch:** `resimanage-2-session-revocation-guard`; based on `resimanage-2-work`. CI pending.
- **Safety:** no real database/records/secrets/assets changed; no APK build or phone test started.

### RESI-2 / ASSIGNMENT-PERMISSION-001 — 2026-10-17

- **Audit finding:** standard users could create ordinary confirmed assignments through `/assign`; the route checked authentication but not the role. Other assignment administration and override actions were restricted.
- **Fix proposed on isolated branch:** assignment creation now requires Super Admin on the server, and the creation form is hidden from standard users while the assignment list remains viewable.
- **Regression test added:** a standard user can view assignments but cannot see or submit the assignment form; a forged POST returns 403 and creates no assignment/audit event.
- **Branch:** `resimanage-2-assignment-permission-guard`; based on `resimanage-2-work`. CI pending.
- **Safety:** no real database/records/secrets/assets changed; no APK build or phone test started.

- **Related UI issue found during verification:** role-based controls inside the page body were rendered without the `role` template variable. This hid assignment controls and other admin-only UI even for Super Admins. The shared page renderer now passes the active role into the body template context; regression tests for assignment controls cover this.

### RESI-2 / ASSIGNMENT-PERMISSION-001 — 2026-10-17

- **Audit finding:** the assignment route allowed a standard user to create rotation assignments even though the form already displayed administrative actions only to Super Admins.
- **Fix proposed on isolated branch:** only Super Admins can submit assignment creation; standard users receive a read-only explanation and do not see the creation form. Existing assignments remain visible.
- **Regression test added:** standard users cannot POST an assignment, no assignment/audit row is written, and the creation form is absent from their read-only page.
- **Branch:** `resimanage-2-assignment-permission-guard`; based on `resimanage-2-work`. CI pending.
- **Safety:** no real database/records/secrets/assets changed; no APK build or phone test started.

### RESI-2 / HISTORICAL-ROTATION-VALIDATION-001 — 2026-10-17

- **Audit finding:** manual history entry accepted arbitrary academic-year labels and period text and allowed exact duplicate history records. These records affect mandatory-terrain completion and could incorrectly block or permit repeat assignments.
- **Fix proposed on isolated branch:** validate consecutive `YYYY-YYYY` academic years, restrict period to the four official periods (or blank for legacy-unspecified periods), validate ISO completion dates, require existing resident/terrain records, and reject exact duplicates. The form now offers the four canonical periods.
- **Regression tests added:** reject malformed academic year and unknown period; accept one valid entry; reject a duplicate without adding a second row or audit event.
- **Branch:** `resimanage-2-history-validation-guard`; based on `resimanage-2-work`. CI pending.
- **Safety:** no real database/records/secrets/assets changed; no APK build or phone test started.

### RESI-2 / PROMOTION-INACTIVE-RESIDENT-001 — 2026-10-17

- **Audit finding:** the dual-official year-2/year-3 promotion endpoint accepted a vote for an inactive resident if a crafted POST supplied the resident ID. The UI listed active residents only, but server-side validation did not enforce that condition.
- **Fix proposed on isolated branch:** reject progression votes for inactive residents before inserting a vote or audit event.
- **Regression test added:** a Super Admin POST for an inactive year-2 resident produces no promotion vote and no vote audit record.
- **Branch:** `resimanage-2-promotion-active-resident-guard-v2`; based on the latest `resimanage-2-work`. CI pending.
- **Safety:** no real database/records/secrets/assets changed; no APK build or phone test started.

### RESI-2 / COMPLETION-EVIDENCE-001 — 2026-10-17

- **Audit finding:** mandatory/basic terrain completion counted every confirmed assignment, including assignments in future rotation periods. Future assignments could therefore make the resident appear to have completed all core terrains and unlock a repeat prematurely.
- **Fix proposed on isolated branch:** only documented history records and confirmed assignments whose rotation period has already ended count as completion evidence. Current/future assignments do not unlock repeats.
- **Regression test added:** a resident with history for one core terrain and confirmed assignments for all core terrains in academic years starting in 2099 or later must still be blocked from repeating the historical terrain.
- **Branch:** `resimanage-2-completion-evidence-guard-v2`; based on the latest `resimanage-2-work`. CI pending.
- **Safety:** no real database/records/secrets/assets changed; no APK build or phone test started.

### RESI-2 / CAPACITY-INPUT-VALIDATION-001 — 2026-10-17

- **Audit finding:** capacity editing silently converted negative places to zero and accepted a period ID from a different academic year while writing the currently selected year label. Malformed numeric values could also raise an unhandled error.
- **Fix proposed on isolated branch:** require a non-negative whole number, an active terrain, and a period belonging to the selected academic year; reject malformed input without writing capacity changes.
- **Regression test added:** negative capacity and a period from academic year 2099–2100 are rejected and create no invalid capacity rows.
- **Branch:** `resimanage-2-capacity-input-validation`; based on `resimanage-2-work`. CI pending.
- **Safety:** no real database/records/secrets/assets changed; no APK build or phone test started.

### RESI-2 / CAPACITY-INPUT-VALIDATION-001 — 2026-10-17

- **Audit finding:** capacity updates coerced negative values to zero and did not verify that the selected period belonged to the chosen academic year or that the terrain remained active.
- **Fix proposed on isolated branch:** reject negative/non-integer capacity values, inactive/missing terrains, and periods outside the selected academic year; retain the existing guard that prevents capacity from dropping below confirmed/pending assignments.
- **Regression tests added:** negative capacity and cross-year period are rejected without writing capacity rows.
- **Branch:** `resimanage-2-capacity-input-validation`; based on `resimanage-2-work`. CI pending.
- **Safety:** no real database/records/secrets/assets changed; no APK build or phone test started.

### RESI-2 / IMPORT-CONFIRMATION-RECHECK-002 — 2026-10-17

- **Audit finding:** import rows were checked for duplicates when the preview was created, but not rechecked when the administrator confirmed. A second administrator could create one of those residents between preview and confirmation.
- **Fix proposed on isolated branch:** revalidate each row against live database records and within the import batch at confirmation time. If the preview is stale or a write constraint occurs, cancel the whole import without an import audit event; do not partially import rows.
- **Regression test added:** a two-row preview becomes stale after one resident is added; confirmation imports neither row and records no import audit event.
- **Branch:** `resimanage-2-import-confirmation-recheck-v4`; based on the latest `resimanage-2-work`. CI pending.
- **Safety:** no real database/records/secrets/assets changed; no APK build or phone test started.

### RESI-2 / REPEAT-ELIGIBILITY-CROSS-YEAR-001 — 2026-10-17

- **Audit finding:** the repeat guard searched for an earlier assignment of the same terrain only within the current academic year. A resident with a confirmed assignment for a core terrain in a prior academic year and no manual history row could be assigned that terrain again before completing all mandatory/basic terrains.
- **Fix proposed on isolated branch:** check prior confirmed/pending assignments for the same terrain across all academic years; repeat remains allowed only once all active mandatory/basic terrains have completion evidence.
- **Regression tests:** prior-year confirmed assignment without a history row is blocked; the future-completion test excludes the terrain being tested so it specifically checks that future assignments do not count as completion evidence.
- **Branch:** `resimanage-2-repeat-eligibility-cross-year-v2`; based on the latest `resimanage-2-work`. CI pending.
- **Safety:** no real database/records/secrets/assets changed; no APK build or phone test started.

### RESI-2 / HISTORY-FUTURE-DATE-GUARD-001 — 2026-10-17

- **Audit finding:** manual history entry accepted future completion dates, and the repeat-eligibility calculation treated every history row as completed regardless of its date. Incorrect future-dated records could unlock repeats prematurely.
- **Fix proposed on isolated branch:** reject future completion dates in manual history entry and exclude future-dated legacy/history rows from completed mandatory/basic terrain evidence.
- **Regression tests:** reject future-dated manual history; prove future-dated rows for all core terrains do not unlock a repeat.
- **Branch:** `resimanage-2-history-future-date-guard-v2`; based on the latest `resimanage-2-work`. CI pending.
- **Safety:** no real database/records/secrets/assets changed; no APK build or phone test started.

### RESI-2 / EXAM-RECORD-STAGE-GUARD-001 — 2026-10-17

- **Audit finding:** the exam-record endpoint accepted marks for study years beyond the resident's current year and allowed edits after a resident was archived as a DEMS graduate. This could make the live exam record disagree with the immutable graduation snapshot.
- **Fix proposed on isolated branch:** reject future-year marks and make exam records read-only after DEMS graduation; retain admin ability to record valid current/past-year marks for non-graduated residents.
- **Regression test added:** future-year marks and post-graduation marks create neither exam rows nor exam audit events.
- **Branch:** `resimanage-2-exam-record-stage-guard`; based on `resimanage-2-work`. CI pending.
- **Safety:** no real database/records/secrets/assets changed; no APK build or phone test started.

### RESI-2 / TERRAIN-CLASSIFICATION-IMMUTABILITY-001 — 2026-10-17

- **Audit finding:** changing a terrain from mandatory/basic to optional (or changing its year requirement) after history or assignments exist rewrites the meaning of past records and changes repeat eligibility retroactively.
- **Fix proposed on isolated branch:** reject changes to `kind` and `mandatory_year` once any history or assignment references the terrain. Renaming remains available. Existing terrain deactivation behavior is intentionally preserved because the current tests and workflow treat deactivation as an administrative retirement, not deletion.
- **Regression test added:** after a resident has a history record for a terrain, an attempt to change its classification is rejected and the existing classification/history remain unchanged.
- **Branch:** `resimanage-2-terrain-classification-history-guard`; based on `resimanage-2-work`. CI pending.
- **Safety:** no real database/records/secrets/assets changed; no APK build or phone test started.

### RESI-2 / PROFILE-INPUT-VALIDATION-001 — 2026-10-17

- **Audit finding:** profile updates accepted blank/overlong identity fields and future/invalid birth dates. The handler also defaulted a missing `photo_path` field to an empty string, so a crafted or partial update could unintentionally detach the existing resident photo.
- **Fix proposed on isolated branch:** validate surname/first name, birth place, phone, and ISO birth date (not in the future) before processing uploads; preserve the existing photo path when the field is omitted.
- **Regression test added:** invalid identity input is rejected without changing the record, and a valid partial profile update preserves the existing photo.
- **Branch:** `resimanage-2-profile-input-validation`; based on `resimanage-2-work`. CI pending.
- **Safety:** no real database/records/secrets/assets changed; no APK build or phone test started.

### RESI-2 / RESIDENT-INPUT-VALIDATION-001 — 2026-10-17

- **Audit finding:** resident creation converted the repeat-year flag to an integer without validating it, accepted overlong phone values, and did not consistently block case-insensitive duplicate name/year records outside the import workflow.
- **Fix proposed on isolated branch:** validate required names (maximum 100 characters), phone (maximum 40 characters), year 1–4 and repeat flag 0/1; reject a duplicate case-insensitive surname/first-name/year combination.
- **Regression tests added:** malformed repeat flag and overlong phone are rejected, and duplicate resident rows are not inserted.
- **Branch:** `resimanage-2-resident-input-validation`; based on `resimanage-2-work`. CI pending.
- **Safety:** no real database/records/secrets/assets changed; no APK build or phone test started.

### RESI-2 / OBJECTIVE-INPUT-VALIDATION-001 — 2026-10-17

- **Audit finding:** objective creation trusted form values for terrain ID and study year, allowing objectives for inactive/nonexistent terrains, invalid years, and duplicate objective text.
- **Fix proposed on isolated branch:** require an active terrain, study year 1–4, non-empty objective text up to 1000 characters, and reject case-insensitive duplicates for the same terrain/year.
- **Regression tests added:** invalid year, inactive terrain, and duplicate objective are rejected; only one valid row is saved.
- **Branch:** `resimanage-2-objective-input-validation-v3`; based on the latest `resimanage-2-work`. CI pending.
- **Safety:** no real database/records/secrets/assets changed; no APK build or phone test started.

### RESI-2 / DOCUMENTED-HISTORY-IMPORT-001 — 2026-10-17

- **Audit finding:** the active import screen supported resident records only; it did not provide a workflow for importing documented historical stages, despite this being a core requirement.
- **Fix proposed on isolated branch:** add a separate `/import-history` preview-first flow for CSV/XLS/XLSX/DOC/DOCX/text-PDF. Resident and terrain must resolve to existing records; academic year, official period, date, duplicate rows, and future completion dates are validated. Confirmation rechecks live data and imports only the documented rows. No inferred history is generated.
- **Schema migration:** add `import_type` to existing import-preview tables with default `residents`, preserving existing previews and databases.
- **Regression test added:** valid history is written only after preview confirmation; future-dated history is rejected without extra history rows.
- **Branch:** `resimanage-2-documented-history-import`; based on the latest `resimanage-2-work`. CI pending.
- **Safety:** no real database/records/secrets/assets changed; no APK build or phone test started.

### RESI-2 / UNDATED-FUTURE-HISTORY-GUARD-001 — 2026-10-17

- **Audit finding:** historical rotations with an empty completion date were counted as completed regardless of their academic year/period. Future-dated rows such as 2098–2099 could therefore unlock repeats of mandatory/core terrains.
- **Fix proposed on isolated branch:** count a history row only when its explicit ISO completion date is not in the future, or when its official period end is already in the past if no exact date was recorded. Malformed dates are not completion evidence.
- **Regression test added:** all core terrains recorded in a future academic year with blank completion dates must not authorize a repeat.
- **Branch:** `resimanage-2-history-undated-future-guard`; based on the current `resimanage-2-work`. CI pending.
- **Safety:** no resident database or real records changed; no APK build or phone test started.

### RESI-2 / EXAM-INPUT-VALIDATION-001 — 2026-10-17

- **Audit finding:** malformed resident/year IDs or non-numeric exam marks raised uncaught conversion errors in the exam POST route, producing server errors rather than a safe validation response.
- **Fix proposed on isolated branch:** validate ID/year conversion and numeric score conversion before querying or writing; return a clear message and redirect when invalid.
- **Regression test added:** malformed study year and non-numeric theory mark produce a normal response and do not create exam or audit records.
- **Branch:** `resimanage-2-exam-input-validation`; based on the current `resimanage-2-work`. CI pending.
- **Safety:** no real resident data or database files changed; no APK build or phone test started.


### RESI-2 / DEMS-FUTURE-DATE-001 — 2026-10-17

- **Audit finding:** the DEMS voting endpoint accepted a syntactically valid exam date in the future, allowing an official vote to be recorded before the stated exam occurred.
- **Fix proposed on isolated branch:** reject a future DEMS exam date before inserting a vote or audit event. Past and current dates remain accepted.
- **Regression test added:** a future-dated vote returns a validation message and creates no DEMS vote, archive entry, or vote audit record.
- **Branch:** `resimanage-2-dems-future-date-guard`; based on `resimanage-2-work`. CI pending.
- **Safety:** no resident data/database files/secrets/assets changed; no APK build or phone test started.


### RESI-2 / ADMIN-RECORD-ID-VALIDATION-001 — 2026-10-17

- **Audit finding:** malformed assignment-decision IDs and user-management IDs raised uncaught integer-conversion errors in Super Admin routes.
- **Fix proposed on isolated branch:** parse these form IDs using Flask's typed form accessor so malformed values resolve to no matching record instead of raising a server error. No record or audit event is written for malformed IDs.
- **Regression test added:** malformed decision and user IDs return normal responses and create no decision or audit records.
- **Branch:** `resimanage-2-admin-id-validation`; based on `resimanage-2-work`. CI pending.
- **Safety:** no real resident data/database files/secrets/assets changed; no APK build or phone test started.


## User-approved delivery workflow — 2026-10-17 (highest priority)

### WORKFLOW-ORDER-001: Verify in ResiManage 1 first, then synchronize ResiManage 2
- **Explicit user instruction:** implement proposed changes on the ResiManage 1 candidate, run automated checks and controlled functional verification, and only after the changes are shown to work, port the same verified changes to ResiManage 2 so both lines remain at the same level of progress.
- `resimanage-1-backup` is a protected reference/backup branch: do not commit changes directly to it. Make candidate changes on a separate branch based on that backup; keep the backup branch itself unchanged.
- Do not port unverified code to ResiManage 2. A matching PR may be prepared for comparison, but it must remain unmerged/on hold until ResiManage 1's exact candidate head passes CI and the code/test diff is reviewed. Then port the verified patch onto the latest `resimanage-2-work` without dropping its newer safeguards, add/run regression tests, and verify CI on the exact ResiManage 2 PR head.
- "Verified" means: CI passes on the exact head SHA; relevant regression tests pass; diff reviewed for unintended changes. Phone/WebView behavior remains explicitly unverified until the user authorizes a controlled phone test. Do not build an APK unless the user explicitly requests one.
- Protect real data: no real database, resident records, stage history, photos, backups, passwords or tokens in Git. No destructive changes to either backup branch.

### PHOTO-001: Resident profile photo upload and profile usability
- **User report:** the resident photo upload previously failed in a phone test and must be investigated rather than assumed fixed.
- **ResiManage 1 candidate:** PR #71 — https://github.com/samyrius/ResiManage/pull/71, branch `resimanage-1-photo-ui-candidate`, based on `resimanage-1-backup` without modifying the backup branch.
- **Candidate changes described in PR:** decode and verify uploaded image content with Pillow (not signature-only checking); normalize EXIF orientation; resize to maximum 1200×1200; save with unique names and atomic writes; preserve an existing photo if no valid replacement is selected; remove manual photo-path editing; provide photo picker, preview/status feedback, responsive profile layout and visible keyboard focus.
- **Candidate regression tests described in PR:** valid image upload-and-serve round trip; corrupt image rejected without replacing the current photo; saving profile fields without a new photo preserves the existing photo.
- **Benchmark artifact:** `docs/UX_BENCHMARK.md` records a review of 10 comparable platforms and 14 related websites to inform an ergonomic, modern and practical internal interface. Review the actual document and candidate diff before claiming the benchmark findings are complete.
- **Current evidence recorded in PR #71 description:** automated CI was requested; the description does not establish the current latest run status. Confirm the exact head SHA and CI result before calling the ResiManage 1 candidate verified. Android/WebView file-picker behavior still requires a later controlled phone test.
- **ResiManage 2 port:** PR #72 — https://github.com/samyrius/ResiManage/pull/72, branch `resimanage-2-photo-ui-port`, is already prepared as a port candidate. Per WORKFLOW-ORDER-001, keep it unmerged and do not call it verified until PR #71 passes on its exact final head, then compare the patch and run CI on the exact final PR #72 head.
- **No APK build or phone test was started as part of this work.**

### UX-ORDER-001: Internal interface redesign
- **Goal:** a polished, future-facing, elegant, modern, ergonomic, well-organized, practical and easy-to-use interface, especially on mobile and in Arabic RTL, without sacrificing core workflow speed.
- **Research requirement from user:** assess at least 10 known comparable applications/platforms and at least 10 relevant websites in the same domain; summarize patterns and trade-offs in `docs/UX_BENCHMARK.md` before choosing design changes.
- **Implementation order:** benchmark and document findings; prototype the interface on the ResiManage 1 candidate; verify responsive layout/navigation and regression tests; only then port the reviewed design to ResiManage 2. Do not start a build or phone test unless explicitly requested.
- **Acceptance checklist:** clear information hierarchy; minimal top-level navigation with related tasks grouped; prominent daily actions (resident search, assignment, capacity and period); readable status/eligibility indicators that do not rely on color alone; responsive resident cards/profile photo; accessible form labels, errors and keyboard focus; safe confirmation for destructive/admin actions; Arabic RTL plus French/English consistency; no horizontal overflow on narrow screens; existing URLs and data behavior preserved.
- **Status at time of entry:** requirement and workflow recorded; visual usability on an actual phone is not yet verified. Inspect `docs/UX_BENCHMARK.md` and the PR diff before claiming the 10-app/10-site review or redesign is complete.

### Immediate next verification steps
1. Fetch PR #71 and PR #72 current metadata, compare their latest head SHAs, and inspect the benchmark document and changed-file patches.
2. Check GitHub Actions for the exact PR #71 head. If it fails, fix and rerun only on the candidate branch; never change `resimanage-1-backup`.
3. After PR #71 passes and the patch is reviewed, verify that PR #72 is a clean port onto the latest `resimanage-2-work`; run its tests/CI on the exact head before considering merge.
4. Keep photo upload round-trip, corrupt-file handling, preservation of existing photos, and mobile file-picker verification as separate evidence items. CI can verify Flask upload handling, but cannot by itself prove Android/WebView picker behavior.
5. Continue the broader application audit only on isolated branches and keep this archive updated with exact SHA/run links and factual statuses.


## Photo/profile candidate verification checkpoint — 2026-10-17

- Re-fetched PR #71 (ResiManage 1 candidate). Its current head is `528d2c03e8e244f12879818fd05f471bf8c6b9d1`; GitHub Actions Python application checks completed successfully for this exact head (run **39043289602**). This establishes automated CI success for the candidate, not successful Android/WebView photo-picker operation.
- PR #71 remains open/unmerged. The protected `resimanage-1-backup` branch has not been modified.
- Re-fetched PR #72 (ResiManage 2 port). Its current head is `d52b7802484774c3a3036bab456d9cd35b38107e`; the previously mentioned passing run was for earlier SHA `88d59c36b02a8becd051ccf5f303977c0e84b605`, not this current head. The current-head workflow/status lookup returned no qualifying PR workflow run/status, so **PR #72 is not yet verified on its exact head**. It is open and GitHub currently reports it as not mergeable; investigate/rebase against latest `resimanage-2-work` and obtain CI on the exact resulting head before merge.
- `docs/UX_BENCHMARK.md` exists on the ResiManage 1 candidate and lists 10 comparable platforms, 14 related websites, and UX principles. Treat this as a documented desk review, not proof of hands-on testing of each product/site. The current candidate is profile-focused; a full redesign of all app screens is not yet complete.
- **Install/phone test decision:** do not ask the user to install yet. First resolve PR #72's base/CI state and review the port. When a clean ResiManage 2 candidate has passing exact-head CI and code review, ask the user for one controlled phone test specifically covering selecting a resident photo from Android storage, preview/save, profile reload, and image persistence. This is the point where device verification is genuinely required; do not build an APK unless the user explicitly authorizes it.
- No APK was built and no phone/database/real resident data was touched during this checkpoint.


## User-directed photo-fix sequence and live GitHub check — 2026-10-17 (follow-up)

- User reaffirmed the order: first implement and verify the resident-photo/profile fix on the ResiManage 1 candidate; then keep ResiManage 2 aligned by porting the same reviewed fix. This sequence is now the active acceptance gate.
- PR #71 current exact head `528d2c03e8e244f12879818fd05f471bf8c6b9d1` has Python CI success, run [39043289602](https://github.com/samyrius/ResiManage/actions/runs/39043289602). This is automated Flask/Python evidence only; it does not establish Android/WebView gallery-picker behavior. PR #71 remains open; protected `resimanage-1-backup` remains untouched.
- PR #72 is open on head `d52b7802484774c3a3036bab456d9cd35b38107e`, and GitHub currently reports it non-mergeable. Its previously cited successful run was for older SHA `88d59c36b02a8becd051ccf5f303977c0e84b605`; no qualifying PR workflow run was found for the current head. A compare of its base `79d1e400b20cfa9f59a8e243b43a70d591d5ef3d` against current `resimanage-2-work` head `763bb85883822808dc9871bb15e1da96ac75a4e4` shows the two intervening commits changed only `docs/PROJECT_ARCHIVE.md`. Resolve that documentation conflict cleanly, then rerun CI on the exact refreshed port head before merge.
- The UX desk-review artifact `docs/UX_BENCHMARK.md` is present on both candidate branches and lists 10 comparable GME/residency scheduling platforms and 14 related websites. This fulfills the research-count/documentation requirement as a desk review; it is not hands-on usability testing, and the current UI work is a resident-profile/photo first pass, not a complete redesign of every screen.
- Still pending: explicit user-authorized APK/device test of Android/WebView file selection, preview, save and reload/persistence; do not build an APK before the user requests it. No real DB/photos/secrets were touched.


## Live continuation checkpoint — 2026-10-17 (latest GitHub re-check)

- **ResiManage 1 photo/profile candidate PR #71:** still open and unmerged; exact head `528d2c03e8e244f12879818fd05f471bf8c6b9d1`. GitHub Actions `Python application checks` completed with conclusion `success` on this exact SHA (run [39043289602](https://github.com/samyrius/ResiManage/actions/runs/39043289602)). The test suite covers valid upload/serve, corrupt-image rejection with preservation of existing photo, and profile save without a replacement. This is automated server-side verification only; no Android/WebView gallery-picker or launcher-on-device test was performed. The protected `resimanage-1-backup` ref was not altered.
- **ResiManage 2 photo port PR #72:** still open/unmerged, exact head `3f8e0eef0cf61f438878e4cf5600db497ada6f76`; GitHub reports `mergeable=false`. Workflow lookup returned no CI run for this exact head. Comparing current `resimanage-2-work` (base tip `d4f18a1960d897c4cfd0e6d16504426fe98a5b6d`) against PR head reports `diverged`, 15 commits ahead and 3 behind, with changes touching application, tests, workflow, icon assets, requirements and archive. Do not merge or describe this port as verified; refresh/rebase it onto the current work branch, review the full diff, and obtain CI on the exact refreshed head.
- **UX benchmark:** `docs/UX_BENCHMARK.md` on the ResiManage 1 candidate lists 10 GME/residency scheduling platforms and 14 relevant web resources, plus actionable design patterns. It is a desk review, not hands-on usability testing. Current UI implementation is a focused resident-profile/photo improvement; the requested full internal navigation/dashboard redesign remains incomplete.
- **No APK build or device test** was performed, consistent with the user's standing instruction. Next gates: refresh and validate the ResiManage 2 port; then, only when user explicitly authorizes an APK, conduct a controlled Android test of photo selection, preview, save, reload and persistence. Continue full UI redesign as a separate scoped candidate, preserving backup/data safety.
