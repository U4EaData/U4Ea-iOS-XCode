//
//  ActivityCollectionViewCell.swift
//  u4ea
//
//  Created by Agustina Chaer on 24/8/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class ActivityCollectionViewCell: UICollectionViewCell {
  
  // MARK: Properties
  static var reuseIdentifier = "ActivityCollectionViewCell"
  var activity: Activity!
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var nameLabel: UILabel!

  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    containerView.setRoundBorders(containerView.frame.height/2)
  }
  
  func setup(with activity: Activity, selected: Bool) {
    self.activity = activity
    nameLabel.text = activity.name
    isSelected = selected
    setColor()
    containerView.addBorder(color: activity.color, weight: 2)
  }
  
  func setColor() {
    nameLabel.textColor = isSelected ? .white : activity.color
    containerView.backgroundColor = isSelected ? activity.color : .white
  }
}
