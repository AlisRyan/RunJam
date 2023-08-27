
import SwiftUI
import SpotifyiOS


@main
struct SpotifyQuickStart: App {
    @StateObject var spotifyController = SpotifyController()

    var body: some Scene {
        WindowGroup {
            ContentView(spotifyController: spotifyController)
                .onOpenURL { url in
                    spotifyController.setAccessToken(from: url)
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didFinishLaunchingNotification), perform: { _ in
                    spotifyController.connect()
                })
        }
    }
}
