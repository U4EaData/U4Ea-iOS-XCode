//
//  LocalDataManager.swift
//  u4ea
//
//  Created by TopTier on 8/21/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import SwiftyJSON

class LocalDataManager {
  
  static var feelings: [[Feeling]] = []
  static var boosts: [Boost] = []
  static var activities: [Activity] = []
  
  class func parseJsonData() {
    do {
      if let file = Bundle.main.url(forResource: "data", withExtension: "json") {
        let data = try Data(contentsOf: file)
        let dic = try JSONSerialization.jsonObject(with: data, options: [])
        if let object = dic as? [String: Any] {
          let json = JSON(object)
          activities = Activity.parseActivities(from: json["activities"])
          boosts = Boost.parseBoosts(from: json["boosts"])
          feelings = Feeling.parseFeelings(from: json["feelings"])
        }
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  class func findFeeling(name: String) -> Feeling? {
    for chakra in feelings {
      for feeling in chakra where feeling.name == name {
        return feeling
      }
    }
    return nil
  }
  
  class func findFeeling(indexPath: IndexPath) -> Feeling? {
    return feelings[indexPath.section][indexPath.item]
  }
  
  class func findBoost(name: String) -> Boost? {
    for boost in boosts where boost.name == name {
      return boost
    }
    return nil
  }
  
  class func findActivity(name: String) -> Activity? {
    for activity in activities where activity.name == name {
      return activity
    }
    return nil
  }
}
