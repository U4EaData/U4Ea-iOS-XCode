//
//  FeelingHeader.swift
//  u4ea
//
//  Created by TopTier on 8/23/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class FeelingHeader: UICollectionReusableView {
  
  @IBOutlet weak var chakraImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var frequencyLabel: UILabel!
  @IBOutlet weak var shiftFromLabel: UILabel!
  
  static let reuseIdentifier = "FeelingHeader"
  var feeling: Feeling?
  
  func loadHeader(feeling: Feeling) {
    self.feeling = feeling
    frequencyLabel.text = feeling.frequencyRange.uppercased()
    let chakraValue = Chakra(rawValue: feeling.chakra.lowercased())
    frequencyLabel.textColor = chakraValue?.color()
    titleLabel.text = feeling.title
    titleLabel.textColor = chakraValue?.color()
    shiftFromLabel.textColor = chakraValue?.color()
    let shiftFromText = "Shift From: \(feeling.shiftFrom)\nShift To: \(feeling.shiftTo)" as NSString
    let attributedString = NSMutableAttributedString(string: shiftFromText as String, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)])
    let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14.0)]
    attributedString.addAttributes(boldFontAttribute, range: shiftFromText.range(of: "Shift From:"))
    attributedString.addAttributes(boldFontAttribute, range: shiftFromText.range(of: "Shift To:"))
    shiftFromLabel.attributedText = attributedString
    shiftFromLabel.sizeToFit()
    chakraImageView.image = chakraValue?.icon()
  }
  
  func preferredLayoutSizeFittingSize(targetSize: CGSize) -> CGSize {
    
    let originalFrame = self.frame
    let originalPreferredMaxLayoutWidth = self.shiftFromLabel.preferredMaxLayoutWidth
    
    var frame = self.frame
    frame.size = targetSize
    self.frame = frame
    
    self.setNeedsLayout()
    self.layoutIfNeeded()
    self.shiftFromLabel.preferredMaxLayoutWidth = self.shiftFromLabel.bounds.size.width
    
    let computedSize = self.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    
    let newSize = CGSize(width: targetSize.width, height: computedSize.height)
    
    self.frame = originalFrame
    self.shiftFromLabel.preferredMaxLayoutWidth = originalPreferredMaxLayoutWidth
    
    return newSize
  }
}
