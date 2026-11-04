import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct FileBrowserView: View {
    @State private var showImporter = false
    @State private var selectedName = "No document selected"

    var body: some View {
        NavigationStack {
            ZStack {
                ScreenBackground()

                VStack(spacing: 18) {
                    Image(systemName: "folder.badge.plus")
                        .font(.system(size: 48))
                        .foregroundStyle(.cyan)

                    Text("File Browser")
                        .font(.title2.bold())

                    Text(selectedName)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.55))
                        .multilineTextAlignment(.center)

                    Button {
                        showImporter = true
                    } label: {
                        Label("Import Document", systemImage: "square.and.arrow.down")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.cyan)

                    Text("Browse and import your documents.")
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.4))

                    Spacer()
                }
                .padding(24)
                .padding(.top, 35)
            }
            .navigationTitle("Files")
            .fileImporter(
                isPresented: $showImporter,
                allowedContentTypes: [.item],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    selectedName = urls.first?.lastPathComponent ?? "No document selected"
                case .failure(let error):
                    selectedName = error.localizedDescription
                }
            }
        }
    }
}

struct PackageLibraryView: View {
    @State private var showImporter = false
    @State private var packages: [String] = []

    var body: some View {
        NavigationStack {
            ZStack {
                ScreenBackground()

                VStack(spacing: 14) {
                    Button {
                        showImporter = true
                    } label: {
                        Label("Import Package", systemImage: "plus.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.cyan)

                    if packages.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "shippingbox")
                                .font(.system(size: 38))
                                .foregroundStyle(.cyan)

                            Text("No Packages")
                                .font(.headline)

                            Text("Imported packages will appear here.")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.55))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List {
                            ForEach(packages, id: \.self) { name in
                                Label(name, systemImage: "doc.zipper")
                            }
                            .onDelete {
                                packages.remove(atOffsets: $0)
                            }
                        }
                        .scrollContentBackground(.hidden)
                    }
                }
                .padding(20)
            }
            .navigationTitle("Packages")
            .fileImporter(
                isPresented: $showImporter,
                allowedContentTypes: [.item],
                allowsMultipleSelection: true
            ) { result in
                if case .success(let urls) = result {
                    packages.append(contentsOf: urls.map {
                        $0.lastPathComponent
                    })
                }
            }
        }
    }
}

struct WallpaperWorkspaceView: View {
    @State private var photo: PhotosPickerItem?
    @State private var image: UIImage?

    var body: some View {
        NavigationStack {
            ZStack {
                ScreenBackground()

                VStack(spacing: 20) {
                    Group {
                        if let image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                        } else {
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color.white.opacity(0.06))
                                .overlay {
                                    VStack(spacing: 10) {
                                        Image(systemName: "photo")
                                            .font(.system(size: 45))
                                            .foregroundStyle(.cyan)

                                        Text("Choose an image to preview")
                                            .foregroundStyle(.white.opacity(0.55))
                                    }
                                }
                        }
                    }
                    .frame(maxHeight: 360)

                    PhotosPicker(
                        selection: $photo,
                        matching: .images
                    ) {
                        Label("Choose Photo", systemImage: "photo.on.rectangle")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.cyan)

                    Text("Preview only. Device wallpaper is not changed automatically.")
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.4))

                    Spacer()
                }
                .padding(20)
                .padding(.top, 25)
            }
            .navigationTitle("Wallpaper Studio")
            .onChange(of: photo) { newValue in
                guard let item = newValue else { return }

                Task {
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        image = UIImage(data: data)
                    }
                }
            }
        }
    }
}

struct SettingsView: View {
    @AppStorage("hapticsEnabled")
    private var hapticsEnabled = true

    @AppStorage("compactDashboard")
    private var compactDashboard = false

    var body: some View {
        NavigationStack {
            ZStack {
                ScreenBackground()

                Form {
                    Section("Preferences") {
                        Toggle("Haptic Feedback", isOn: $hapticsEnabled)
                        Toggle("Compact Dashboard", isOn: $compactDashboard)
                    }

                    Section("Application") {
                        LabeledContent("Name", value: "NOTAS Rebuild")
                        LabeledContent("Version", value: "1.0.0")
                        LabeledContent("Minimum iOS", value: "16.0")
                    }

                    Section {
                        Text("Independent local workspace. No key login or system exploitation.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
        }
    }
}