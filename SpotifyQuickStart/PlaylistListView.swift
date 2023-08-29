//
//  PlaylistListView.swift
//  SpotifyQuickStart
//
//  Created by Alison Ryan on 8/25/23.
//

import SwiftUI

struct PlaylistView: View {
  @State private var playlists: [Playlist] = []
  @State private var selectedPlaylists: [Playlist] = []
  @State private var isLoading = false
  var accessToken: String
  @State private var areTracksFetched = false
  @State private var tracks: [Track] = []
  @EnvironmentObject var spotifyController: SpotifyController
  @State private var first = true


  var body: some View {
    NavigationView {
      if accessToken.isEmpty {
        Text("Loading...")
      } else {
        TabView {
          UnselectedPlaylistView(playlists: $playlists, selectedPlaylists: $selectedPlaylists)
            .tabItem {
              Label("Unselected", systemImage: "rectangle.stack.badge.minus")
            }
          SelectedPlaylistView(selectedPlaylists: $selectedPlaylists, playlists: $playlists)
            .tabItem {
              Label("Selected", systemImage: "rectangle.stack.badge.plus")
            }
          Button(action: {
                      fetchTracksForSelectedPlaylists()
                      areTracksFetched = true

                      if let firstTrack = tracks.first {
                          spotifyController.playTrack(uri: firstTrack.id)
                      }
                  }) {
                      Text("Continue")
                          .font(.headline)
                          .foregroundColor(.white)
                          .padding()
                          .background(Color.blue)
                          .cornerRadius(10)
                  }
                  .tabItem {
                      Label("Continue", systemImage: "arrow.right.circle")
                  }
        }
        .onAppear(perform: fetchPlaylists)
      }
    }
    .navigationTitle("RunJam") 

  }
//  func selectSecondClosestTrackToTempo(from tracks: [Track], targetTempo: Float) -> Track? {
//      var closestTrack: Track?
//      var secondClosestTrack: Track?
//      var minTempoDifference: Float = .greatestFiniteMagnitude
//      var secondMinTempoDifference: Float = .greatestFiniteMagnitude
//
//      for track in tracks {
//          if let tempo = track.audioFeatures?.tempo {
//              let tempoDifference = abs(tempo - targetTempo)
//
//              if tempoDifference < minTempoDifference {
//                  secondClosestTrack = closestTrack
//                  closestTrack = track
//                  secondMinTempoDifference = minTempoDifference
//                  minTempoDifference = tempoDifference
//              } else if tempoDifference < secondMinTempoDifference {
//                  secondClosestTrack = track
//                  secondMinTempoDifference = tempoDifference
//              }
//          }
//      }
//
//      return secondClosestTrack
//  }
//  func fetchTracksForSelectedPlaylists() {
//      let dispatchGroup = DispatchGroup()
//
//      if first {
//          first = false
//          for playlist in selectedPlaylists {
//              dispatchGroup.enter()
//              fetchTracksForPlaylist(playlistId: playlist.id, group: dispatchGroup)
//          }
//          Thread.sleep(forTimeInterval: 1)
//      }
//
//      dispatchGroup.notify(queue: .main) {
//          let randomTempo = Float.random(in: 100...150)
//          print("Generated random tempo:", randomTempo)
//
//          if let closestTrack = self.selectTrackWithTempoInRange(from: self.tracks, targetTempo: randomTempo) {
//              print("Selected closest track with tempo:", closestTrack.audioFeatures?.tempo ?? "N/A")
//              self.spotifyController.playTrack(uri: closestTrack.uri)
//
//              if let secondClosestTrack = self.selectSecondClosestTrackToTempo(from: self.tracks, targetTempo: randomTempo) {
//                  print("Selected second closest track with tempo:", secondClosestTrack.audioFeatures?.tempo ?? "N/A")
//                  self.spotifyController.queueTrack(uri: secondClosestTrack.uri)
//              } else {
//                  print("No second closest track found with suitable tempo.")
//              }
//          } else {
//              print("No closest track found with suitable tempo.")
//          }
//      }
//  }

  func fetchTracksForSelectedPlaylists() {
      let dispatchGroup = DispatchGroup()

    if first {
      first = false
      for playlist in selectedPlaylists {
        dispatchGroup.enter()
        fetchTracksForPlaylist(playlistId: playlist.id, group: dispatchGroup)

      }
      Thread.sleep(forTimeInterval: 1)
    }

      dispatchGroup.notify(queue: .main) {
          let randomTempo = Float.random(in: 100...150)
          print("Generated random tempo:", randomTempo)
        if let selectedTrack = self.selectTrackWithTempoInRange(from: self.tracks, targetTempo: randomTempo) {
              print("Selected track with tempo:", selectedTrack.audioFeatures?.tempo ?? "N/A")
          print(selectedTrack.name)
              spotifyController.playTrack(uri: selectedTrack.uri)
          } else {
              print("No track found with suitable tempo.")
          }
      }
  }
  func selectTrackClosestToTempo(from tracks: [Track], targetTempo: Float) -> Track? {
      var closestTrack: Track?
      var minTempoDifference: Float = .greatestFiniteMagnitude

      for track in tracks {
          if let tempo = track.audioFeatures?.tempo {
              let tempoDifference = abs(tempo - targetTempo)
              if tempoDifference < minTempoDifference {
                  minTempoDifference = tempoDifference
                  closestTrack = track
              }
          }
      }

      return closestTrack
  }


  func selectTrackWithTempoInRange(from tracks: [Track], targetTempo: Float) -> Track? {
    return selectTrackClosestToTempo(from: tracks, targetTempo: targetTempo)

      }



  func fetchTracksForPlaylist(playlistId: String, group: DispatchGroup) {
      let trackURL = URL(string: "https://api.spotify.com/v1/playlists/\(playlistId)/tracks")!
      var request = URLRequest(url: trackURL)
      request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

      URLSession.shared.dataTask(with: request) { data, response, error in
          defer { group.leave() }
          if let data = data {
              do {
                  let jsonDecoder = JSONDecoder()
                  let tracksResponse = try jsonDecoder.decode(TracksResponse.self, from: data)

                  let dispatchGroup = DispatchGroup()
                  for trackItem in tracksResponse.items {
                      dispatchGroup.enter()
                      fetchAudioFeaturesForTrack(trackId: trackItem.track.id) { audioFeatures in
                          var trackWithFeatures = trackItem.track
                          trackWithFeatures.audioFeatures = audioFeatures
                        self.tracks.append(trackWithFeatures)
                          dispatchGroup.leave()
                      }
                  }
              } catch {
                  print(error)
              }
          } else if let error = error {
              print(error)
          }
      }.resume()
  }

  func fetchAudioFeaturesForTrack(trackId: String, completion: @escaping (AudioFeatures?) -> Void) {
      let audioFeaturesURL = URL(string: "https://api.spotify.com/v1/audio-features/\(trackId)")!
      var request = URLRequest(url: audioFeaturesURL)
      request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

      URLSession.shared.dataTask(with: request) { data, response, error in
          if let data = data {
              do {
                  let jsonDecoder = JSONDecoder()
                  let audioFeatures = try jsonDecoder.decode(AudioFeatures.self, from: data)
                  completion(audioFeatures)
              } catch {
                  print(error)
                  completion(nil)
              }
          } else if let error = error {
              print(error)
              completion(nil)
          }
      }.resume()
  }



  func fetchPlaylists() {

    isLoading = true
    let playlistURL = URL(string: "https://api.spotify.com/v1/me/playlists")!
    var request = URLRequest(url: playlistURL)
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

    URLSession.shared.dataTask(with: request) { data, response, error in
      if let data = data {
        do {
          let jsonDecoder = JSONDecoder()
          let playlistsResponse = try jsonDecoder.decode(PlaylistResponse.self, from: data)
          DispatchQueue.main.async {
            self.playlists = playlistsResponse.items
            isLoading = false
          }
        } catch {
          DispatchQueue.main.async {
            isLoading = false
          }
          print(error)
        }
      } else if let error = error {
        DispatchQueue.main.async {
          isLoading = false
        }
        print(error)
      }
    }.resume()
  }
}
