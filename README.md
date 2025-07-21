# Day Log Flutter

A simple Flutter project demonstrating Firebase authentication with Google and email/password sign-in. User data is stored in Firestore under `/users/{uid}`.

## Firebase setup
1. Create a Firebase project and add Android/iOS apps.
2. Download the platform configuration files and place them in the respective directories (`android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist`).
3. Enable **Google** and **Email/Password** sign-in methods in the Firebase console.
4. Run `flutter pub get` to install dependencies.
5. Launch the app with `flutter run`.
