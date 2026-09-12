import SwiftUI
import SwiftData

@main
struct HvaHvorApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: Entry.self)
    }
}
