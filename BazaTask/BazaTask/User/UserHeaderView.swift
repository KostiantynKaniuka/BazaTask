
//
//  UserHeaderView.swift
//  BazaTask
//
//  Created by Assistant on 02.09.2025.
//

import SwiftUI

struct UserHeaderView: View {
    let user: User
    let balance: Int
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                .shadow(radius: 2)
            
            Text(user.name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.red)
                .shadow(color: .black.opacity(0.4), radius: 1, x: 0, y: 1)
            
            Spacer()
            
            HStack(spacing: 8) {
                Text(balance.formatted())
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundStyle(Color.yellow)
                    .shadow(color: .black.opacity(0.4), radius: 1, x: 0, y: 1)
                
                Image(systemName: "dollarsign.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .foregroundStyle(Color.yellow)
                    .shadow(radius: 1)
            }
        }
    }
}

#Preview {
    UserHeaderView(user: User(name: "Tigon", numberOfChips: 138595), balance: 138595)
}

