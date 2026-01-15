//
//  DonationButton.swift
//  Animal Handbook For RDR2
//
//  Created by Trevor Bollinger on 12/5/25.
//

import SwiftUI
import StoreKit

struct DonationButton: View {
    @EnvironmentObject var storeKit: StoreKitManager
    @State private var isPurchasing = false

    var body: some View {
        HStack(spacing: 8) {
            // $2 Donation
            if let product = storeKit.products.first(where: { $0.id == "twodonation" }) {
                Button(action: {
                    Task {
                        await purchase(product)
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                        Text("Donate \(product.displayPrice)")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.blue.opacity(0.1))
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
                    .opacity(isPurchasing ? 0.6 : 1.0)
                }
                .disabled(isPurchasing)
                .buttonStyle(.plain)
            }

            // $5 Donation
            if let product = storeKit.products.first(where: { $0.id == "fivedonation" }) {
                Button(action: {
                    Task {
                        await purchase(product)
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                        Text("Donate \(product.displayPrice)")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.blue.opacity(0.1))
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
                    .opacity(isPurchasing ? 0.6 : 1.0)
                }
                .disabled(isPurchasing)
                .buttonStyle(.plain)
            }
        }
        if storeKit.isLoading {
            HStack(spacing: 6) {
                ProgressView()
                Text("Loading...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.gray.opacity(0.1))
            )
        }
    }

    private func purchase(_ product: Product) async {
        isPurchasing = true
        defer { isPurchasing = false }

        do {
            try await storeKit.purchase(product)
        } catch {
            print("Purchase failed: \(error)")
            // You could show an alert here
        }
    }
}

#Preview {
    DonationButton()
        .environmentObject(StoreKitManager())
}

