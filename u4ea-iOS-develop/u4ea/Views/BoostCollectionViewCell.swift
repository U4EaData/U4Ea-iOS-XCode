//
//  BostCollectionViewCell.swift
//  u4ea
//
//  Created by Agustina Chaer on 23/8/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class BoostCollectionViewCell: UICollectionViewCell {
  
  // MARK: Properties
  static var reuseIdentifier = "BoostCollectionViewCell"
  var boost: Boost!
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    containerView.setRoundBorders(containerView.frame.height/2)
  }
  
  func setup(with boost: Boost, selected: Bool) {
    self.boost = boost
    nameLabel.text = boost.name
    isSelected = selected
    setColor()
    containerView.addBorder(color: boost.color, weight: 2)
  }
  
  func setColor() {
    nameLabel.textColor = isSelected ? .white : boost.color
    containerView.backgroundColor = isSelected ? boost.color : .white
  }
}
