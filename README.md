#PulseHub

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white) ![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=Dart&logoColor=white) ![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white) ![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=apple&logoColor=white)

PulseHub is a Flutter mobile app built for a mid-level developer assessment. It demonstrates real-world Flutter skills, including authentication, API-driven dashboards, details view, item creation/updating, dark/light mode, and clean architecture with Riverpod state management.

---
## Role: Mobile App Developer (Flutter – Mid Level)
---

## 🚀 Features

- Login/logout with email & password 🔐
- Persistent authentication using SharedPreferences 💾
- Dashboard with user profile summary (mock) 👤
- Animated list of items fetched from API 📝
- Details screen showing full item info
- Create and update items with input validation ✏️
- Dark/light mode toggle with persistent preference 🌗
- Smooth animations, pull-to-refresh, and responsive UI ✨

---

  ## 🛠️ Tech Stack

- Framework: Flutter
- Language: Dart
- State Management: Riverpod 2.x
- Storage: SharedPreferences
- API: Mock REST-style service
- UI: Material + Custom Widgets
- Platform Support: Android, iOS

---
## Architecture & State Management

* Project structure: lib/
 - models/ – data models for user & items
 - services/ – Riverpod providers for auth, items, theme
 - providers/ – UI screens: login, dashboard, details, create/update
 - screens/ – reusable UI components: loading, error
 - widgets/ – API or auth services

1. UI separated from business logic
2. State management using Riverpod 2.x
3. Async error handling & loading indicators
4. UX Enhancements
5. Dark/light mode toggle saved with SharedPreferences
6. Loading indicators during async operations
7. Responsive text, shadows, and spacing for clarity
8. Smooth list animations

## Dashboard

* User profile summary (mocked name, email, avatar)
* List of items fetched from provider (mock API)
* Each item shows title, description, category/status, and date
* Pull-to-refresh support
* Animated list items using TweenAnimationBuilder
---

## Details Screen

* Full information view of selected item
* Dark/light mode compatible
* Passed item via Navigator.arguments
---

## Create / Update Item

* Form to add or edit items
* Input validation
* Reflects changes immediately on dashboard
* Success/error feedback

  ---
  ## ⚙️ Setup 1. Clone the repository
  1. Clone the repository
```bash
git clone https://github.com/therealvictorad/fitness-forge.git
```
2. Navigate to the project directory
   ```bash
   cd PulseHub
   ```
3. install dependencies
```bash
flutter pub get
```
4. Run the app
```bash
flutter run
```
---
👨‍💻 Author

Victor Adesina – Flutter Developer

📧 victoradesinna77@gmail.com




  
  


  
