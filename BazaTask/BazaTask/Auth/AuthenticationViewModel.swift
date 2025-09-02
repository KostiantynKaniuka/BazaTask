//
//  AuthenticationViewModel.swift
//  BazaTask
//
//  Created by Kostiantyn Kaniuka on 02.09.2025.
//

import Foundation
import FirebaseCore
import FirebaseAuth

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    var dataBaseManager: FireProtocol
    
    @Published var authenticationState: AuthenticationState = .unauthenticated
    //@Published var user: User?
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    init(databaseManager: FireProtocol) {
        self.dataBaseManager = databaseManager
        registerAuthStateHandler()
    }
    
    private func registerAuthStateHandler() {
        if authStateHandle == nil {
            authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
                if user != nil {
                    self?.authenticationState = .authenticated
                } else {
                    self?.authenticationState = .unauthenticated
                }
            }
        }
    }
    
    func logIn() async {
        do {
            let result = try await Auth.auth().signInAnonymously()
            let user  = result.user
            dataBaseManager.checkUserIndb(user.uid) { [weak self] exist in
                guard let self = self else {return}
                if exist {
                    print("Hello \(user)")
                    self.authenticationState = .authenticated
                } else {
                    self.dataBaseManager.addUserToFirebase(user: User(userId: user.uid, name: "Player", numberOfChips: 2000, winRate: 0.0))
                    self.authenticationState = .authenticated
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func checkAuthState() {
        if Auth.auth().currentUser != nil {
            authenticationState = .authenticated
        } else {
            authenticationState = .unauthenticated
        }
    }
}
