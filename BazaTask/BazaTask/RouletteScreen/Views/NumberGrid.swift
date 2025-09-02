//
//  NumberGrid.swift
//  BazaTask
//
//  Created by Kostiantyn Kaniuka on 01.09.2025.
//

import SwiftUI

struct NumberGrid: View {
    let order: [Int]
    let selected: Int?
    var onTap: (Int) -> Void
    
    // A simple 3-column grid “like” the table (12 rows + zero)
    private var gridNumbers: [Int] {
        // Arrange as 0 + rows of 3 (1-36) just for tapping convenience
        [0] + Array(1...36)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Place your bet: tap a number")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                ForEach(gridNumbers, id: \.self) { n in
                    Button(action: { onTap(n) }) {
                        Text("\(n)")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selected == n ? Color.accentColor.opacity(0.25) : Color.gray.opacity(0.12))
                            )
                    }
                }
            }
        }
    }
}
