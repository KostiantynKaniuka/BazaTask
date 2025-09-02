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
        } else if authVM.authenticationState == .authenticated {
            ContentView()
                .environmentObject(RouletteVM(user: authVM.user ?? User(userId: "", name: "player", numberOfChips: 1000, winRate: 100.0), dataBaseManager: authVM.dataBaseManager))
        } else {
            LoginView()
        }
    }
}
