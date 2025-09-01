//
//  BannerView.swift
//  BazaTask
//
//  Created by Kostiantyn Kaniuka on 01.09.2025.
//

import SwiftUI

struct BannerView: View {
    let text: String
    let isWin: Bool

    var body: some View {
        Text(text)
            .font(.headline)
            .padding(.horizontal, 16).padding(.vertical, 10)
            .background(
                Capsule().fill((isWin ? Color.green : Color.red).opacity(0.9))
            )
            .foregroundStyle(.white)
            .shadow(radius: 6)
    }
}
