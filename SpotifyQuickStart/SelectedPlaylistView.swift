//
//  SelectedPlaylistView.swift
//  SpotifyQuickStart
//
//  Created by Alison Ryan on 8/25/23.
//

import SwiftUI

struct SelectedPlaylistView: View {
  @Binding var selectedPlaylists: [Playlist]
  @Binding var playlists: [Playlist]

  var body: some View {
    List(selectedPlaylists, id: \.id) { playlist in
      Button(action: {
        playlists.append(playlist)
        if let index = selectedPlaylists.firstIndex(where: { $0.id == playlist.id }) {
          selectedPlaylists.remove(at: index)
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

