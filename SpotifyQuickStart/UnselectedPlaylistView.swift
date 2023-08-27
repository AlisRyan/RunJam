//
//  UnselectedPlaylistView.swift
//  SpotifyQuickStart
//
//  Created by Alison Ryan on 8/25/23.
//

import SwiftUI

struct UnselectedPlaylistView: View {
  @Binding var playlists: [Playlist]
  @Binding var selectedPlaylists: [Playlist]

  var body: some View {
    List(playlists, id: \.id) { playlist in
      Button(action: {
        selectedPlaylists.append(playlist)
        if let index = playlists.firstIndex(where: { $0.id == playlist.id }) {
          playlists.remove(at: index)
        }
      }) {
        HStack {
          if let imageUrl = playlist.images.first?.url,
             let url = URL(string: imageUrl) {
            if #available(iOS 15.0, *) {
              AsyncImage(url: url) { image in
                image
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 50, height: 50)
              } placeholder: {
                Image(systemName: "photo")
                  .resizable()
                  .frame(width: 50, height: 50)
              }
            } else {
              // Fallback on earlier versions
            }                    }
          Text(playlist.name)
        }
      }
    }
  }
}
