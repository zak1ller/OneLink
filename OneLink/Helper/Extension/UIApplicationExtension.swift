//
//  UIApplicationExtension.swift
//  OneLink
//
//  Created by Min-Su Kim on 2022/07/05.
//

import UIKit

public extension UIApplication {
  func currentUIWindow() -> UIWindow? {
    let connectedScenes = UIApplication.shared.connectedScenes
      .filter({
        $0.activationState == .foregroundActive})
      .compactMap({$0 as? UIWindowScene})
    
    let window = connectedScenes.first?
      .windows
      .first { $0.isKeyWindow }
    
    return window
  }
}
