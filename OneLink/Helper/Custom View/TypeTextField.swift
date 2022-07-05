//
//  TypeTextField.swift
//  OneLink
//
//  Created by Min-Su Kim on 2022/07/03.
//

import SwiftUI

struct TypeTextField: View {
  @Binding private var text: String
  var placeHolder: String
  var isFocused: FocusState<Bool>.Binding
  var submitLabel: SubmitLabel
  
  var onCommittedAction: (() -> (()))?
  
  init(
    text: Binding<String>,
    placeHolder: String,
    submitLabel: SubmitLabel = SubmitLabel.return,
    isFocused: FocusState<Bool>.Binding,
    onCommittedAction: (() -> ())? = nil
  ) {
    self._text = text
    self.placeHolder = placeHolder
    self.submitLabel = submitLabel
    self.isFocused = isFocused
    self.onCommittedAction = onCommittedAction
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(placeHolder)
        .font(.system(size: 14).weight(.medium))
      
      Spacer().frame(height: 8)
      
      Capsule()
        .fill(Color.secondaryBackground)
        .overlay(content: {
          TextField("", text: $text, onCommit: {
            onCommittedAction?()
          })
          .submitLabel(submitLabel)
          .focused(isFocused)
          .font(.system(size: 14).weight(.regular))
          .padding(.leading, 16)
          .padding(.trailing, isFocused.wrappedValue ? 32 : 16)
          .showClearButton($text, isFocused: isFocused)
        })
        .frame(height: 40)
    }
  }
}
