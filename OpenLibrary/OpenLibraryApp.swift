
import SwiftUI
import SwiftData

@main
struct iOSTechTestApp: App {
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.isNetworkConnected, networkMonitor.isConnected)
                .modelContainer(for: [BookItem.self, BookInfo.self, OfflineSubjectMap.self])
        }
    }
}
