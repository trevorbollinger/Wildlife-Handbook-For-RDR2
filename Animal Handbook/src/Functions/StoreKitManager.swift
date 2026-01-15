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
    @Published var shouldRequestReview = false
    
    // Feature gating
    @Published var hasPremium: Bool = false // Default to false for testing gate
    
    func unlockPremium() async {
        if let premiumProduct = products.first(where: { $0.id == "premium" }) {
            do {
                try await purchase(premiumProduct)
            } catch {
                print("Failed to start purchase flow: \(error)")
            }
        } else {
            print("Premium product not found in loaded products")
        }
    }

    
    private var productIDs = ["fivedonation", "twodonation", "premium"]
    
    // UserDefaults keys
    private let launchCountKey = "appLaunchCount"
    private let reviewRequestedKey = "hasRequestedAppStoreReview"

    // Transaction listener task - must be started before any purchases
    private var transactionTask: Task<Void, Never>?

    init() {
        // Track app launches
        incrementLaunchCount()
        
        // All stored properties are now initialized
        // Start listening for transaction updates immediately (required for StoreKit compliance)
        startTransactionListener()
        
        // Load products
        loadProductsOnInit()
        
        // Check for existing entitlements
        Task { await updateEntitlements() }
    }
    
    private func incrementLaunchCount() {
        let currentCount = UserDefaults.standard.integer(forKey: launchCountKey)
        let newCount = currentCount + 1
        UserDefaults.standard.set(newCount, forKey: launchCountKey)
        print("App Launch Count: \(newCount)")
        
        let hasRequested = UserDefaults.standard.bool(forKey: reviewRequestedKey)
        
        if newCount == 2 && !hasRequested {
            // Delay slightly to let the app load UI
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
                self?.shouldRequestReview = true
            }
        }
    }
    
    func markReviewRequested() {
        UserDefaults.standard.set(true, forKey: reviewRequestedKey)
        shouldRequestReview = false
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
                
                // Update entitlements based on transaction
                await updateEntitlements()

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
    
    @MainActor
    func updateEntitlements() async {
        print("Checking entitlements...")
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                print("Found entitlement: \(transaction.productID)")
                if transaction.productID == "premium" {
                    print("✅ Premium entitlement verified!")
                    hasPremium = true
                }
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
            
            // Explicitly update entitlements after purchase
            await updateEntitlements()
            
            // Only show thank you for donations
            if product.id.contains("donation") && !showThankYou {
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