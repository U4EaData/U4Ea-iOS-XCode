//
//  NSMutableAttributedStringExtension.swift
//  u4ea
//
//  Created by Agustina Chaer on 31/8/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
  func colorForRange(color: UIColor, range: NSRange) {
    self.addAttribute(NSForegroundColorAttributeName,
                      value: color,
                      range: range)

  }
}
