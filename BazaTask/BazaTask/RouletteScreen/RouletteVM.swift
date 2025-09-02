//
//  RouletteVM.swift
//  BazaTask
//
//  Created by Kostiantyn Kaniuka on 01.09.2025.
//

import SwiftUI


final class RouletteVM: ObservableObject {
    
    let order: [Int] = [
        0, 32, 15, 19, 4, 21, 2, 25, 17, 34, 6, 27, 13, 36, 11, 30, 8, 23,
        10, 5, 24, 16, 33, 1, 20, 14, 31, 9, 22, 18, 29, 7, 28, 12, 35, 3, 26
    ]
    
    var pockets: [Pocket] {
        order.map { n in
            if n == 0 { return Pocket(number: n, color: .green) }
            // Standard red/black mapping for European wheel
            let reds: Set<Int> = [32,19,21,25,34,27,36,30,23,5,16,1,14,9,18,7,12,3]
            return Pocket(number: n, color: reds.contains(n) ? .red : .black)
        }
    }
    
    var user: User
    
    private var spinningAmount: Int = 0
    private let slotAngle: Double = 360.0 / 37.0
    
    @Published var selectedBet: Int? = nil
    @Published var result: Int? = nil
    @Published var isSpinning: Bool = false
    @Published var rotation: Double = 0
    @Published var userBalance:Int
    
    // Betting flow state
    @Published var isShowingBetOptions: Bool = false
    @Published var isShowingInsufficientAlert: Bool = false
    @Published var pendingNumberSelection: Int? = nil
    @Published var selectedFraction: Int = 1
    
    init(user: User) {
        self.user = user
        self.userBalance = user.numberOfChips
    }

    func spin() {
        guard !isSpinning, selectedBet != nil else { return }
        
        isSpinning = true
        result = nil
        
        let randomSpins = Double(Int.random(in: 3...6)) * 360.0
        let randomOffset = Double.random(in: 0...360)
        let newRotation = rotation - (randomSpins + randomOffset)
        
        withAnimation(.easeOut(duration: 3.2)) {
            rotation = newRotation
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) { [weak self] in
            guard let self = self else { return }
            let normalizedRotation = abs(newRotation.truncatingRemainder(dividingBy: 360))
            let segmentIndex = Int((normalizedRotation / self.slotAngle).rounded())
            let actualIndex = segmentIndex % 37
            
            self.result = self.order[actualIndex]
            self.isSpinning = false
            
            // Handle payout
            if let betNumber = self.selectedBet, let res = self.result, betNumber == res {
                self.addChips(self.spinningAmount * 2)
            }
            self.spinningAmount = 0
            if userBalance == 0 {
                userBalance += 100
            }
        }
    }
    
    func isWin() -> Bool? {
        guard let bet = selectedBet, let res = result else { return nil }
        return bet == res
    }
 
    // MARK: - Betting Flow
    func beginBet(on number: Int) {
        pendingNumberSelection = number
        selectedFraction = 1
        isShowingBetOptions = true
    }
    
    func cancelBetSelection() {
        isShowingBetOptions = false
        pendingNumberSelection = nil
    }
    
    func confirmBetSelection(fraction: Int) {
        guard let number = pendingNumberSelection else { return }
        let amountToBet = amount(for: fraction)
        spinningAmount = amountToBet
        guard userBalance >= amountToBet else {
            isShowingBetOptions = false
            isShowingInsufficientAlert = true
            pendingNumberSelection = nil
            return
        }
        selectedBet = number
        betChips(amountToBet)
        isShowingBetOptions = false
        pendingNumberSelection = nil
    }
}

private extension RouletteVM {
    
    func addChips(_ count: Int) {
        userBalance += count
    }
    
    func amount(for fraction: Int, balance: Int? = nil) -> Int {
        let balanceToUse = balance ?? userBalance
        let computed = (balanceToUse * fraction) / 10
        return max(1, computed)
    }
    
    func betChips(_ count: Int) {
        guard userBalance >= count else {
            // Not enough funds for chosen fraction
            isShowingInsufficientAlert = true
            pendingNumberSelection = nil
            return
        }
        guard userBalance >= 0 && userBalance >= count else {return}
        userBalance -= count
    }
}
