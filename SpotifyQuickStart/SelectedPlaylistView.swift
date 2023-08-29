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
            Text("Selected Playlists")
                .font(Font.system(size: 40, weight: .bold))
//                .opacity(1)
                .padding(.bottom, 20)
        }
      )
      .frame(height: 150)
      ScrollView {
        VStack {
          ForEach(selectedPlaylists, id: \.id) { playlist in
            Button(action: {
              playlists.append(playlist)
              if let index = selectedPlaylists.firstIndex(where: { $0.id == playlist.id }) {
                selectedPlaylists.remove(at: index)
              }
            }) {
              SinglePlaylistView(playlist: playlist)
                .padding(.bottom, 20)
            }
          }
        }
      }
    }
    .edgesIgnoringSafeArea([.top, .bottom])
  }
//    List(selectedPlaylists, id: \.id) { playlist in
//      Button(action: {
//        playlists.append(playlist)
//        if let index = selectedPlaylists.firstIndex(where: { $0.id == playlist.id }) {
//          selectedPlaylists.remove(at: index)
//        }
//      }) {
//        HStack {
//          if let imageUrl = playlist.images.first?.url,
//             let url = URL(string: imageUrl) {
//            if #available(iOS 15.0, *) {
//              AsyncImage(url: url) { image in
//                image
//                  .resizable()
//                  .aspectRatio(contentMode: .fit)
//                  .frame(width: 50, height: 50)
//              } placeholder: {
//                Image(systemName: "photo")
//                  .resizable()
//                  .frame(width: 50, height: 50)
//              }
//            } else {
//            }                    }
//          Text(playlist.name)
//        }
//      }
//    }
//  }
}

