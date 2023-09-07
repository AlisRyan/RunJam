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
  var action: () -> Void // Closure property for the action
    var body: some View {
      Button(action: {
        action()
      }) {
        Text(title)
          .padding()
          .foregroundColor(.black)
          .font(.system(size: 30, weight: .semibold))
          .padding(20)
          .background {
            RoundedRectangle(cornerRadius: 8)
              .stroke(gradient, lineWidth: 10)
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
      CustomButton(title: "Click me") {
          print("Button clicked!")
      }    }
}
