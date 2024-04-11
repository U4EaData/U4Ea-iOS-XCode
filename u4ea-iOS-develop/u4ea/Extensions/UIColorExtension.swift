//
//  UIColorExtension.swift
//  u4ea
//
//  Created by Agustina Chaer on 21/8/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

internal extension UIColor {
  static let u4Purple = UIColor(red: 147/255, green: 112/255, blue: 234/255, alpha: 1.0)
  static let u4Pink = UIColor(red: 248/255, green: 116/255, blue: 233/255, alpha: 1.0)
  static let u4DarkBlue = UIColor(red: 33/255, green: 51/255, blue: 89/255, alpha: 1.0)
  static let u4Crown = UIColor(red: 128/255, green: 85/255, blue: 228/255, alpha: 1.0)
  static let u4ThirdEye = UIColor(red: 74/255, green: 75/255, blue: 230/255, alpha: 1.0)
  static let u4Throat = UIColor(red: 85/255, green: 193/255, blue: 192/255, alpha: 1.0)
  static let u4Heart = UIColor(red: 0/255, green: 230/255, blue: 179/255, alpha: 1.0)
  static let u4SolarPlexus = UIColor(red: 234/255, green: 193/255, blue: 61/255, alpha: 1.0)
  static let u4Sacral = UIColor(red: 246/255, green: 150/255, blue: 31/255, alpha: 1.0)
  static let u4Root = UIColor(red: 246/255, green: 31/255, blue: 65/255, alpha: 1.0)
  static let u4DefaultFeeling = UIColor(red: 169/255, green: 172/255, blue: 180/255, alpha: 1.0)
  static let u4DefaultBoost = UIColor(red: 77/255, green: 87/255, blue: 115/255, alpha: 1.0)
  static let u4DefaultActivity = UIColor(red: 25/255, green: 37/255, blue: 71/255, alpha: 1.0)
  static let u4PlayDisabled = UIColor(red: 137/255, green: 143/255, blue: 156/255, alpha: 1.0)

  convenience init(hexString: String) {
    let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    let scanner = Scanner(string: hexString)
    
    if hexString.hasPrefix("#") {
      scanner.scanLocation = 1
    }
    
    var color: UInt32 = 0
    scanner.scanHexInt32(&color)
    
    let mask = 0x000000FF
    let r = Int(color >> 16) & mask
    let g = Int(color >> 8) & mask
    let b = Int(color) & mask
    
    let red   = CGFloat(r) / 255.0
    let green = CGFloat(g) / 255.0
    let blue  = CGFloat(b) / 255.0
    
    self.init(red:red, green:green, blue:blue, alpha:1)
  }
  
  func toHexString() -> String {
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    
    getRed(&r, green: &g, blue: &b, alpha: &a)
    
    let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
    
    return String(format:"#%06x", rgb)
  }
}
