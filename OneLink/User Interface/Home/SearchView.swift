//
//  SearchView.swift
//  OneLink
//
//  Created by Min-Su Kim on 2022/07/06.
//

import SwiftUI

struct SearchView: View {
  @EnvironmentObject private var manager: Manager
  @State private var searchText: String = ""
  @State private var showingEditView: Bool = false
  @State private var showingErrorMessageAlert = false
  @State private var alertErrorMessage = ""
  @State private var beforeLink: Link?
  
  var body: some View {
    ZStack {
      editView
      linkListView
    }
    .navigationTitle(Text("Search".localized()))
    .navigationBarTitleDisplayMode(.inline)
    .alert("Alert".localized(), isPresented: $showingErrorMessageAlert, actions: {
      Button("Confirm".localized(), role: .cancel) {}
    }, message: {
      Text(alertErrorMessage)
    })
  }
}

extension SearchView {
  var editView: some View {
    NavigationLink(destination: AddView(showingAddView: $showingEditView,
                                        isEditMode: true,
                                        beforeLink: beforeLink),
                   isActive: $showingEditView) { EmptyView() }
  }
  
  var linkListView: some View {
    List {
      ForEach(Link.searchLinks($searchText.wrappedValue)) { link in
        LinkRow(link: link)
          .onTapGesture { openURL(link: link) }
          .contextMenu {
            Button(action: {
              shareLink(link: link)
            }, label: {
              Label("ShareLinkButton".localized(), systemImage: "square.and.arrow.up")
            })
            
            Button(action: {
              editLink(link: link)
            }, label: {
              Label("EditLinkButton".localized(), systemImage: "square.and.pencil")
            })
            
            Button(action: {
              removeLink(link: link)
            }, label: {
              Label("DeleteLinkButton".localized(), systemImage: "trash")
            })
          }
      }
    }
    .searchable(text: $searchText)
    .listStyle(.plain)
    .clipped()
  }
}

extension SearchView {
  func openURL(link: Link) {
    if let error = link.openURL() {
      showingErrorMessageAlert = true
      alertErrorMessage = error
    }
  }
  
  func shareLink(link: Link) {
    let AV = UIActivityViewController(activityItems: [link.link], applicationActivities: nil)
    UIApplication.shared.currentUIWindow()?.rootViewController?.present(AV, animated: true, completion: nil)
  }
  
  func editLink(link: Link) {
    beforeLink = link
    showingEditView = true
  }
  
  func removeLink(link: Link) {
    link.removeLink()
    manager.links = Link.getLinks()
  }
}
