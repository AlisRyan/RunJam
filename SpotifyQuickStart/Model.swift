//
//  Model.swift
//  SpotifyQuickStart
//
//  Created by Alison Ryan on 8/25/23.
//

import Foundation

struct PlaylistResponse: Codable {
  let items: [Playlist]
  // You can add more properties if needed
}

struct Playlist: Codable, Identifiable {
  let id: String
  let name: String
  let images: [PlaylistImage]
//  let tracks: [Track] // Assuming tracks is a property of type [Track]

  // You can add more properties if needed}
}

struct PlaylistImage: Codable {
  let url: String
}

struct Album: Hashable, Codable, Identifiable {
    let id: String
    let name: String
  let images: [Images]
  let artists: [Artist]

    // Add other properties as needed
}

struct Artist: Hashable, Codable, Identifiable {
  let id: String
  let name: String
}

struct Images: Hashable, Codable {
  let url: String
    // Add other properties as needed
}

struct SearchResponse: Codable {
    let albums: AlbumItems

    struct AlbumItems: Codable {
        let items: [Album]
    }
}

struct AuthResponse: Codable {
    let access_token: String
    let token_type: String
    let expires_in: Int
    // Add other properties as needed
}

//struct Track: Codable, Identifiable {
//    let id: String
//    let name: String
//    // Add any other properties you need for the track
//
//    // CodingKeys in case the property names differ from the API response
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        // Add coding keys for other properties if needed
//    }
//}
//
//struct TrackResponse: Codable {
//    let tracks: [Track]
//}

//struct TokenResponse: Decodable {
//    let accessToken: String
//    let tokenType: String
//    let expiresIn: Int
//    let refreshToken: String?
//
//    enum CodingKeys: String, CodingKey {
//        case accessToken = "access_token"
//        case tokenType = "token_type"
//        case expiresIn = "expires_in"
//        case refreshToken = "refresh_token"
//    }
//}
//