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
            ContentView()
                .environmentObject(RouletteVM(user: authVM.user!, dataBaseManager: authVM.dataBaseManager))
        } else if authVM.authenticationState == .authenticated && authVM.user == nil {
            ProgressView("Loading user data...")
        } else {
            LoginView()
        }
    }
}
