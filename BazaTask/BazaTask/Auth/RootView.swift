//
//  RootView.swift
//  BazaTask
//
//  Created by Kostiantyn Kaniuka on 02.09.2025.
//

import SwiftUI
import FirebaseAuth

struct RootView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    
    var body: some View {
        if authVM.authenticationState == .authenticating {
            ProgressView("Checking Auth...")
        } else if authVM.authenticationState == .authenticated && authVM.user != nil {
            let rouletteVM = RouletteVM(user: authVM.user!, dataBaseManager: authVM.dataBaseManager)
            let ratingVM = RatingVM(currentUser: authVM.user!, databaseManager: authVM.dataBaseManager)
            TabView {
                RouletteView()
                    .environmentObject(rouletteVM)
                    .tabItem {
                        Image(systemName: "die.face.4")
                        Text("Roulette")
                    }
                RatingView(vm: ratingVM)
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("Top")
                    }
                SettingsView()
                    .environmentObject(authVM)
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
            }
        } else if authVM.authenticationState == .authenticated && authVM.user == nil {
            ProgressView("Loading user data...")
        } else {
            LoginView()
        }
    }
}
