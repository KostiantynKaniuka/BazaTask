//
//  ContentView.swift
//  BazaTask
//
//  Created by Kostiantyn Kaniuka on 01.09.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var vm: RouletteVM
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 16) {
                    Text("European Roulette")
                        .font(.title2).fontWeight(.semibold)
                    Text("\(vm.user.name)  \(vm.user.numberOfChips)")
                }
            }
                
                VStack {
                    
                    TrianglePointer()
                        .fill(Color.yellow)
                        .overlay(
                            TrianglePointer()
                                .stroke(Color.white, lineWidth: 1.5)
                        )
                        .frame(width: 20, height: 20)
                        .shadow(radius: 3)
                    
                    RouletteWheel(pockets: vm.pockets, rotation: vm.rotation)
                        .frame(width: 300, height: 300)
                }
                .padding(.top, 12)
                
                HStack(spacing: 12) {
                    
                    Button(action: {
                        vm.spin()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: vm.isSpinning ? "arrow.triangle.2.circlepath" : (vm.selectedBet == nil ? "hand.tap" : "play.circle.fill"))
                            Text(vm.isSpinning ? "Spinning…" : (vm.selectedBet == nil ? "Select a number first" : "Spin"))
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 18).padding(.vertical, 12)
                        .background(RoundedRectangle(cornerRadius: 16).fill(
                            vm.selectedBet == nil ? Color.gray.opacity(0.1) : Color.accentColor.opacity(0.15)
                        ))
                    }
                    .disabled(vm.isSpinning || vm.selectedBet == nil)
                    
                    if let res = vm.result {
                        ResultBadge(result: res, win: vm.isWin())
                    } else {
                        Text(vm.selectedBet != nil ? "Bet on: \(vm.selectedBet!)" : "Tap a number below to bet")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, 4)
                
                Divider().padding(.vertical, 4)
                
                NumberGrid(order: vm.order, selected: vm.selectedBet) { tapped in
                    vm.selectedBet = tapped
                    print("bet on \(tapped)")
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }


#Preview {
    ContentView()
        .environmentObject(RouletteVM(user: User(name: "Joseph", numberOfChips: 1000)))
}
