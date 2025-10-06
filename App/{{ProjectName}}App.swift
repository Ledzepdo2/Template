import SwiftUI
import CoreKit
import MVVMFeature
import CleanFeature
import TCAFeature

@main
struct {{ProjectName}}App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .task {
                    AppBootstrap.shared.start()
                }
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        AppBootstrap.shared.logStartup()
        return true
    }
}

struct RootTabView: View {
    var body: some View {
        TabView {
            MVVMLoaderView(viewModel: .init(imageURL: URL(string: "https://placekitten.com/300/300")))
                .tabItem {
                    Label("MVVM", systemImage: "rectangle.stack")
                }

            CleanListView()
                .tabItem {
                    Label("Clean", systemImage: "list.bullet")
                }

            TCACounterView(store: .init(initialState: .init(), reducer: {
                TCACounterFeature()
            }))
                .tabItem {
                    Label("TCA", systemImage: "bolt.circle")
                }
        }
    }
}
