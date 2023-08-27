//
//  ContentView.swift
//  SpotifyQuickStart
//
//  Created by Till Hainbach on 02.04.21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var spotifyController = SpotifyController()

    var body: some View {
        NavigationView {
            PlaylistListView(accessToken: spotifyController.accessToken ?? "")
                .environmentObject(spotifyController)
        }
        .navigationTitle("RunJam") // Set your desired title here
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
