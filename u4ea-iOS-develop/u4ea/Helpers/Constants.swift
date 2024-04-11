//
//  Constants.swift
//  swift-base
//
//  Created by German Lopez on 3/29/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

//Add global constants here

public enum Chakra: String {
  case crown
  case thirdEye = "3rd eye"
  case throat
  case heart
  case solarPlexus = "solar plexus"
  case sacral
  case root
  
  static let all: [Chakra] = [.crown, .thirdEye, .throat, .heart, .solarPlexus, .sacral, .root]
  
  func color() -> UIColor {
    switch self {
    case .crown:
      return .u4Crown
    case .thirdEye:
      return .u4ThirdEye
    case .throat:
      return .u4Throat
    case .heart:
      return .u4Heart
    case .solarPlexus:
      return .u4SolarPlexus
    case .sacral:
      return .u4Sacral
    case .root:
      return .u4Root
    }
  }
  
  func icon() -> UIImage {
    switch self {
    case .crown:
      return UIImage(named: "Group 7")!
    case .thirdEye:
      return UIImage(named: "Group 8")!
    case .throat:
      return UIImage(named: "Group 5")!
    case .heart:
      return UIImage(named: "Group 4")!
    case .solarPlexus:
      return UIImage(named: "Group 3")!
    case .sacral:
      return UIImage(named: "Group 2")!
    case .root:
      return UIImage(named: "Group")!
    }
  }
  
  func boostIcon() -> UIImage {
    switch self {
    case .crown:
      return UIImage(named: "Boost 7")!
    case .thirdEye:
      return UIImage(named: "Boost 8")!
    case .throat:
      return UIImage(named: "Boost 5")!
    case .heart:
      return UIImage(named: "Boost 4")!
    case .solarPlexus:
      return UIImage(named: "Boost 3")!
    case .sacral:
      return UIImage(named: "Boost 2")!
    case .root:
      return UIImage(named: "Boost")!
    }
  }
}

public enum HealingBoost: String {
  case painRelief = "pain relief"
  case healing
  case vigor
  case recovery
  
  func icon() -> UIImage {
    switch self {
    case .painRelief:
      return UIImage(named: "Group 13")!
    case .healing:
      return UIImage(named: "Group 12")!
    case .vigor:
      return UIImage(named: "Group 10")!
    case .recovery:
      return UIImage(named: "Group 11")!
    }
  }
}

