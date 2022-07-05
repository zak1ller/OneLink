//
//  LinkRow.swift
//  OneLink
//
//  Created by Min-Su Kim on 2022/07/04.
//

import SwiftUI
import Toaster

struct LinkRow: View {
  @EnvironmentObject private var manager: Manager
  let link: Link
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        descriptionText
        Spacer()
        favoriteImage
      }
      .padding(.top, 16)
      .padding(.trailing, 16)
      
      Spacer().frame(height: 8)
      linkText
      Spacer().frame(height: 16)
    }
    .fixedSize(horizontal: false, vertical: true)
    .background(Color.secondaryBackground)
    .cornerRadius(16)
    .padding(.horizontal, 16)
    .padding(.vertical, 8)
  }
}

extension LinkRow {
  var linkText: some View {
    Text(link.link)
      .font(.system(size: 14, weight: .regular))
      .padding(.leading, 16)
      .padding(.trailing, 16)
      .lineLimit(1)
  }
  
  var descriptionText: some View {
    Text(link.linkDescription)
      .font(.system(size: 14, weight: .bold))
      .padding(.leading, 16)
      .padding(.trailing, 16)
  }
  
  var favoriteImage: some View {
    Image(systemName: "star.fill")
      .foregroundColor(link.isFavorite ? Color.orange : Color.disabled)
      .frame(width: 24, height: 24)
      .onTapGesture {
        UISelectionFeedbackGenerator().selectionChanged()
        toggleFavorite()
      }
  }
  
  func toggleFavorite() {
    link.toggleFavorite()
    manager.links = Link.getLinks()
    if link.isFavorite {
      Toast(text: "AddFavorateMessage".localized()).show() 
    }
  }
}
