//
//  FloatingButton.swift
//  OneLink
//
//  Created by Min-Su Kim on 2022/07/02.
//

import SwiftUI

struct FloatingButton: View {
  let imageName: String
  let tappedAction: (() -> ())?
  
  init(_ imageName: String, tappedAction: (() -> ())? = nil) {
    self.imageName = imageName
    self.tappedAction = tappedAction
  }
  
  var body: some View {
    Button(action: {
      self.tappedAction?()
    }) {
      Image(systemName: imageName)
        .frame(width: 56, height: 56)
        .imageScale(.large)
        .foregroundColor(.white)
        .background(.black)
    }
    .frame(width: 56, height: 56)
    .cornerRadius(28)
    .clipped()
  }
}
