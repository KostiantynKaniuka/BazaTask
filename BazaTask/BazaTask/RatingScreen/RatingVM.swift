//
//  RatingVM.swift
//  BazaTask
//
//  Created by Kostiantyn Kaniuka on 03.09.2025.
//

import Foundation

final class RatingVM: ObservableObject {
    @Published var players: [User] = []
    @Published var isLoading: Bool = false
    
    private let currentUser: User
    private let databaseManager: FireProtocol
    
    init(currentUser: User, databaseManager: FireProtocol) {
        self.currentUser = currentUser
        self.databaseManager = databaseManager
        fetchRatings()
    }
    
    func fetchRatings() {
        isLoading = true
        databaseManager.getAllUsers { [weak self] users in
            guard let self = self else { return }
            // Resolve current user from latest snapshot to reflect real-time updates
            let liveCurrent = users.first { $0.userId == self.currentUser.userId } ?? self.currentUser
            let others = users.filter { $0.userId != liveCurrent.userId }
                .sorted { lhs, rhs in
                    if lhs.numberOfChips == rhs.numberOfChips {
                        return lhs.winRate > rhs.winRate
                    }
                    return lhs.numberOfChips > rhs.numberOfChips
                }
            self.players = [liveCurrent] + others
            self.isLoading = false
        }
    }
}
