# Excuse Generator 🎉

**Excuse Generator – Random Excuse App**  
_Flutter · AdMob_  
A hilarious Flutter app that crafts absurd excuses to dodge any obligation with a smirk! Pick from categories like Work, Friends, Parents, School, or Dating, and enjoy a sleek Material 3 UI with neumorphic buttons, glassmorphic excuse displays, and confetti bursts. Share your favorite excuses, track recent ones, and monetize with AdMob banner ads. Perfect for a quick laugh or a creative escape! (MVP completed)  
_GitHub:_ [github.com/deepdarji/Excuse-Generator](https://github.com/deepdarji/Excuse-Generator)

---

## ✨ Features

- 🎨 **Modern UI**: Material 3 design with neumorphism, glassmorphism, and gradient backgrounds for a premium look.
- 🏷️ **Categories**: Choose from Work, Friends, Parents, School, or Dating via scrollable ChoiceChips (no more cramped labels!).
- 😂 **Random Excuses**: Generate ridiculous excuses with confetti effects and smooth micro-animations.
- 📤 **Share Excuses**: Share your favorite excuses via the system share sheet.
- 📜 **History Tracking**: View and clear recent excuses in a stylish list.
- 📱 **Responsive Design**: Adapts to any screen size with system-based dark/light theme support.
- 💸 **AdMob Integration**: Banner ads at the bottom (test ID included, swap with your own for production).

## 📸 Screenshots

| Home Screen                     | Excuse Generated                |
| ------------------------------- | ------------------------------- |
| ![Screenshot 1](assets/ss1.png) | ![Screenshot 2](assets/ss2.png) |

## 🚀 Setup

1. **Clone the Repo**

   ```bash
   git clone https://github.com/deepdarji/Excuse-Generator.git
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Add App Icon**

   - Place a 1024x1024 `icon.png` in `assets/`.
   - Generate icons:
     ```bash
     flutter pub run flutter_launcher_icons:main
     ```

4. **Configure AdMob**

   - Get your AdMob App ID from [AdMob Console](https://apps.admob.com/).
   - Replace the test ad unit ID (`ca-app-pub-3940256099942544/6300978111`) in `lib/screens/home_screen.dart` with your own.
   - Update platform-specific files:
     - **Android**: Add to `android/app/src/main/AndroidManifest.xml`:
       ```xml
       <uses-permission android:name="android.permission.INTERNET"/>
       <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
       <application>
           <meta-data
               android:name="com.google.android.gms.ads.APPLICATION_ID"
               android:value="YOUR_ADMOB_APP_ID"/>
       </application>
       ```
     - **iOS**: Add to `ios/Runner/Info.plist`:
       ```xml
       <key>GADApplicationIdentifier</key>
       <string>YOUR_ADMOB_APP_ID</string>
       ```

5. **Build the App**
   - Android: `flutter build apk --release`
   - iOS: `flutter build ios --release` (requires Mac and Xcode)

## 📖 About

Excuse Generator is a fun, lightweight Flutter app that delivers absurd excuses at the tap of a button. With five categories (Work, Friends, Parents, School, Dating) packed with humorous excuses, it’s perfect for a quick laugh or a playful way to skip responsibilities. The app features a modern UI with animations, sharing, history tracking, and AdMob monetization, making it both engaging and practical.

## 📦 Packages

- `provider: ^6.0.0` – State management
- `share_plus: ^7.0.0` – Sharing excuses
- `flutter_launcher_icons: ^0.13.0` – App icon generation
- `google_mobile_ads: ^6.0.0` – Banner ads
- `google_fonts: ^6.3.0` – Stylish typography
- `flutter_animate: ^4.5.0` – Smooth animations
- `confetti: ^0.7.0` – Confetti effects
