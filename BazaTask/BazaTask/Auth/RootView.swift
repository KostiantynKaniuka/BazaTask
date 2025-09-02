//
//  RootView.swift
//  BazaTask
//
//  Created by Kostiantyn Kaniuka on 02.09.2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    
    var body: some View {
            if authVM.authenticationState == .authenticating {
               // ProgressView("Checking Auth...")
            } else if authVM.authenticationState == .unauthenticated {
                ContentView()
                    .environmentObject(RouletteVM(user: User(userId: "test", name: "test", numberOfChips: 2000, winRate: 0.0)))
            } else {
                LoginView()
            }
    }
}
