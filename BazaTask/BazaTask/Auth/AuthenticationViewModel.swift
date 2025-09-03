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
final class AuthenticationViewModel: ObservableObject {
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    var dataBaseManager: FireProtocol
    var user: User?
    
    @Published var authenticationState: AuthenticationState = .authenticating // controlling navigation at RootView
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    init(databaseManager: FireProtocol) {
        self.dataBaseManager = databaseManager
        registerAuthStateHandler()
    }
    
    func logIn() async {
        do {
            let result = try await Auth.auth().signInAnonymously()
            let user = result.user
            
            dataBaseManager.checkUserIndb(user.uid) { [weak self] exist in
                guard let self = self else { return }
                
                if exist {
                    dataBaseManager.getUserFromDB(user.uid) { player in
                        if let player = player {
                            self.user = User(
                                userId: player.userId,
                                name: player.name,
                                numberOfChips: player.numberOfChips,
                                winRate: player.winRate
                            )
                            self.authenticationState = .authenticated
                        }
                    }
                    
                    print("Hello \(user)")
                    
                } else {
                    let newUser = User(
                        userId: user.uid,
                        name: "Player",
                        numberOfChips: 2000,
                        winRate: 0.0
                    )
                    self.dataBaseManager.addUserToFirebase(user: newUser) {
                        self.user = newUser
                        self.authenticationState = .authenticated
                    }
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            user = nil
            authenticationState = .unauthenticated
        } catch {
            print("Sign out error: \(error.localizedDescription)")
        }
    }
    
    func deleteAccount(completion: @escaping (Bool) -> Void) {
        guard let firebaseUser = Auth.auth().currentUser, let id = firebaseUser.uid as String? else {
            completion(false)
            return
        }
        dataBaseManager.deleteUser(id) { [weak self] success in
            guard success else { completion(false); return }
            firebaseUser.delete { error in
                if let error = error {
                    print("Delete auth user error: \(error.localizedDescription)")
                    completion(false)
                } else {
                    DispatchQueue.main.async {
                        self?.user = nil
                        self?.authenticationState = .unauthenticated
                    }
                    completion(true)
                }
            }
        }
    }
}

private extension AuthenticationViewModel {
    
    private func registerAuthStateHandler() {
        if authStateHandle == nil {
            authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
                if user != nil {
                    self?.dataBaseManager.getUserFromDB(user!.uid) { player in
                        if let player = player {
                            self?.user = User(
                                userId: player.userId,
                                name: player.name,
                                numberOfChips: player.numberOfChips,
                                winRate: player.winRate
                            )
                            self?.authenticationState = .authenticated
                        }
                    }
                } else {
                    self?.authenticationState = .unauthenticated
                }
            }
        }
    }
    
    private func checkAuthState() {
        if Auth.auth().currentUser != nil {
            authenticationState = .authenticating
        } else {
            authenticationState = .unauthenticated
        }
    }
}
