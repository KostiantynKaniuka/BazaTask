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
<img width="200" height="450" alt="simulator_screenshot_45E633F0-BD38-4E03-A41F-3AC67412941A" src="https://github.com/user-attachments/assets/19890611-93e9-41db-864f-8f77e9145e03" />
<img width="200" height="450" alt="simulator_screenshot_12388B94-B625-4070-8F0E-7918ADCC887A" src="https://github.com/user-attachments/assets/6707a51e-775e-4816-b38e-270b2f143e0e" />
<img width="200" height="450" alt="simulator_screenshot_B937AEC6-9D42-43EE-8742-7579167916D1" src="https://github.com/user-attachments/assets/70052117-b5a3-4cd1-9429-32a3875b71cd" />

</p>

### Tech Notes
- Dependencies via **Swift Package Manager** (configured in the Xcode workspace).
- Firebase is configured in `AppDelegate` within `BazaTaskApp.swift` using `FirebaseApp.configure()`.
- Auth flow and routing are handled by `AuthenticationViewModel` and `RootView`.
