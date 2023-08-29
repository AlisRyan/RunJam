
import SwiftUI

struct ContentView: View {
    @StateObject var spotifyController = SpotifyController()

    var body: some View {
        NavigationView {
            PlaylistListView(accessToken: spotifyController.accessToken ?? "")
                .environmentObject(spotifyController)
        }
        .navigationTitle("RunJam") 
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
