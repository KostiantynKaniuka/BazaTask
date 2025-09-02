//
//  UserModel.swift
//  BazaTask
//
//  Created by Kostiantyn Kaniuka on 02.09.2025.
//

import Foundation

struct User {
    let userId: String?
    let name: String
    let numberOfChips: Int
    let winRate: Double
    
    //formating for firebase 
    func toDictionary() -> [String: Any] {
        if let id = userId {
            return [
                "id": id,
                "name": name,
                "numberOfChips": numberOfChips,
                "winRate": winRate
            ]
        }
        return ["empty": "empty"]
       }
   }
