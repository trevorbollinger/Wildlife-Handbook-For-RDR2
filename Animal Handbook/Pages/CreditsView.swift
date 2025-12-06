import SwiftUI

struct CreditsView: View {
    @Environment(\.openURL) private var openURL

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
            VStack {
                Spacer()
                Group {
                    if let uiImage = UIImage(named: "icon") {
                        Image(uiImage: uiImage)
                            .resizable()
                    } else {
                        Image(systemName: "pawprint.fill")
                            .resizable()
                    }
                }
                .frame(width: 175.0, height: 175.0)
                .cornerRadius(30)
                .foregroundStyle(.gray.opacity(0.3))
                Spacer()
                Text("Thank you for downloading Wildlife Handbook for RDR2!")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 5)
                Spacer()

                Text("Information used in this app was sourced from:")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 5)

                Text("Red Dead Redemption II by Rockstar Games")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .bold()
                
                Text("and")
                    .padding(.top, 5)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .bold()
                
                Button(action: {
                    if let url = URL(string: "https://reddead.fandom.com") {
                        openURL(url)
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "link")
                        Text("reddead.fandom.com")
                            .underline()
                            .font(.subheadline)
                            .bold()
                    }
                    .foregroundStyle(.blue)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule().fill(Color.blue.opacity(0.10))
                    )
                }
                .buttonStyle(.plain)

                .padding()

                VStack {
                    Text(
                        "If you run into any problems or errors, feel free to shoot me an email at"
                    )
                    .font(.headline)
                    .multilineTextAlignment(.center)
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

                VStack {
                    Text(versionString)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 10)
                }
            }
            .padding(.horizontal, 35.0)
            .padding(.bottom, 10)
        }
    }

    private var versionString: String {
        "Wildlife Handbook for RDR2\nVersion '\(version)' \nBuild '\(build)'"
    }
}

struct CreditsView_Preview: PreviewProvider {
    static var previews: some View {
        CreditsView(version: "1.2", build: "1")
            .preferredColorScheme(.dark)
    }
}
