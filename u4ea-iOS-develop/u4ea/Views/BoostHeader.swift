//
//  BoostHeader.swift
//  u4ea
//
//  Created by TopTier on 9/21/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class BoostHeader: UICollectionReusableView {

  @IBOutlet weak var shiftLabel: UILabel!
  @IBOutlet weak var frequencyLabel: UILabel!
  @IBOutlet weak var chakraIcon: UIImageView!
  
  static let reuseIdentifier = "BoostHeader"
  var boost: Boost?
  
  func loadHeader(boost: Boost) {
    self.boost = boost
    frequencyLabel.text = boost.frequency.uppercased()
    if boost.isChakra {
      let chakraValue = Chakra(rawValue: boost.c)
      chakraIcon.image = chakraValue?.boostIcon()
    } else {
      let healingValue = HealingBoost(rawValue: boost.a)
      chakraIcon.image = healingValue?.icon()
    }
    frequencyLabel.textColor = boost.color
    shiftLabel.textColor = boost.color
    let shiftFromText = "Shift From: \(boost.shiftFrom)\nShift To: \(boost.shiftTo)" as NSString
    let attributedString = NSMutableAttributedString(string: shiftFromText as String, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)])
    let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14.0)]
    attributedString.addAttributes(boldFontAttribute, range: shiftFromText.range(of: "Shift From:"))
    attributedString.addAttributes(boldFontAttribute, range: shiftFromText.range(of: "Shift To:"))
    shiftLabel.attributedText = attributedString
    shiftLabel.sizeToFit()
  }
  
  func preferredLayoutSizeFittingSize(targetSize: CGSize) -> CGSize {
    
    let originalFrame = self.frame
    let originalPreferredMaxLayoutWidth = self.shiftLabel.preferredMaxLayoutWidth
    
    var frame = self.frame
    frame.size = targetSize
    self.frame = frame
    
    self.setNeedsLayout()
    self.layoutIfNeeded()
    self.shiftLabel.preferredMaxLayoutWidth = self.shiftLabel.bounds.size.width
    
    let computedSize = self.systemLayoutSizeFitting(UILayoutFittingCompressedSize)

    let newSize = CGSize(width: targetSize.width, height: computedSize.height)
    
    self.frame = originalFrame
    self.shiftLabel.preferredMaxLayoutWidth = originalPreferredMaxLayoutWidth
    
    return newSize
  }
}
