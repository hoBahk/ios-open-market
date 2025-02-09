//
//  LoadingIndicator.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/17.
//

import UIKit

class LoadingIndicator {
  static func showLoading() {
    DispatchQueue.main.async {
      guard let window = UIApplication.shared.windows.last else {
        return
      }
      let loadingIndicatorView: UIActivityIndicatorView
        
      if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView {
        loadingIndicatorView = existedView
      } else {
        loadingIndicatorView = UIActivityIndicatorView(style: .large)
        loadingIndicatorView.frame = window.frame
        window.addSubview(loadingIndicatorView)
      }
      loadingIndicatorView.startAnimating()
    }
  }
  
  static func hideLoading() {
    DispatchQueue.main.async {
      guard let window = UIApplication.shared.windows.last else {
        return
      }
      window.subviews
            .filter { $0 is UIActivityIndicatorView }
            .forEach { $0.removeFromSuperview() }
    }
  }
}
