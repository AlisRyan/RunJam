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
            Text("Unselected Playlists")
                .font(Font.system(size: 40, weight: .bold))
//                .opacity(1)
                .padding(.bottom, 20)
        }
      )
      .frame(height: 150)
      ScrollView {
        VStack {
          ForEach(playlists, id: \.id) { playlist in
            Button(action: {
              selectedPlaylists.append(playlist)
              if let index = playlists.firstIndex(where: { $0.id == playlist.id }) {
                playlists.remove(at: index)
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
//    List(playlists, id: \.id) { playlist in
//      Button(action: {
//        selectedPlaylists.append(playlist)
//        if let index = playlists.firstIndex(where: { $0.id == playlist.id }) {
//          playlists.remove(at: index)
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
