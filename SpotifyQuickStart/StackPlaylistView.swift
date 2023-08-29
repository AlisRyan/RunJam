//
//  StackPlaylistView.swift
//  SpotifyQuickStart
//
//  Created by Alison Ryan on 8/28/23.
//

import SwiftUI

struct StackPlaylistView: View {
  var title: String
  var playlists: [Playlist]
  var body: some View {
    VStack {
      LinearGradient(
           gradient: Gradient(colors: [
               Color(red: 227/255, green: 175/255, blue: 204/255),
               Color(red: 227/255, green: 175/255, blue: 204/255),
               Color(red: 201/255, green: 175/255, blue: 227/255),
               Color(red: 175/255, green: 200/255, blue: 227/255),
               Color(red: 175/255, green: 200/255, blue: 227/255)
           ]),
          startPoint: .leading,
          endPoint: .trailing
      )
      .mask(
        VStack {
            Spacer()
            Text(title)
                .font(Font.system(size: 40, weight: .bold))
//                .opacity(1)
                .padding(.bottom, 20)
        }
      )
      .frame(height: 150)
      ScrollView {
        VStack {
          ForEach(playlists) { playlist in
            SinglePlaylistView(playlist: playlist)
              .padding(.bottom, 20)
          }
        }
      }
    }
//    .edgesIgnoringSafeArea([.top, .bottom])
  }
}

struct StackPlaylistView_Previews: PreviewProvider {
  static var previews: some View {
    StackPlaylistView(title: "Select Playlists", playlists: [Playlist(id: "hey", name: "beejee boys", images: [PlaylistImage(url: "https://mosaic.scdn.co/640/ab67616d0000b2730478062bc04df0947d232fcbab67616d0000b2735b97ef03e581f7ab1cea9c48ab67616d0000b2735d48e2f56d691f9a4e4b0bdfab67616d0000b273ea7caaff71dea1051d49b2fe")]), Playlist(id: "hey", name: "beejee boys", images: [PlaylistImage(url: "https://mosaic.scdn.co/640/ab67616d0000b2730478062bc04df0947d232fcbab67616d0000b2735b97ef03e581f7ab1cea9c48ab67616d0000b2735d48e2f56d691f9a4e4b0bdfab67616d0000b273ea7caaff71dea1051d49b2fe")]), Playlist(id: "hey", name: "beejee boys", images: [PlaylistImage(url: "https://mosaic.scdn.co/640/ab67616d0000b2730478062bc04df0947d232fcbab67616d0000b2735b97ef03e581f7ab1cea9c48ab67616d0000b2735d48e2f56d691f9a4e4b0bdfab67616d0000b273ea7caaff71dea1051d49b2fe")]), Playlist(id: "hey", name: "beejee boys", images: [PlaylistImage(url: "https://mosaic.scdn.co/640/ab67616d0000b2730478062bc04df0947d232fcbab67616d0000b2735b97ef03e581f7ab1cea9c48ab67616d0000b2735d48e2f56d691f9a4e4b0bdfab67616d0000b273ea7caaff71dea1051d49b2fe")]), Playlist(id: "hey", name: "beejee boys", images: [PlaylistImage(url: "https://mosaic.scdn.co/640/ab67616d0000b2730478062bc04df0947d232fcbab67616d0000b2735b97ef03e581f7ab1cea9c48ab67616d0000b2735d48e2f56d691f9a4e4b0bdfab67616d0000b273ea7caaff71dea1051d49b2fe")]), Playlist(id: "hey", name: "beejee boys", images: [PlaylistImage(url: "https://mosaic.scdn.co/640/ab67616d0000b2730478062bc04df0947d232fcbab67616d0000b2735b97ef03e581f7ab1cea9c48ab67616d0000b2735d48e2f56d691f9a4e4b0bdfab67616d0000b273ea7caaff71dea1051d49b2fe")]), Playlist(id: "hey", name: "beejee boys", images: [PlaylistImage(url: "https://mosaic.scdn.co/640/ab67616d0000b2730478062bc04df0947d232fcbab67616d0000b2735b97ef03e581f7ab1cea9c48ab67616d0000b2735d48e2f56d691f9a4e4b0bdfab67616d0000b273ea7caaff71dea1051d49b2fe")])])
  }
}
