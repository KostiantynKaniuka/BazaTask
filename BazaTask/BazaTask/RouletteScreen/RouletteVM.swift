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


    @Published var selectedBet: Int? = nil
    @Published var result: Int? = nil
    @Published var isSpinning: Bool = false
    @Published var rotation: Double = 0

    private let slotAngle: Double = 360.0 / 37.0

    func spin() {
        guard !isSpinning else { return }

        isSpinning = true
        result = nil

        // Random target; you can bias or make it deterministic if needed
        let target = order.randomElement()!
        let index = order.firstIndex(of: target)!

        // We want the center of the target segment to align with the pointer at the top.
        let targetCenterFromTop = (Double(index) * slotAngle) + (slotAngle / 2.0)

        // Add several full spins for flair
        let fullSpins = Double(Int.random(in: 3...6)) * 360.0

        // Rotate NEGATIVE to move clockwise visually (SwiftUI uses screen coords)
        let newRotation = rotation - (fullSpins + targetCenterFromTop)

        withAnimation(.easeOut(duration: 3.2)) {
            rotation = newRotation
        }

        // Mark result after the animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) { [weak self] in
            guard let self = self else { return }
            self.result = target
            self.isSpinning = false
        }
    }

    func isWin() -> Bool? {
        guard let bet = selectedBet, let res = result else { return nil }
        return bet == res
    }
}
