//
//  Activity.swift
//  u4ea
//
//  Created by Agustina Chaer on 24/8/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import SwiftyJSON

class Activity: NSObject {
  var name: String
  var frequencies: [Float]
  var color: UIColor
  var a: String
  var b: String
  var c: String
  var d: String
  
  init(name: String, frequencies: [Float] = [], color: String = "", a: String, b: String, c: String, d: String) {
    self.name = name
    self.frequencies = frequencies
    self.color = UIColor(hexString: color)
    self.a = a
    self.b = b
    self.c = c
    self.d = d
  }
  
  //MARK Parser
  class func parse(from json: JSON) -> Activity {
    return Activity(name: json["name"].stringValue,
                    frequencies: json["frequencies"].arrayValue.map({$0.floatValue}),
                    color: json["color"].stringValue,
                    a: json["2a"].stringValue,
                    b: json["2b"].stringValue,
                    c: json["2c"].stringValue,
                    d: json["3d"].stringValue
    )
  }
  
  class func parseActivities(from json: JSON) -> [Activity] {
    return json.arrayValue.map({ Activity.parse(from: $0) })
  }
}
