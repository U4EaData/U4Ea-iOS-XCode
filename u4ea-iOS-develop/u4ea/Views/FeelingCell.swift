//
//  FeelingCell.swift
//  u4ea
//
//  Created by TopTier on 8/23/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class FeelingCell: UICollectionViewCell {

  @IBOutlet weak var feelingLabel: UILabel!
  @IBOutlet weak var containerView: UIView!
  
  static let reuseIdentifier = "FeelingCell"
  var feeling: Feeling?

  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    containerView.setRoundBorders(containerView.frame.height/2)
  }
  
  func setup(feeling: Feeling, selected: Bool) {
    self.feeling = feeling
    feelingLabel.text = feeling.name
    isSelected = selected
    let color = Chakra(rawValue: feeling.chakra.lowercased())?.color()
    containerView.addBorder(color: color!, weight: 2)
    feelingLabel.textColor = isSelected ? .white : color
    containerView.backgroundColor = isSelected ? color : .white
  }
}
