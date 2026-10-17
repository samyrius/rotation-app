# ResiManage

ResiManage is the resident rotation management application (formerly titled Rotation App in parts of the codebase). The interface supports Arabic, French, and English, with right-to-left layout for Arabic. Its medical shield icon is provided as `static/resitrack-icon.svg`.

Flask application for managing resident rotations, with Arabic/French/English UI and Arabic RTL.

## Local setup

```sh
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python app.py
```

Open `http://127.0.0.1:5000` in the browser. On a new empty database, create the first administrator password on the login page. Existing `rotation.db` files and their histories must be preserved; do not delete or replace them when updating code.

## Try ResiManage 2 in a browser (GitHub Codespaces)

For a disposable test environment, open [Create a Codespace on resimanage-2-work](https://github.com/codespaces/new?repo=samyrius/ResiManage&ref=resimanage-2-work). Codespaces may ask you to sign in and confirm available quota/billing before creating the environment. The devcontainer installs the Python requirements and starts the Flask app on port 5000.

This Codespace creates its own ignored `rotation.db` and `.rotation_secret`; it does not copy your phone's database or modify ResiManage 1. On first open, create a test administrator password. Use only fictional test residents in this environment. To view startup errors, inspect `/tmp/resimanage-demo.log` in the Codespace terminal. Do not enable public port access for real resident data.

## Current development branch

The reviewed changes from `prototype/verification-2026-10-13` were merged into `main` through PR #8 (merge commit `52127b58aa1bcc7f86f320c34f7de35f0c63922e`). The code includes 19 seeded terrains, capacity and assignment rules, individual roles, resident profiles, exam progression, objectives, DEMS archive, validated resident-list import, CSV export, and backup/restore with a pre-restore safety copy.

The import preview supports CSV, XLS/XLSX, DOC/DOCX and text-based PDF. Legacy `.doc` files require `antiword` or LibreOffice. Scanned PDFs without extractable text need OCR before import. Imported lists never fabricate previous rotations.

Keep the local secret key, database, backups, uploaded resident photos, and personal data out of Git. GitHub Actions runs the automated test suite against isolated temporary databases.

## ملاحظة بالعربية

لا تحذف قاعدة البيانات `rotation.db` عند تحديث الكود. تم دمج التعديلات في `main` بعد نجاح 25 اختبارًا آليًا على الفرع قبل الدمج؛ يجب انتظار نتيجة CI بعد الدمج أيضًا. قبل استرجاع نسخة احتياطية، ينشئ التطبيق نسخة من قاعدة البيانات الحالية.