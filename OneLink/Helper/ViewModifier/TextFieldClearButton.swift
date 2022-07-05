//
//  TextFieldClearButton.swift
//  OneLink
//
//  Created by Min-Su Kim on 2022/07/05.
//

import SwiftUI

struct TextFieldClearButton: ViewModifier {
  @Binding var text: String
  var isFocused: FocusState<Bool>.Binding
  
  func body(content: Content) -> some View {
    content
      .overlay {
        if !text.isEmpty && isFocused.wrappedValue {
          HStack {
            Spacer()
            Button {
              text = ""
            } label:  {
              Image(systemName: "multiply.circle.fill")
            }
            .foregroundColor(.secondary)
            .padding(.trailing, 8)
          }
        }
      }
  }
}

extension View {
  func showClearButton(_ text: Binding<String>, isFocused: FocusState<Bool>.Binding) -> some View {
    self.modifier(TextFieldClearButton(text: text, isFocused: isFocused))
  }
}
