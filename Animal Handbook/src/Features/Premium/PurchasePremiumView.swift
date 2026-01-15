
import StoreKit
import SwiftUI

struct PurchasePremiumView: View {
    @EnvironmentObject var storeKit: StoreKitManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 10) {
            // Header
            VStack(spacing: 10) {
                Image(systemName: "star.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.yellow)
                    .padding(.top, 40)

                Text("Unlock Premium")
                    .font(.largeTitle)
                    .bold()
            }

            Spacer()
            
            // Features List
            VStack(alignment: .leading, spacing: 15) {
                FeatureRow(icon: "checkmark.circle.fill", text: "Mark items as collected to track your progress", color: .green)
                FeatureRow(icon: "cart.circle.fill", text: "Track items to create list of needed pelts", color: .yellow)
                FeatureRow(icon: "icloud.circle.fill", text: "Synced collected and tracked items across all devices", color: .blue)
                FeatureRow(icon: "heart.circle.fill", text: "Support development!", color: .pink)
            }
            .padding(.horizontal)

            Spacer()

            // Purchase Button
            if let product = storeKit.products.first(where: { $0.id == "premium" }) {
                Button(action: {
                    Task {
                        try? await storeKit.purchase(product)
                    }
                }) {
                    VStack {
                        Text("Purchase Premium")
                            .font(.headline)
                        Text(product.displayPrice)
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                }
                .padding(.horizontal)
                
                
            } else if storeKit.isLoading {
                ProgressView()
                    .padding()
            } else {
                Text("Unable to load products. Please check your internet connection.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
            }

            // Restore Purchases & Dismiss
            
            
            Button(action: {
                Task {
                    dismiss()
                }
            }) {
          
                    Text("Not Now")
                        .font(.headline)
 
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(20)
            }
            .padding(.horizontal)
            
            
            HStack {
                Button("Restore Purchases") {
                    Task {
                        await storeKit.restorePurchases()
                    }
                }
                .font(.footnote)
                
                Spacer()
            
            }
            .padding(.horizontal, 30)
        }
        .presentationDetents([.height(calculateIdealHeight())])
        .padding()
    }
    
    private func calculateIdealHeight() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        // On smaller devices (like mini), use more of the screen
        // On larger devices (like Pro Max or iPad), use less
        if screenHeight < 700 {
            return screenHeight * 0.99  // iPhone mini, SE
        } else if screenHeight < 900 {
            return screenHeight * 0.75  // Standard iPhones
        } else {
            return screenHeight * 0.70  // Larger iPhones and iPads
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundStyle(color)
                .frame(width: 40)
            
            Text(text)
                .font(.body)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}

#Preview {
    Text("Parent View")
        .sheet(isPresented: .constant(true)) {
            PurchasePremiumView()
                .environmentObject(StoreKitManager())
        }
}
