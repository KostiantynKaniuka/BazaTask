//
//  SettingsView.swift
//  BazaTask
//
//  Created by Kostiantyn Kaniuka on 03.09.2025.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    @Environment(\.requestReview) private var requestReview
    @State private var isShowingShare: Bool = false
    
    private let shareURL = URL(string: "https://www.youtube.com/")!
    
    var body: some View {
        VStack{
            Spacer()
                .frame(height: 100)
            VStack(spacing: 16) {
                settingsButton(title: "Rate App", systemImage: "star.fill", color: .yellow) {
                    Task { @MainActor in
                        requestReview()
                    }
                }
                settingsButton(title: "Share App", systemImage: "square.and.arrow.up", color: .cyan) {
                    isShowingShare = true
                }
                settingsButton(title: "Logout", systemImage: "rectangle.portrait.and.arrow.right", color: .orange) {
                    authVM.logOut()
                }
                settingsButton(title: "Delete Account", systemImage: "trash.fill", color: .red) {
                    authVM.deleteAccount { _ in
                        print("account deleted")}
                }
            }
            .padding()
            .sheet(isPresented: $isShowingShare) {
                ActivityView(activityItems: [shareURL])
            }
        }
        .navigationTitle("Settings")
    }
    
    private func settingsButton(title: String, systemImage: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(title.uppercased())
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundStyle(.black)
                    .padding(.vertical, 14)
                Spacer()
            }
            .background(RoundedRectangle(cornerRadius: 18).fill(color.opacity(0.85)))
            .overlay(
                RoundedRectangle(cornerRadius: 18).stroke(Color.black.opacity(0.2), lineWidth: 1)
            )
            .shadow(radius: 1)
        }
    }
}

// UIKit share sheet bridge
private struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    SettingsView().environmentObject(AuthenticationViewModel(databaseManager: FireBaseApiManager()))
}
