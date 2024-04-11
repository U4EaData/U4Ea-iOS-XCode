//
//  FlowLayout.swift
//  u4ea
//
//  Created by Agustina Chaer on 24/8/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

class FlowLayout: UICollectionViewFlowLayout {
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let attributes = super.layoutAttributesForElements(in: rect)
    
    var leftMargin = sectionInset.left
    var prevMaxY: CGFloat = -1.0
    
    attributes?.forEach { layoutAttribute in

      if layoutAttribute.representedElementCategory == .cell {
        if layoutAttribute.frame.origin.y >= prevMaxY {
          leftMargin = sectionInset.left
        }
        prevMaxY = layoutAttribute.frame.maxY
        
        layoutAttribute.frame.origin.x = leftMargin
        
        leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing

      }
    }
    return attributes
  }
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
}
