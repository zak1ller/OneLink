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
  
  var body: some View {
    NavigationView {
      ZStack {
        linkListView
        addButton
      }
      .navigationTitle("HomeNavTitle".localized())
    }
  }
}

extension HomeView {
  var linkListView: some View {
    List {
      ForEach(manager.links) { link in
        LinkRow(link: link)
          .listRowSeparator(.hidden)
          .listRowInsets(EdgeInsets())
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
