//
//  PlayingView.swift
//  SpotifyQuickStart
//
//  Created by Alison Ryan on 8/29/23.
//

import SwiftUI

@available(iOS 15.0, *)
struct PlayingView: View {
  @State private var isPlaying = true
  var track: Track
  var skipAction: () -> Void
  var pauseAction: () -> Void
  @EnvironmentObject var spotifyController: SpotifyController // Access the SpotifyController instance
  var cadence: Int



  var body: some View {
    VStack {
      Spacer()
      Image("spotify-full")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 150)
          .colorInvert()
      if let imageUrl = track.album.images.first?.url,
         let url = URL(string: imageUrl) {

        AsyncImage(url: url) { phase in
          switch phase {
          case .success(let image):
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 300)
              .padding(.all, 20)
              .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
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
        Text(track.name)
          .font(.system(size: 30, weight: .bold))
          .multilineTextAlignment(.center)

        //          .padding(.top, 10)

        Text(track.artists.first!.name)
          .font(.system(size: 20))
          .foregroundColor(.gray)
          .multilineTextAlignment(.center)


        HStack(spacing: 40) {
          Button(action: {
            isPlaying.toggle()
            if isPlaying {
              spotifyController.appRemote.playerAPI?.resume(nil)
            } else {
              spotifyController.appRemote.playerAPI?.pause(nil)
            }
          }) {
            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
              .resizable()
              .frame(width: 60, height: 60)
              .foregroundColor(.black)

          }

          Button(action: {
            skipAction()
            isPlaying = true
          }) {
            Image(systemName: "forward.end.fill")
              .resizable()
              .frame(width: 40, height: 40)
              .foregroundColor(.black)
          }
        }
        Text("Current Cadence: \(cadence)")
            .font(.system(size: 20))
            .foregroundColor(.gray)
            .padding(.top, 10)//        .padding(.bottom, 20)
      }
    }
    .padding()
    .background {
      RoundedRectangle(cornerRadius: 8)
        .stroke(gradient, lineWidth: 10)
    }
    .padding(.bottom, 100)
  }
  let gradient = LinearGradient(
    gradient: Gradient(colors: [
        Color(red: 227/255, green: 175/255, blue: 204/255),
        Color(red: 201/255, green: 175/255, blue: 227/255),
        Color(red: 175/255, green: 200/255, blue: 227/255)
    ]),
   startPoint: .leading,
   endPoint: .trailing
)
}

//@available(iOS 15.0, *)
//struct PlayingView_Previews: PreviewProvider {
//    static var previews: some View {
//      let sampleArtist = Artist(id: "sample_artist_id", name: "Divad Eiwob")
//      let sampleAlbum = Album(id: "sample_album_id", name: "Sample Album", images: [PlaylistImage(url: "https://mosaic.scdn.co/640/ab67616d0000b2730478062bc04df0947d232fcbab67616d0000b2735b97ef03e581f7ab1cea9c48ab67616d0000b2735d48e2f56d691f9a4e4b0bdfab67616d0000b273ea7caaff71dea1051d49b2fe")])
//      let sampleTrack = Track(
//          id: "sample_track_id",
//          name: "Ziggy's Guitar",
//          uri: "sample_track_uri",
//          duration_ms: 240000,
//          audioFeatures: AudioFeatures(tempo: 120.0),
//          album: sampleAlbum,
//          artists: [sampleArtist]
//      )
//      PlayingView(track: sampleTrack)
//    }
//}
