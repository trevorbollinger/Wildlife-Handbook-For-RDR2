//
//  StoreKitManager.swift
//  Animal Handbook For RDR2
//
//  Created by Trevor Bollinger on 12/5/25.
//

import StoreKit
import SwiftUI

@MainActor
class StoreKitManager: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var isLoading = false
    @Published var showThankYou = false

    private var productIDs = ["fivedonation", "twodonation"]

    // Transaction listener task - must be started before any purchases
    private var transactionTask: Task<Void, Never>?

    init() {
        // All stored properties are now initialized
        // Start listening for transaction updates immediately (required for StoreKit compliance)
        startTransactionListener()
        
        // Load products
        loadProductsOnInit()
    }
    
    private func startTransactionListener() {
        transactionTask = Task { @MainActor in
            await self.listenForTransactions()
        }
    }
    
    private func loadProductsOnInit() {
        Task { @MainActor in
            await self.loadProducts()
        }
    }

    deinit {
        transactionTask?.cancel()
    }

    private func listenForTransactions() async {
        for await result in Transaction.updates {
            do {
                let transaction = try checkVerified(result)

                await transaction.finish()

                // Handle successful purchase (only show thank you once)
                if transaction.productID == "fivedonation" && !showThankYou {
                    showThankYou = true
                    print("Purchase completed via transaction update: \(transaction.productID)")
                }
            } catch {
                print("Transaction verification failed: \(error)")
            }
        }
    }

    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }

        print("🔍 Attempting to load products with IDs: \(productIDs)")
        
        do {
            products = try await Product.products(for: productIDs)
            print("✅ Successfully loaded \(products.count) products")
            
            if products.isEmpty {
                print("⚠️ WARNING: 0 products loaded!")
                print("📋 Requested IDs: \(productIDs)")
                print("💡 Possible issues:")
                print("   1. StoreKit configuration file not selected in scheme")
                print("   2. Product IDs don't match App Store Connect")
                print("   3. Products not approved/available in App Store Connect")
                print("   4. Not signed in with sandbox account (if on device)")
            } else {
                for product in products {
                    print("   📦 Product: \(product.id)")
                    print("      Name: \(product.displayName)")
                    print("      Price: \(product.displayPrice)")
                }
            }
        } catch {
            print("❌ Failed to load products: \(error)")
            print("   Error details: \(error.localizedDescription)")
            print("   Make sure:")
            print("   1. In-App Purchase capability is enabled")
            print("   2. StoreKit config file is selected in scheme (Edit Scheme > Run > Options)")
            print("   3. Product IDs in code match App Store Connect exactly")
        }
    }

    func purchase(_ product: Product) async throws {
        // Transaction updates are being monitored by listenForTransactions() started in init()
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            if !showThankYou { // Only show once
                showThankYou = true
            }
            print("Purchase successful: \(transaction.productID)")

        case .userCancelled:
            print("User cancelled purchase")
            break

        case .pending:
            print("Purchase pending")
            break

        @unknown default:
            break
        }
    }

    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let verificationError):
            throw verificationError
        case .verified(let safe):
            return safe
        }
    }

    func resetThankYou() {
        showThankYou = false
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            print("Purchase restore completed")
        } catch {
            print("Purchase restore failed: \(error)")
        }
    }
}