//
//  PlaylistView.swift
//  SpotifyQuickStart
//
//  Created by Alison Ryan on 8/27/23.
//

import SwiftUI
import CoreMotion
import SpotifyiOS

struct PlaylistListView: View {
  @State private var playlists: [Playlist] = []
  @State private var selectedPlaylists: [Playlist] = []
  @State private var isLoading = false
  var accessToken: String
  @State private var areTracksFetched = false
  @State private var tracks: [Track] = [] // Replace
  @EnvironmentObject var spotifyController: SpotifyController // Access the SpotifyController as an environment object
  @State private var first = true
  private let pedometer = CMPedometer()
  @State private var cadence: Double = 0.0 // Store the current cadence
  @State private var timerRemainingTime: TimeInterval = 0




  var body: some View {
    NavigationView {
      if accessToken.isEmpty {
        // Display a loading state or placeholder
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
            //
            //            if let firstTrack = tracks.first {
            //              spotifyController.playTrack(uri: firstTrack.id)
            //            }
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
        .onAppear(perform: startCadence)
      }
    }
    .navigationTitle("RunJam") // Set your desired title here

  }

  func startCadence() {
    self.pedometer.startUpdates(from: Date()) { pedometerData, error in
      print(pedometerData?.currentCadence ?? "HEY")
      if let currentCadence = pedometerData?.currentCadence {
          self.cadence = Double(truncating: currentCadence)
      }
    }
  }


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
      if let selectedTrack = self.selectTrackWithTempoInRange(from: self.tracks, targetTempo: Float(cadence)) {
        if let index = self.tracks.firstIndex(where: { $0.id == selectedTrack.id }) {
          self.tracks.remove(at: index)
          print("Selected track with tempo:", selectedTrack.audioFeatures?.tempo ?? "N/A")
          self.spotifyController.playTrack(uri: selectedTrack.uri)
          print(selectedTrack.name)
          print(selectedTrack.duration_ms)
          timerStuff(track: selectedTrack)
        }
      } else {
        print("No track found with suitable tempo.")
      }
//      if let selectedTrack = self.selectTrackWithTempoInRange(from: self.tracks, targetTempo: Float(100)) {
//          if let index = self.tracks.firstIndex(where: { $0.id == selectedTrack.id }) {
//              self.tracks.remove(at: index)
//              print("Selected track with tempo:", selectedTrack.audioFeatures?.tempo ?? "N/A")
//              self.spotifyController.playTrack(uri: selectedTrack.uri)
//              print(selectedTrack.name)
//              print(selectedTrack.duration_ms)
//
//              // Start the timer with the track's duration
//              self.timerRemainingTime = TimeInterval(selectedTrack.duration_ms) / 1000
//
//              // Create a timer that triggers when the timer reaches 0
//              Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//                  self.timerRemainingTime -= 1
//
//                  // When timer reaches 0, fetch new tracks
//                  if self.timerRemainingTime <= 100 {
//                    print("HEYO")
//                      timer.invalidate() // Stop the timer
//                      self.fetchTracksForSelectedPlaylists()
//                  }
//              }
//          }
//      }

    }
  }

  func timerStuff(track: Track) {
    self.timerRemainingTime = TimeInterval(track.duration_ms) / 1000
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
      self.timerRemainingTime -= 1
      if self.timerRemainingTime <= 120 {
        print("HEYO")
        timer.invalidate()
        fetchTracksForSelectedPlaylists()
      }
    }
  }


  func selectTrackClosestToTempo(from tracks: [Track], targetTempo: Float) -> Track? {
    var closestTrack: Track?
    var minTempoDifference: Float = .greatestFiniteMagnitude
    let target = targetTempo * 60

    for track in tracks {
      if let tempo = track.audioFeatures?.tempo {
        let tempoDifference = abs(tempo - target)
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
