//
//  ResultBadge.swift
//  BazaTask
//
//  Created by Kostiantyn Kaniuka on 01.09.2025.
//

import SwiftUI

struct ResultBadge: View {
    let result: Int
    let win: Bool?

    var body: some View {
        HStack(spacing: 8) {
            Circle().fill((result == 0) ? .green : (isRed(result) ? .red : .black))
                .frame(width: 14, height: 14)
            Text("Result: \(result)")
                .font(.subheadline).fontWeight(.semibold)
            if let win = win {
                Text(win ? "WIN" : "LOSE").font(.subheadline)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(RoundedRectangle(cornerRadius: 8).fill((win ? Color.green : Color.red).opacity(0.18)))
            }
        }
    }

    private func isRed(_ n: Int) -> Bool {
        let reds: Set<Int> = [32,19,21,25,34,27,36,30,23,5,16,1,14,9,18,7,12,3]
        return reds.contains(n)
    }
}
