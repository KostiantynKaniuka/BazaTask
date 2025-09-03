//
//  RatingRowView.swift
//  BazaTask
//
//  Created by Kostiantyn Kaniuka on 03.09.2025.
//

import SwiftUI

struct RatingRowView: View {
    let index: Int?
    let user: User
    
    var isCurrentUser: Bool { index == nil }
    
    var body: some View {
        HStack(spacing: 12) {
            if let idx = index {
                Text(String(idx))
                    .font(.title3).fontWeight(.bold)
                    .foregroundStyle(Color.cyan)
                    .frame(width: 28)
            } else {
                Spacer().frame(width: 28)
            }
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 44, height: 44)
                .foregroundStyle(.secondary)
                .overlay(Circle().stroke(isCurrentUser ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2))
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.headline)
                    .foregroundStyle(Color.red)
                HStack(spacing: 12) {
                    Text("Best \(user.numberOfChips)$")
                        .foregroundStyle(Color.cyan)
                    Text(String(format: "%.2fx", user.winRate))
                        .foregroundStyle(Color.cyan)
                }
                .font(.subheadline)
            }
            Spacer()
            HStack(spacing: 8) {
                Text(user.numberOfChips.formatted())
                    .font(.title3).bold()
                    .foregroundStyle(Color.yellow)
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundStyle(Color.yellow)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isCurrentUser ? Color.cyan : Color.gray.opacity(0.3), lineWidth: isCurrentUser ? 2 : 1)
        )
    }
}

#Preview {
    VStack(spacing: 12) {
        RatingRowView(index: nil, user: User(userId: "1", name: "Me", numberOfChips: 138595, winRate: 16.15))
        RatingRowView(index: 2, user: User(userId: "2", name: "Other", numberOfChips: 723539, winRate: 8.7))
    }
    .padding()
}


