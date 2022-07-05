//
//  Manager.swift
//  OneLink
//
//  Created by Min-Su Kim on 2022/07/02.
//

import Foundation

final class Manager: ObservableObject {
  @Published var links: [Link]
  
  init(links: [Link]) {
    self.links = links
  }
}

extension Manager {
  func getIndex(link: Link) -> Int {
    if let index = links.firstIndex(of: link) {
      return index
    } else {
      return 0
    }
  }
}
