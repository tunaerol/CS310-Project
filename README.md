# Build Your Focus 🏗️

**Build Your Focus** is a gamified focusing app designed to help users stay concentrated and motivated while studying. The core motivation is to transform "focus time" into tangible visual progress. By committing to focus sessions, users to build historical and modern landmarks (such as Anıtkabir or Great Pyramid) stage by stage.

### Key Features
* Focus timers (15-120 min) to track study sessions
* Weekly progress tracking and virtual growth structure
* A collection page to view user's completed buildings
* Simple and clean user interface built with Flutter

## 👥 Team Members
* Duru İlhan (34083)  
* İpek İnal (33788)  
* Mert Can Kılıç (32140)  
* Tuna Erol (32008)

---

## ⚙️ Step-by-Step Setup and Run Instructions

### 1. Setting Up
* **Flutter Version**: Ensure you are using Flutter `3.x` on the `stable` channel.
* **Dart SDK**: Included with the Flutter installation.
* **IDE**: Android Studio or VS Code with Flutter and Dart plugins.
* **Firebase Configuration**: Download google-services.json from Firebase Console and place it in android/app/.

### 2. Project Installation
* **Clone the repository**:
   ```bash
   git clone [https://github.com/tunaerol/CS310-Project.git](https://github.com/tunaerol/CS310-Project.git)
* run the command: flutter run and select the desired device/web

---

## ✅ Running Tests

### 1. Unit Test
* **File**: test/todotask_model_test.dart
* **Test Case**: Validates that Firestore Timestamp data is correctly converted to Flutter DateTime objects within the ToDoTaskModel.
* **Running Specific Test**: flutter test test/todotask_model_test.dart

### 2. Widget Test
* **File**: test/opening_page_test.dart
* **Test Case**: Verifies that the FirstOpening renders the PageView and AnimatedSwitcher correctly, ensuring a functional onboarding flow.
* **Running Specific Test**: flutter test test/opening_page_test.dart

---

## 🔐 Known Limitations

### SHA-1 Fingerprint for Firebase Authentication
* **Issue**: Some Firebase Authentication features (Google Sign-In, Password Reset links) are tied to the SHA-1 fingerprint of the development machine's debug keystore. When running the app on a different computer, these features may not work because Firebase doesn't recognize the new machine's SHA-1 key.
* **Affected Features**: Forgot Password (email reset links) & Google Sign-In
* **Solution**: Add the new machine's SHA-1 fingerprint to Firebase Console.
  - Step 1: Get SHA-1 from the new machine by running:
    Mac/Linux: keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
    Windows: keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android

  - Step 2: Add the SHA-1 to Firebase:
    Go to Firebase Console → Project Settings
    Select the Android app
    Click "Add fingerprint"
    Paste the SHA-1 key
    Download the updated google-services.json and replace it in the project

**Note**: This is a standard Firebase security feature, not a bug. Each development machine needs its SHA-1 registered for full authentication functionality.

---

© 2025 Sabancı University – CS310 Mobile Application Development Project
