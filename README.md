## BazaTask

A SwiftUI iOS app powered by Firebase for anonymous authentication and a simple roulette game with a global rating leaderboard.

### Features
- **Anonymous sign-in** using Firebase Auth
- **Roulette game** with chips balance updates
- **Leaderboard** (ratings) backed by Firebase Realtime Database
- **Settings**: log out and delete account

### Project Structure (high-level)
- `BazaTaskApp.swift`: App entry; configures Firebase and injects dependencies
- `Auth/AuthenticationViewModel.swift`: Auth state and user session
- `Auth/RootView.swift`: Routes between Login, Tabs, and loading states
- `Firebase/FireBaseApiManager.swift`: Realtime Database API
- `RouletteScreen/…`: Roulette UI and logic
- `RatingScreen/…`: Leaderboard UI and VM
- `SettingsScreen/SettingsView.swift`: Logout and account deletion
- `User/…`: User model and header view

### Using the App
- On first launch, the app signs you in **anonymously**. You will see a loading indicator while auth and user data initialize.
- You land on a **TabView** with:
  - **Roulette**: play the game, your chips update and are saved.
  - **Top**: view the leaderboard from Firebase.
  - **Settings**: log out or delete the account (deletes auth user and DB entry).

<p>
  <img src="docs/screenshots/roulette.png" alt="Roulette screen" width="260"/>
  <img src="docs/screenshots/top.png" alt="Top leaderboard" width="260"/>
  <img src="docs/screenshots/settings.png" alt="Settings screen" width="260"/>
  
</p>

### Tech Notes
- Dependencies via **Swift Package Manager** (configured in the Xcode workspace).
- Firebase is configured in `AppDelegate` within `BazaTaskApp.swift` using `FirebaseApp.configure()`.
- Auth flow and routing are handled by `AuthenticationViewModel` and `RootView`.
