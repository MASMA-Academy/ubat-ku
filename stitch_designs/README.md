# UbatKu Medicine Reminder App - Stitch Design Assets

**Project**: UbatKu Medicine Reminder App  
**Stitch Project ID**: 16193031404494907077  
**Design Theme**: UbatKu (Material Design 3 inspired)  
**Device Type**: Mobile (390x780 - 780 px width)

## Project Overview

UbatKu is a Flutter mobile application designed to remind users to take their medications on time. The app features a modern, user-friendly interface with a teal/green color scheme.

### Design System

**Primary Colors**:

- Primary: `#006b5f` (Teal)
- Primary Container: `#00a896` (Bright Teal)
- Secondary: `#006d36` (Green)
- Tertiary: `#005bc0` (Blue)

**Typography**:

- Font Family: Inter
- Display: 32px, 700 weight
- Headline LG: 24px, 600 weight
- Headline MD: 20px, 600 weight
- Body LG: 18px, 400 weight
- Body MD: 16px, 400 weight

**Spacing**:

- Container Margin: 20px
- Inline Gap: 12px
- Section Padding: 24px
- Stack Gap: 16px
- Roundness: 8px

## Screens

### 1. Splash Page & Reminder Preview

**Screen ID**: `071ea5fae61449d38ecf1bc216c65e32`

- **Dimensions**: 390 x 1768 px
- **Type**: Mobile
- **Description**: Initial splash screen displayed when users first open the app, showing the app logo and a preview of upcoming medication reminders
- **Files**:
  - Screenshot: `screenshots/01_splash_page.jpg`
  - Code: `code/01_splash_page.html`

### 2. Login Page

**Screen ID**: `b0a4bbe3ce004601a520cee4991614c5`

- **Dimensions**: 390 x 1768 px
- **Type**: Mobile
- **Description**: User authentication screen with email/password input fields and login button
- **Files**:
  - Screenshot: `screenshots/02_login_page.jpg`
  - Code: `code/02_login_page.html`

### 3. Dashboard

**Screen ID**: `9541105177734a8bad54dd261431c816`

- **Dimensions**: 390 x 1768 px
- **Type**: Mobile
- **Description**: Main dashboard showing upcoming medications, daily schedule, and quick action buttons
- **Files**:
  - Screenshot: `screenshots/03_dashboard.jpg`
  - Code: `code/03_dashboard.html`

### 4. Medication History

**Screen ID**: `1bb093ec17d64194a5829e01dc02e06e`

- **Dimensions**: 390 x 1768 px
- **Type**: Mobile
- **Description**: Historical log of medications taken, with dates, times, and medication details
- **Files**:
  - Screenshot: `screenshots/04_medication_history.jpg`
  - Code: `code/04_medication_history.html`

### 5. Add Medicine & Reminder

**Screen ID**: `499af0972d724ab9800e52285cd8de2a`

- **Dimensions**: 390 x 2756 px
- **Type**: Mobile
- **Description**: Form to add new medications and set up reminder schedules, with scrollable content
- **Files**:
  - Screenshot: `screenshots/05_add_medicine.jpg`
  - Code: `code/05_add_medicine.html`

## Directory Structure

```
stitch_designs/
├── README.md (this file)
├── screenshots/
│   ├── 01_splash_page.jpg
│   ├── 02_login_page.jpg
│   ├── 03_dashboard.jpg
│   ├── 04_medication_history.jpg
│   └── 05_add_medicine.jpg
└── code/
    ├── 01_splash_page.html
    ├── 02_login_page.html
    ├── 03_dashboard.html
    ├── 04_medication_history.html
    └── 05_add_medicine.html
```

## Using the Assets

### Viewing Screenshots

Open any `.jpg` file in your image viewer or browser to preview the screen designs.

### Viewing HTML Code

The HTML files contain the exported component code and can be:

1. Opened directly in a web browser to view the rendered design
2. Used as reference when implementing components in Flutter
3. Extracted for component structure and styling information

### Implementing in Flutter

When implementing these designs in Flutter, reference:

- The design system colors and typography defined above
- The component layouts shown in the HTML files
- The responsive spacing guidelines from the design system

## Download Timestamps

- **Downloaded**: 2026-08-13
- **Screenshots**: JPEG format
- **Code Files**: HTML format (Stitch exported)

## Notes

- All files are exported directly from Stitch Design System
- HTML files are web-rendered versions of the designs for reference
- The actual Flutter implementation should follow the design specifications shown in both the images and HTML exports
