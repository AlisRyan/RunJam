//
//  AsyncImageView.swift
//  SpotifyQuickStart
//
//  Created by Alison Ryan on 8/25/23.
//

import SwiftUI
import UIKit

struct AsyncImageView: View {
    @State private var image: UIImage? = nil
    let url: URL

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .onAppear(perform: loadImage)
            }
        }
    }

    private func loadImage() {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let loadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = loadedImage
                }
            }
        }.resume()
    }
}
