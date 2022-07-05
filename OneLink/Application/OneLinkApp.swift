//
//  OneLinkApp.swift
//  OneLink
//
//  Created by Min-Su Kim on 2022/07/02.
//

import SwiftUI

@main
struct OneLinkApp: App {
  var body: some Scene {
    UINavigationBar.appearance().tintColor = .black
    
    return WindowGroup {
      HomeView()
        .environmentObject(Manager(links: Link.getLinks()))
    }
  }
}
