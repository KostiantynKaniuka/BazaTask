//
//  RatingView.swift
//  BazaTask
//
//  Created by Kostiantyn Kaniuka on 03.09.2025.
//

import SwiftUI

struct RatingView: View {
    @ObservedObject var vm: RatingVM
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                RatingRowView(index: nil, user: vm.players.first ?? vmCurrentPlaceholder)
                Divider().padding(.vertical, 4)
                ForEach(Array(vm.players.dropFirst().enumerated()), id: \.offset) { idx, user in
                    RatingRowView(index: idx + 1, user: user)
                }
            }
            .padding()
        }
        .overlay {
            if vm.isLoading {
                ProgressView()
            }
        }
        .navigationTitle("Top")
    }
}

private let vmCurrentPlaceholder = User(userId: nil, name: "Me", numberOfChips: 0, winRate: 0)

#Preview {
    RatingView(vm: RatingVM(currentUser: User(userId: "1", name: "Me", numberOfChips: 138595, winRate: 16.15), databaseManager: FireBaseApiManager()))
}
