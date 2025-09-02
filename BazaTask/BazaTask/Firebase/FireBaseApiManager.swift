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
    func addUserToFirebase(user: User)
    func getUserFromDB(_ id: String, completion: @escaping (User?) -> Void)
    func checkUserIndb(_ id: String, completion: @escaping (Bool) -> Void)
}

final class FireBaseApiManager: FireProtocol {
    
    private func configureFB() -> DatabaseReference {
           let db = Database.database().reference()
           
           return db
       }
    
    //MARK: - Adding user to db
       func addUserToFirebase(user: User) {
           let db = configureFB()
           let usersRef = db.child("users")
           let userRef = usersRef.child("\(user.userId ?? "")")
           userRef.setValue(user.toDictionary())
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
