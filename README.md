# 📚 BookSwap App: Student Textbook Exchange Marketplace

This is a complete mobile application built using **Flutter** for the frontend UI/UX and **Firebase** for the backend (Authentication, Firestore Database, and Storage).

The application allows university students to list textbooks they want to swap and initiate real-time exchange offers.

---

## ✨ Features Implemented

* **User Authentication:** Full sign-up, login, and logout using Firebase Auth (Email/Password). **Email verification is enforced.**
* **CRUD Operations:** Users can Post, View (Feed/My Listings), Edit, and Delete their book listings.
* **Real-Time State:** Book listings are streamed using **Riverpod** to update instantly upon posting or deletion.
* **Swap Functionality:** Users can request a swap, which sets the book's status to **'pending'** and records the `requesterId` in Firestore.
* **Chat (Bonus):** Basic real-time, two-user messaging is implemented via a separate Firestore collection.
* **Clean Architecture:** Code is separated into `presentation`, `application`, and `data` layers.

---

## 🛠️ Project Architecture

### Technologies Used

* **Framework:** Flutter (Web/Mobile)
* **State Management:** Riverpod (`Provider`, `StateProvider`, `StreamProvider`, `StateNotifierProvider`)
* **Backend:** Firebase
    * **Auth:** Firebase Authentication (Email/Password)
    * **Database:** Firestore (Real-time data synchronization)
    * **Storage:** Firebase Storage (Set up, though image upload utilized a workaround due to plan constraints).

### Folder Structure (Clean Architecture)

The project adheres to a clean, feature-driven structure:

lib/ ├── features/ │ ├── auth/ # Authentication logic and UI │ ├── books/ # Book Model, Repository, and CRUD logic │ │ ├── application/ │ │ ├── data/ │ │ └── presentation/ │ ├── chat/ # Chat Model and Detail Screen │ └── ... # Other screens (MyListings, Settings) ├── presentation/ # Shared widgets and main navigation logic └── main.dart

## ⚙️ Build and Setup Steps

1.  **Clone the Repository:**
    ```bash
    git clone [YOUR REPOSITORY URL HERE]
    ```
2.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Firebase Configuration:**
    * Create a Firebase project named `BookSwapApp`.
    * Enable **Email/Password** under Firebase Authentication.
    * Initialize **Firestore Database** in Test Mode.
    * **CRITICAL STEP:** Paste the API keys into `lib/main.dart` (as the `firebaseOptions` constant).
    * **Security Rules:** The following rules must be published in Firestore to enable read access for authenticated users:
        ```javascript
        rules_version = '2';
        service cloud.firestore {
          match /databases/{database}/documents {
            match /{document=**} {
              allow read, write: if request.auth != null;
            }
          }
        }
        ```

4.  **Run the App:**
    ```bash
    flutter run -d web-server
    ```

    Dart Analyzer Report
<img width="1440" height="900" alt="Screenshot 2025-11-11 at 13 40 57" src="https://github.com/user-attachments/assets/135110db-61c0-4418-999f-b1afa4d1cbb5" />

