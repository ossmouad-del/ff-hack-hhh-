import SwiftUI

struct RootView: View {
    @State private var selection = 0

    private let tint = Color(
        red: 0.35,
        green: 0.78,
        blue: 0.98
    )

    var body: some View {
        TabView(selection: $selection) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "square.grid.2x2.fill")
                }
                .tag(0)

            FileBrowserView()
                .tabItem {
                    Label("Files", systemImage: "folder.fill")
                }
                .tag(1)

            PackageLibraryView()
                .tabItem {
                    Label("Packages", systemImage: "shippingbox.fill")
                }
                .tag(2)

            WallpaperWorkspaceView()
                .tabItem {
                    Label("Wallpaper", systemImage: "photo.fill")
                }
                .tag(3)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(4)
        }
        .tint(tint)
        .preferredColorScheme(.dark)
    }
}

struct ScreenBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.035, green: 0.055, blue: 0.09),
                Color(red: 0.07, green: 0.10, blue: 0.16)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

struct Panel: View {
    let title: String
    let subtitle: String
    let symbol: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: symbol)
                .font(.system(size: 21, weight: .semibold))
                .foregroundStyle(.cyan)
                .frame(width: 46, height: 46)
                .background(
                    Color.cyan.opacity(0.13),
                    in: RoundedRectangle(cornerRadius: 14)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline).foregroundStyle(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.58))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundStyle(.white.opacity(0.35))
        }
        .padding(15)
        .background(
            Color.white.opacity(0.055),
            in: RoundedRectangle(cornerRadius: 18)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.07))
        }
    }
}

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                ScreenBackground()

                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("NOTAS")
                                    .font(.system(size: 31, weight: .black, design: .rounded))
                                    .tracking(1.4)

                                Text("Device workspace")
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.55))
                            }

                            Spacer()

                            Image(systemName: "sparkles")
                                .font(.title2)
                                .foregroundStyle(.cyan)
                                .padding(13)
                                .background(Color.cyan.opacity(0.12), in: Circle())
                        }
                        .padding(.top, 12)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Welcome back")
                                .font(.title2.bold())

                            Text("Manage your local files, packages and visual workspace.")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.62))
                        }
                        .padding(18)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color.blue.opacity(0.30),
                                    Color.cyan.opacity(0.10)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            in: RoundedRectangle(cornerRadius: 22)
                        )

                        Text("WORKSPACE")
                            .font(.caption.bold())
                            .tracking(1.5)
                            .foregroundStyle(.white.opacity(0.45))

                        VStack(spacing: 11) {
                            Panel(
                                title: "File Browser",
                                subtitle: "Browse and import documents",
                                symbol: "folder"
                            )

                            Panel(
                                title: "Package Library",
                                subtitle: "Keep track of imported packages",
                                symbol: "shippingbox"
                            )

                            Panel(
                                title: "Wallpaper Studio",
                                subtitle: "Preview images from your library",
                                symbol: "photo"
                            )

                            Panel(
                                title: "Settings",
                                subtitle: "App preferences and information",
                                symbol: "slider.horizontal.3"
                            )
                        }

                        Text("Independent local workspace. No system exploitation or security bypass.")
                            .font(.footnote)
                            .foregroundStyle(.white.opacity(0.38))
                            .padding(.top, 5)
                    }
                    .padding(20)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}