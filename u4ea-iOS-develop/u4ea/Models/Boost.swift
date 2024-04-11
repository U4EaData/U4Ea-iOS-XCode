//
//  Boost.swift
//  u4ea
//
//  Created by Agustina Chaer on 24/8/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import SwiftyJSON

class Boost: NSObject {
  var id: Int
  var name: String
  var color: UIColor
  var isChakra: Bool
  var frequency: String
  var shiftFrom: String
  var shiftTo: String
  var a: String
  var c: String
  
  init(id: Int, name: String, color: String = "", isChakra: Bool, frequency: String, shiftFrom: String, shiftTo: String, a: String, c: String) {
    self.id = id
    self.name = name
    self.color = UIColor(hexString: color)
    self.isChakra = isChakra
    self.frequency = frequency
    self.shiftFrom = shiftFrom
    self.shiftTo = shiftTo
    self.a = a
    self.c = c
  }
  
  //MARK Parser
  class func parse(from json: JSON) -> Boost {
    return Boost(id:    json["id"].intValue,
                 name:  json["name"].stringValue,
                 color: json["color"].stringValue,
                 isChakra: json["is_chakra"].boolValue,
                 frequency: json["frequency"].stringValue,
                 shiftFrom: json["shift_from"].stringValue,
                 shiftTo: json["shift_to"].stringValue,
                 a: json["3a"].stringValue,
                 c: json["3c"].stringValue
    )
  }
  
  class func parseBoosts(from json: JSON) -> [Boost] {
    return json.arrayValue.map({ Boost.parse(from: $0) })
  }
}
