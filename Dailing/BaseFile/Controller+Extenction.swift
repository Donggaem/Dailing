//
//  Controller+Extenction.swift
//  Dailing
//
//  Created by 김동겸 on 2022/11/27.
//

import UIKit
import SnapKit
import Foundation

extension UIViewController {
  
  // MARK: UIWindow의 rootViewController를 변경하여 화면전환
  func changeRootViewController(_ viewControllerToPresent: UIViewController) {
    if let window = UIApplication.shared.windows.first {
      window.rootViewController = viewControllerToPresent
      UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
    } else {
      viewControllerToPresent.modalPresentationStyle = .overFullScreen
      self.present(viewControllerToPresent, animated: true, completion: nil)
    }
  }
}
