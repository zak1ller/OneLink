//
//  StringExtension.swift
//  OneLink
//
//  Created by Min-Su Kim on 2022/07/02.
//

import Foundation

extension String {
  func localized(comment: String = "") -> String {
    return NSLocalizedString(self, comment: comment)
  }
}
