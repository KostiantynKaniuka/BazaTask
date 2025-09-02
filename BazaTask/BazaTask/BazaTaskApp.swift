//
//  BazaTaskApp.swift
//  BazaTask
//
//  Created by Kostiantyn Kaniuka on 01.09.2025.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct BazaTaskApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
          RootView()
                .environmentObject(AuthenticationViewModel(databaseManager: FireBaseApiManager()))
         //   ContentView()
             //   .environmentObject(RouletteVM(user: User(userId: nil, name: "test", numberOfChips: 52555, winRate: 100)))
        }
    }
}
