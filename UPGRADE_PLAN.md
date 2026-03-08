# Development Plan: Professional CV Maker Upgrade

This plan outlines the steps to upgrade `bangla_smart_cv_maker` to include professional/ATS-friendly features and industry-standard templates.

## Phase 1: Data Model Expansion (Foundation)
- [x] **Step 1.1:** Update `CVModel` to include:
    - `List<Project> projects` (Name, Description, Tech Stack, Link)
    - `List<SocialLink> links` (Platform name, URL)
    - `List<String> certifications`
    - `List<String> languages`
- [x] **Step 1.2:** Regenerate Hive adapters (`build_runner`).

## Phase 2: Editor UI Enhancement (Data Collection)
- [x] **Step 2.1:** Add new steps in `EditorView` for:
    - Projects & Portfolio
    - Social Links & Professional Profiles
    - Languages & Certifications
- [x] **Step 2.2:** Update `EditorController` to handle new controllers and lists.

## Phase 3: Template Research & Implementation (The "Google" Standard)
- [x] **Step 3.1:** Research 10-12 industry-standard templates (ATS-friendly, Harvard, Modern Tech, etc.).
- [x] **Step 3.2:** Implement 10-12 templates in `PdfService` using the expanded data model.
- [x] **Step 3.3:** Ensure all templates are dynamic (hide empty sections).

## Phase 4: Quality Assurance (QA)
- [x] **Step 4.1:** Manual test of PDF generation for all templates.
- [x] **Step 4.2:** Fix UI overflows or PDF layout issues.
- [x] **Step 4.3:** Run `flutter analyze` and `flutter test`.

## Phase 5: Deployment
- [ ] **Step 5.1:** Git commit and push to `origin/main`.

---
*Created by Bondhu 🛠️ on 2026-03-08*
