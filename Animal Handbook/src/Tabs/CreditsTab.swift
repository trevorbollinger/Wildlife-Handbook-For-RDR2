import StoreKit
import SwiftUI

struct CreditsTab: View {
    @Environment(\.openURL) private var openURL
    @EnvironmentObject var storeKit: StoreKitManager

    let version: String
    let build: String

    init(
        version: String = Bundle.main.infoDictionary?[
            "CFBundleShortVersionString"
        ] as? String ?? "—",
        build: String = Bundle.main.infoDictionary?["CFBundleVersion"]
            as? String ?? "—"
    ) {
        self.version = version
        self.build = build
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Spacer()
                    Group {
                        Image("AppIcon")
                            .resizable()
                    }
                    .frame(width: 200.0, height: 200)
                    .cornerRadius(30)
                    .padding(.bottom, 15)
                    Text("Wildlife Handbook for RDR2")
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("Information Sources:")
                        .font(.headline)
                        .multilineTextAlignment(.center)

                    VStack(spacing: 8) {
                        Button(action: {
                            if let url = URL(
                                string:
                                    "https://www.rockstargames.com/reddeadredemption2"
                            ) {
                                openURL(url)
                            }
                        }) {
                            HStack {
                                Image(systemName: "link")
                                Text("Red Dead Redemption II")
                                    .underline()
                                    .font(.subheadline)
                                    .bold()
                                    .fixedSize(
                                        horizontal: false,
                                        vertical: true
                                    )
                            }
                            .foregroundStyle(.blue)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                Capsule().fill(Color.blue.opacity(0.10))
                            )
                        }
                        .buttonStyle(.plain)

                        Button(action: {
                            if let url = URL(
                                string: "https://reddead.fandom.com"
                            ) {
                                openURL(url)
                            }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "link")
                                Text("RDR2 Fandom Wiki")
                                    .underline()
                                    .font(.subheadline)
                                    .bold()
                                    .fixedSize(
                                        horizontal: false,
                                        vertical: true
                                    )
                            }
                            .foregroundStyle(.blue)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                Capsule().fill(Color.blue.opacity(0.10))
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    .padding()

                    VStack {
                        Text(
                            "If you run into any problems, spot any errors, or have a feature request:"
                        )
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.vertical, 5)

                        Button(action: {
                            if let url = URL(string: "mailto:trevor@boli.dev") {
                                openURL(url)
                            }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "envelope")
                                Text("trevor@boli.dev")
                                    .underline()
                                    .font(.subheadline)
                                    .bold()
                                    .fixedSize(
                                        horizontal: false,
                                        vertical: true
                                    )
                            }
                            .foregroundStyle(.blue)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                Capsule().fill(Color.blue.opacity(0.10))
                            )
                        }
                        .buttonStyle(.plain)
                        .padding(.vertical, 5)
                    }
                    Spacer()

                    DonationButton()
                        .padding(.vertical, 10)

                    Text("If you enjoy the app, consider donating to help cover the developer fee and keep the app on the App Store!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 10)

                    HStack(alignment: .center) {
                        Image("boli")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .cornerRadius(30)

                        Text("Boli Development")
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer()

                    VStack {
                        Text(versionString)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.vertical, 10)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
            .alert("Thank You! ❤️", isPresented: $storeKit.showThankYou) {
                Button("Continue") {
                    storeKit.resetThankYou()
                }
            } message: {
                Text(
                    "Thank you so much for the support! Your donation will go towards keeping the app on the App Store. You are awesome! 🎉"
                )
            }
        }
    }

    private var versionString: String {
        "Wildlife Handbook for RDR2\nVersion '\(version)' \nBuild '\(build)'"
    }
}

