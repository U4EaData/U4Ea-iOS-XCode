//
//  GeneratingFrequencyViewController.swift
//  u4ea
//
//  Created by TopTier on 8/30/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class GeneratingFrequencyViewController: UIViewController {
  
  // MARK: Properties
  
  var feeling: Feeling?
  var boost: Boost?
  var activity: Activity?
  
  // MARK: Life-cycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(playFrequency), userInfo: nil, repeats: false)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goToPlayer", let vc = segue.destination as? PlayerViewController {
      vc.feeling = feeling
      vc.boost = boost
      vc.activity = activity
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    UIApplication.shared.statusBarStyle = .lightContent
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    UIApplication.shared.statusBarStyle = .default
    let statusBar: UIView = (UIApplication.shared.value(forKey: "statusBar") as? UIView)!
    statusBar.backgroundColor = .clear
  }
  
  //MARK: Actions
  
  func playFrequency() {
    performSegue(withIdentifier: "goToPlayer", sender: self)
  }
}
