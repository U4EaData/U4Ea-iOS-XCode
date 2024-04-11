//
//  UIViewExtension.swift
//  swift-base
//
//  Created by Juan Pablo Mazza on 9/9/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import Foundation
import UIKit
import BAFluidView

extension UIView {
  //MARK: Instance methods
  //Change the default values for params as you wish
  func addBorder(color: UIColor = UIColor.black, weight: CGFloat = 1.0) {
    layer.borderColor = color.cgColor
    layer.borderWidth = weight
  }
  
  func setRoundBorders(_ cornerRadius: CGFloat = 10.0) {
    clipsToBounds = true
    layer.cornerRadius = cornerRadius
  }
  
  func showSpinner(message: String = "Please Wait", comment: String = "") {
    if let spinner = AppDelegate.shared.spinner {
      spinner.label.text = message.localize(comment: comment)
      spinner.center = center
      spinner.willMove(toSuperview: self)
      addSubview(spinner)
      spinner.show(animated: true)
      spinner.didMoveToSuperview()
      UIApplication.shared.beginIgnoringInteractionEvents()
    }
  }
  
  func hideSpinner() {
    if let spinner = AppDelegate.shared.spinner {
      spinner.willMove(toSuperview: nil)
      spinner.hide(animated: true)
      spinner.didMoveToSuperview()
    }
    UIApplication.shared.endIgnoringInteractionEvents()
  }
  
  func wave(displacementFactor: CGFloat, fillColor: UIColor, elevation: CGFloat = 0.6) {
    for view in self.subviews {
      view.removeFromSuperview()
    }    
    let wave = BAFluidView(frame: CGRect(x: displacementFactor*frame.width, y: 0, width: frame.width*1.5, height: frame.height),
                                        maxAmplitude: Int32(frame.height*0.6), minAmplitude: 0, amplitudeIncrement: 1,
                                        startElevation: elevation as NSNumber)!
    wave.xDuration = 15
    wave.amplitudeDuration = 1
    wave.strokeColor = .clear
    wave.fillColor = fillColor
    wave.tintColor = .clear
    wave.keepStationary()
    
    self.addSubview(wave)
  }
}

extension Array where Element: UIView {
  func addBorder(color: UIColor = UIColor.black, weight: CGFloat = 1.0) {
    for view in self {
      view.addBorder(color: color, weight: weight)
    }
  }
  
  func roundBorders(cornerRadius: CGFloat = 10.0) {
    for view in self {
      view.setRoundBorders(cornerRadius)
    }
  }
}
