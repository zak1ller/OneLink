//
//  ContentView.swift
//  OneLink
//
//  Created by Min-Su Kim on 2022/07/02.
//

import SwiftUI
import RealmSwift

struct HomeView: View {
  @EnvironmentObject private var manager: Manager
  @State private var showingAddView = false
  @State private var showingEditView = false
  @State private var showingErrorMessageAlert = false
  @State private var alertErrorMessage = ""
  @State private var beforeLink: Link?
  
  var body: some View {
    NavigationView {
      ZStack {
        NavigationLink(destination: AddView(showingAddView: $showingEditView,
                                            isEditMode: true,
                                            beforeLink: beforeLink),
                       isActive: $showingEditView) { EmptyView() }
        linkListView
        addButton
      }
      .navigationTitle("HomeNavTitle".localized())
    }
    .alert("Alert".localized(), isPresented: $showingErrorMessageAlert, actions: {
      Button("Confirm".localized(), role: .cancel) {}
    }, message: {
      Text(alertErrorMessage)
    })
  }
}

extension HomeView {
  var linkListView: some View {
    List {
      ForEach(manager.links) { link in
        LinkRow(link: link)
          .listRowSeparator(.hidden)
          .listRowInsets(EdgeInsets())
          .contextMenu {
            Button(action: {
              shareLink(link: link)
            }, label: {
              Label("ShareLinkButton".localized(), systemImage: "square.and.arrow.up")
            })
            
            Button(action: {
              self.beforeLink = link
              showingEditView = true
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
    .listStyle(.plain)
    .clipped()
  }
  
  var addButton: some View {
    VStack {
      Spacer()
      HStack {
        Spacer()
        NavigationLink(destination: AddView(showingAddView: $showingAddView), isActive: $showingAddView) {
          FloatingButton("plus") {
            self.showingAddView = true
          }
        }
        .padding(.trailing, 24)
        .padding(.bottom, 24)
      }
    }
  }
}

extension HomeView {
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
  
  func removeLink(link: Link) {
    link.removeLink()
    manager.links = Link.getLinks()
  }
}
