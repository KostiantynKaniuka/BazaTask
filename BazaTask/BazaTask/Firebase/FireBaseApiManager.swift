//
//  FireBaseApiManager.swift
//  BazaTask
//
//  Created by Kostiantyn Kaniuka on 02.09.2025.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

protocol FireProtocol {
    func addUserToFirebase(user: User, completion: @escaping () -> Void)
    func getUserFromDB(_ id: String, completion: @escaping (User?) -> Void)
    func checkUserIndb(_ id: String, completion: @escaping (Bool) -> Void)
    func updateUserChips(_ userId: String, _ chips: Int)
    func getAllUsers(completion: @escaping ([User]) -> Void)
    func deleteUser(_ userId: String, completion: @escaping (Bool) -> Void)
}

final class FireBaseApiManager: FireProtocol {
    
    private func configureFB() -> DatabaseReference {
        let db = Database.database().reference()
        
        return db
    }
    
    //MARK: - Adding user to db
    func addUserToFirebase(user: User, completion: @escaping () -> Void) {
        let db = configureFB()
        let usersRef = db.child("users")
        let userRef = usersRef.child("\(user.userId ?? "")")
        userRef.setValue(user.toDictionary()) { error, _ in
            if let error = error {
                print("Error adding user to Firebase: \(error.localizedDescription)")
            }
            completion()
        }
    }
    
    func updateUserChips(_ userId: String, _ chips: Int) {
        let db = configureFB()
        db.child("users").child(userId).child("numberOfChips").setValue(chips)
    }
    
    func getUserFromDB(_ id: String, completion: @escaping (User?) -> Void) {
        let db = configureFB()
        
        db.child("users").child(id).getData(completion: { error, user in
            guard error == nil else {
                print(error?.localizedDescription ?? "❌ oops no user")
                completion(nil)
                return
            }
            var userData: User?
            
            if let dataDict = user?.value as? [String: Any] {
                let id = dataDict["id"] as? String ?? ""
                let name = dataDict["name"] as? String ?? ""
                let numberOfChips = dataDict["numberOfChips"] as? Int ?? 0
                let winRate = dataDict["winRate"] as? Double ?? 0.0
                userData = User(userId: id, name: name, numberOfChips: numberOfChips, winRate: winRate)
            }
            completion(userData)
        })
    }
    
    //MARK: - Get all users for ratings
    func getAllUsers(completion: @escaping ([User]) -> Void) {
        let db = configureFB()
        db.child("users").observe(.value) { snapshot in
            var result: [User] = []
            for case let child as DataSnapshot in snapshot.children {
                if let dataDict = child.value as? [String: Any] {
                    let id = dataDict["id"] as? String ?? ""
                    let name = dataDict["name"] as? String ?? ""
                    let numberOfChips = dataDict["numberOfChips"] as? Int ?? 0
                    let winRate = dataDict["winRate"] as? Double ?? 0.0
                    let user = User(userId: id, name: name, numberOfChips: numberOfChips, winRate: winRate)
                    result.append(user)
                }
            }
            completion(result)
        }
    }
    
    //MARK: - Delete user from Realtime DB
    func deleteUser(_ userId: String, completion: @escaping (Bool) -> Void) {
        let db = configureFB()
        db.child("users").child(userId).removeValue { error, _ in
            if let error = error {
                print("Error deleting user: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func checkUserIndb(_ id: String, completion: @escaping (Bool) -> Void) {
        let db = configureFB()
        db.child("users").child(id).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                print("👨‍💼 User exists")
                completion(true)
            } else {
                print("🚫 User does not exist")
                completion(false)
            }
        }
    }
}
