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
  @State private var showingCompleteRegisterMessageAlert = false
  @State private var showingCompleteEditMessageAlert = false
  @State private var alertErrorMessage = ""
  @Binding private var showingAddView: Bool
  
  @FocusState private var linkFocused: Bool
  @FocusState private var descriptionFocused: Bool
  
  private var isEditMode: Bool
  private var beforeLink: Link?
  
  init(
    showingAddView: Binding<Bool>,
    isEditMode: Bool = false,
    beforeLink: Link? = nil
  ) {
    self._showingAddView = showingAddView
    self.isEditMode = isEditMode
    self.beforeLink = beforeLink
  }
  
  var body: some View {
    VStack {
      Spacer().frame(height: 24)
      linkTextField
      Spacer().frame(height: 24)
      descriptionTextField
      Spacer()
    }
    .padding(.leading, 16)
    .padding(.trailing, 16)
    .navigationBarTitleDisplayMode(.inline)
    .alert("Alert".localized(), isPresented: $showingErrorMessageAlert, actions: {
      Button("Confirm".localized(), role: .cancel) {}
    }, message: {
      Text(alertErrorMessage)
    })
    .alert("Alert".localized(), isPresented: $showingCompleteRegisterMessageAlert, actions: {
      Button("Confirm".localized(), role: .cancel) {
        showingAddView = false
      }
    }, message: {
      Text("NewLinkAdded".localized())
    })
    .alert("Alert".localized(), isPresented: $showingCompleteEditMessageAlert, actions: {
      Button("Confirm".localized(), role: .cancel) {
        showingAddView = false
      }
    }, message: {
      Text("SavedMessage".localized())
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
    .onAppear {
      if isEditMode {
        guard let beforeLink = beforeLink else { return }
        link = beforeLink.link
        description = beforeLink.linkDescription
      } else {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { // Navigation 애니메이션이 끝나야 실행 됨..
          self.linkFocused = true
        }
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
}

extension AddView {
  func save() {
    if isEditMode {
      guard let beforeLink = beforeLink else { return }
      if let error = beforeLink.edit(newLink: link, newDescription: description) {
        showingErrorMessageAlert = true
        alertErrorMessage = error
      } else {
        manager.links = Link.getLinks()
        showingCompleteEditMessageAlert = true
      }
    } else {
      if let error = Link.addLink(link: link, description: description) {
        showingErrorMessageAlert = true
        alertErrorMessage = error
      } else {
        manager.links = Link.getLinks()
        showingCompleteRegisterMessageAlert = true
      }
    }
  }
}
