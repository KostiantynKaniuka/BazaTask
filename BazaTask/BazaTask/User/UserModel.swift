//
//  UserModel.swift
//  BazaTask
//
//  Created by Kostiantyn Kaniuka on 02.09.2025.
//

import Foundation

struct User {
    let name: String
    private(set) var numberOfChips: Int
    
    mutating func addChips(_ count: Int) {
        numberOfChips += count
    }
    
    mutating func betChips(_ count: Int) {
        guard numberOfChips >= 0 && numberOfChips >= count else {return}
        numberOfChips -= count
    }
}
