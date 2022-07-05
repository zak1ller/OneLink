//
//  Link.swift
//  OneLink
//
//  Created by Min-Su Kim on 2022/07/02.
//

import Foundation
import RealmSwift

final class Link: Object {
  @objc dynamic let id = UUID()
  @objc dynamic var link: String = ""
  @objc dynamic var linkDescription: String = ""
  @objc dynamic var isFavorite: Bool = false
  @objc dynamic var date: Date = Date()
  @objc dynamic var isDeleted: Bool = false
}

// MARK: - 데이터 관리
extension Link {
  static func getLinks() -> [Link] {
    let results = try! Realm().objects(Link.self)
      .sorted(byKeyPath: "date", ascending: false)
      .sorted(byKeyPath: "isFavorite", ascending: false)
      .filter("isDeleted = false")
    
    var links: [Link] = []
    for value in results {
      links.append(value)
    }
    
    return links
  }
  
  static func addLink(link: String, description: String) -> String? {
    if let error = checkLinkStringSize(link: link) {
      return error
    } else if let error = checkDescriptionStringSize(description: description) {
      return error
    }
    
    guard let _ = URL(string: link) else { return "InvalidUrlErrorMessage".localized() }
   
    let data = Link()
    data.link = link
    data.linkDescription = description
    
    try! Realm().write {
      try! Realm().add(data)
    }
    
    return nil
  }
  
  func removeLink() {
    try! Realm().write {
      isDeleted = true
    }
  }
  
  func editLink(to newLink: String) -> String? {
    if let error = Link.checkLinkStringSize(link: newLink) {
      return error
    } else {
      try! Realm().write {
        self.link = newLink
      }
      return nil
    }
  }
  
  func editDescription(to newDescription: String) -> String? {
    if let error = Link.checkDescriptionStringSize(description: newDescription) {
      return error
    } else {
      try! Realm().write {
        self.linkDescription = newDescription
      }
      return nil
    }
  }
  
  func edit(newLink: String, newDescription: String) -> String? {
    if let error = Link.checkLinkStringSize(link: newLink) {
      return error
    } else if let error = Link.checkDescriptionStringSize(description: newDescription) {
      return error
    } else {
      try! Realm().write {
        self.link = newLink
        self.linkDescription = newDescription
      }
      return nil
    }
  }
  
  func toggleFavorite() {
    try! Realm().write {
      if self.isFavorite {
        self.isFavorite = false
      } else {
        self.isFavorite = true
      }
    }
  }
  
  func openURL() -> String? {
    guard let url = URL(string: link) else {
      return "InvalidUrlMessage".localized()
    }
    
    if !UIApplication.shared.canOpenURL(url) {
      return "InvalidUrlMessage".localized()
    }
    
    UIApplication.shared.open(url)
    
    return nil
  }
}

// MARK: - 계산
extension Link {
  static func checkLinkStringSize(link: String) -> String? {
    if link.count == 0 {
      return "LinkShortSizeErrorMessage".localized()
    } else {
      return nil
    }
  }
  
  static func checkDescriptionStringSize(description: String) -> String? {
    if description.count == 0 {
      return "DescriptionShortSizeErrorMessage".localized()
    } else if description.count > 100 {
      return "DescriptionLongSizeErrorMessage".localized()
    } else {
      return nil
    }
  }
}

extension Link: Identifiable {}
