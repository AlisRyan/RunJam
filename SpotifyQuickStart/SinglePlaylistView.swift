//
//  SinglePlaylistView.swift
//  SpotifyQuickStart
//
//  Created by Alison Ryan on 8/28/23.
//

import SwiftUI

struct SinglePlaylistView: View {
  @State private var screenWidth = UIScreen.main.bounds.size.width
  var playlist: Playlist
  var body: some View {
    if #available(iOS 15.0, *) {
      if let imageUrl = playlist.images.first?.url,
         let url = URL(string: imageUrl) {
        HStack(alignment: .center) {
          AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
              image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70)
                .padding(.all, 20)
            case .failure(_):
              Image(systemName: "photo")
                .resizable()
                .frame(width: 100, height: 100)
                .padding(.all, 20)
            case .empty:
              Color.clear
                .frame(width: 100, height: 100)
                .padding(.all, 20)
            @unknown default:
              Color.clear
                .frame(width: 100, height: 100)
                .padding(.all, 20)
            }
          }
          VStack(alignment: .leading) {
            Text(playlist.name)
              .font(.system(size: 20, design: .default))
              .foregroundColor(.black)
          }.padding(.trailing, 20)
          Spacer()
          Image("spotify-icon")
            .resizable()
            .scaledToFit()
            .frame(width: 70)
            .padding(.trailing, 10)
        }
        .frame(maxWidth: .infinity, alignment: .center)
//        .background(Color(red: 255, green: 255, blue: 255))
        .background {
          (Color(red: 255, green: 255, blue: 255))
          RoundedRectangle(cornerRadius: 8)
            .stroke(gradient, lineWidth: 5)
        }
        .padding(.horizontal, 30)
      }
    }
  }
  let gradient = LinearGradient(
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
}


struct SinglePlaylistView_Previews: PreviewProvider {
  static var previews: some View {
    SinglePlaylistView(playlist: Playlist(id: "hey", name: "beejee boys", images: [PlaylistImage(url: "https://mosaic.scdn.co/640/ab67616d0000b2730478062bc04df0947d232fcbab67616d0000b2735b97ef03e581f7ab1cea9c48ab67616d0000b2735d48e2f56d691f9a4e4b0bdfab67616d0000b273ea7caaff71dea1051d49b2fe")]))
  }
}
