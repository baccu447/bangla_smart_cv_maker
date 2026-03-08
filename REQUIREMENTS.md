# Project: Bangla Smart CV Maker 📝

## 1. Overview
A mobile application to help Bangladeshi job seekers create professional CVs/Resumes in minutes. Users input their data once and can generate multiple PDF styles.

## 2. Features 🚀

### Core Functionality
- **Personal Details:** Photo, Name, Contact, Address.
- **Academic Info:** SSC, HSC, Honours, Masters (Dynamic add).
- **Experience:** Job title, Company, Duration, Description.
- **Skills:** Technical & Soft skills with proficiency levels.
- **Projects:** Title, Description, Link.
- **References:** Name, Designation, Contact.
- **Objective:** Pre-written suggestions or custom input.

### CV Generation
- **Live Preview:** See changes in real-time (or near real-time).
- **PDF Export:** High-quality A4 PDF generation.
- **Multiple Templates:** 
  - *Basic:* Simple, text-heavy (Free).
  - *Modern:* Icons, sidebar, colors (Ad-locked).
  - *Creative:* Unique layouts (Rewarded Ad).

### User Data
- **Local Save:** Save data on device (SQLite/Hive) so users can edit later.
- **Multi-Profile:** Create CVs for different job roles (e.g., one for Dev, one for Marketing).

## 3. Screens & UI Flow 📱
1.  **Splash Screen:** Logo & Branding.
2.  **Home/Dashboard:** List of created CVs, "Create New" button.
3.  **Editor (Tabbed/Stepper):** 
    - Personal Info
    - Education
    - Experience
    - Skills/Projects
4.  **Template Selector:** Carousel of available designs.
5.  **PDF Preview:** Zoomable view of the final CV.
6.  **Download/Share:** Save to file manager or share via email/WhatsApp.

## 4. Technical Stack 🛠️

### Mobile (Flutter)
- **State Management:** GetX (recommended for simplicity) or Provider.
- **Local Database:** Hive (fast) or SQLite.
- **PDF Generation:** `pdf` package (pub.dev).
- **UI Components:** Material Design 3.

### Backend (Laravel API) - Optional for MVP, but good for scaling
*If we want dynamic templates or cloud sync later:*
- **Auth:** Sanctuem (Phone/Google Login).
- **Endpoints:**
  - `GET /api/templates` (Fetch template config/JSON).
  - `POST /api/feedback` (User feedback).
  - `GET /api/app-version` (Force update check).

## 5. Monetization Strategy (AdMob) 💰

| Ad Format | Placement | Trigger Logic |
| :--- | :--- | :--- |
| **Banner Ad** | Bottom of Editor Screens | Always visible while typing. |
| **Interstitial Ad** | Before "Generate PDF" | Show when user clicks "Preview" or "Download". (Cap: 1 per 5 mins). |
| **Rewarded Ad** | Template Selection | "Watch Video to Unlock Premium Template". |
| **Native Ad** | Home Screen List | Inserted between saved CV items. |

## 6. Development Roadmap ths
1.  **Phase 1:** UI Skeleton & Input Forms.
2.  **Phase 2:** Local Database Integration (Save/Load).
3.  **Phase 3:** PDF Generation Logic (Hardest part).
4.  **Phase 4:** AdMob Integration.
5.  **Phase 5:** Testing & Release.
