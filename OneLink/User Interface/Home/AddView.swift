//
//  AddView.swift
//  OneLink
//
//  Created by Min-Su Kim on 2022/07/02.
//

import SwiftUI

struct AddView: View {
  @EnvironmentObject private var manager: Manager
  @State private var link = ""
  @State private var description = ""
  @State private var showingErrorMessageAlert = false
  @State private var showingCompleteMessageAlert = false
  @State private var alertErrorMessage = ""
  @Binding private var showingAddView: Bool
  
  @FocusState private var linkFocused: Bool
  @FocusState private var descriptionFocused: Bool
  
  init(
    showingAddView: Binding<Bool>
  ) {
    self._showingAddView = showingAddView
  }
  
  var body: some View {
    VStack {
      linkTextField
      Spacer().frame(height: 24)
      descriptionTextField
      Spacer()
    }
    .alert("Alert".localized(), isPresented: $showingErrorMessageAlert, actions: {
      Button("Confirm".localized(), role: .cancel) {}
    }, message: {
      Text(alertErrorMessage)
    })
    .alert("Alert".localized(), isPresented: $showingCompleteMessageAlert, actions: {
      Button("Confirm".localized(), role: .cancel) {
        showingAddView = false
      }
    }, message: {
      Text("NewLinkAdded".localized())
    })
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: {
          save()
        }) {
          Text("SaveButton".localized())
            .foregroundColor(Color.black)
        }
      }
    }
    .padding(.leading, 24)
    .padding(.trailing, 24)
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { // Navigation 애니메이션이 끝나야 실행 됨..
        linkFocused = true
      }
    }
  }
}

extension AddView {
  var linkTextField: some View {
    TypeTextField(text: $link,
                  placeHolder: "TypeLinkText".localized(),
                  submitLabel: .next,
                  isFocused: $linkFocused,
                  onCommittedAction: { descriptionFocused = true })
  }
  
  var descriptionTextField: some View {
    TypeTextField(text: $description,
                  placeHolder: "TypeDescriptionText".localized(),
                  submitLabel: .done,
                  isFocused: $descriptionFocused,
                  onCommittedAction: { save() })
  }
  
  func save() {
    if let error = Link.addLink(link: link, description: description) {
      showingErrorMessageAlert = true
      alertErrorMessage = error
    } else {
      manager.links = Link.getLinks()
      showingCompleteMessageAlert = true
    }
  }
}
