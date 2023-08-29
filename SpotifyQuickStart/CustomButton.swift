//
//  CustomButton.swift
//  SpotifyQuickStart
//
//  Created by Alison Ryan on 8/28/23.
//

import SwiftUI

@available(iOS 15.0, *)
struct CustomButton: View {
  var title: String
  @State var areTracksFetched = false
    var body: some View {
      Button(action: {
        areTracksFetched = true
      }) {
        Text(title)
          .padding()
          .foregroundColor(.black)
          .background {
            RoundedRectangle(cornerRadius: 8)
              .stroke(gradient, lineWidth: 2)
          }
      }
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

@available(iOS 15.0, *)
struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
      CustomButton(title:"Click me")
    }
}
