//
//  Feeling.swift
//  u4ea
//
//  Created by TopTier on 8/22/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import SwiftyJSON

class Feeling {
  
  var name: String
  var chakra: String
  var frequency: Float
  var frequencyRange: String
  var shiftTo: String
  var shiftFrom: String
  var title: String
  var a: String
  var b: String
  var c: String
  
  init(name: String, chakra: String, frequency: Float, frequencyRange: String, shiftTo: String, shiftFrom: String, title: String, a: String, b: String, c: String) {
    self.name = name
    self.chakra = chakra
    self.frequency = frequency
    self.frequencyRange = frequencyRange
    self.shiftTo = shiftTo
    self.shiftFrom = shiftFrom
    self.title = title
    self.a = a
    self.b = b
    self.c = c
  }
  
  //MARK Parser
  class func parseFeelings(from json: JSON) -> [[Feeling]] {
    return json.arrayValue.map({feeling in feeling["feelings"].arrayValue.map({ Feeling(name: $0.stringValue, chakra: feeling["chakra"].stringValue, frequency: feeling["frequency"].floatValue, frequencyRange: feeling["frequency_range"].stringValue, shiftTo: feeling["shift_to"].stringValue, shiftFrom: feeling["shift_from"].stringValue, title: feeling["title"].stringValue, a: feeling["1a"].stringValue, b: feeling["1b"].stringValue, c: feeling["1c"].stringValue)})})
  }
}
