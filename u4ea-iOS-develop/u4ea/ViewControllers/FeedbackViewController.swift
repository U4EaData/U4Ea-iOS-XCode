//
//  FeedbackViewController.swift
//  u4ea
//
//  Created by Agustina Chaer on 5/9/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class FeedbackViewController: UIViewController {
  
  // MARK: Properties
  
  var timeListened: String?
  var feeling: Feeling?
  var boost: Boost?
  var activity: Activity?
  
  var like = true
  
  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var dislikeButton: UIButton!
  @IBOutlet weak var likeButton: UIButton!
  @IBOutlet weak var mainDescriptionLabel: UILabel!
  @IBOutlet weak var frequencyLabel: UILabel!
  @IBOutlet weak var frequencyView: UIView!
  
  // MARK: Life-cycle methods
  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
    setupData()
  }
  
  //MARK: Setup
  
  func setupUI() {
    dislikeButton.setRoundBorders(dislikeButton.frame.width/2)
    likeButton.setRoundBorders(likeButton.frame.width/2)
    frequencyView.setRoundBorders(8)
    
    let mainDescriptionText = "I want to feel \(feeling!.name)\n and boost my \(boost!.name)\n while I \(activity!.name)" as NSString
    mainDescriptionText.range(of: feeling!.name)
    let mainDescriptionAttributedText = NSMutableAttributedString(
      string: mainDescriptionText as String,
      attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 21, weight: 600)])
    
    let chakraColor = Chakra(rawValue: feeling!.chakra.lowercased())?.color() ?? .black
    mainDescriptionAttributedText.colorForRange(color: chakraColor, range:mainDescriptionText.range(of: feeling!.name))
    mainDescriptionAttributedText.colorForRange(color: boost!.color, range:mainDescriptionText.range(of: boost!.name))
    mainDescriptionAttributedText.colorForRange(color: .u4DarkBlue, range:mainDescriptionText.range(of: activity!.name))
    
    let baseFrequency = feeling?.frequency
    let beatFrequency = activity?.frequencies[boost!.id]
    frequencyLabel.text = "\((baseFrequency! * 1000).rounded() / 1000)Hz x \((beatFrequency! * 1000).rounded() / 1000)Hz"
    
    mainDescriptionLabel.attributedText = mainDescriptionAttributedText
  }
  
  func setupData() {
    timerLabel.text = timeListened
  }
  
  // MARK: Actions
  @IBAction func dislikeTapped(_ sender: Any) {
    like = false
    sendFeedback()
  }
  
  @IBAction func likeTapped(_ sender: Any) {
    sendFeedback()
  }
  
  func sendFeedback() {
    let feedback = like ? "Positive" : "Negative"
    let params = ["I Want To Feel": feeling?.name, "And Boost My": boost?.name, "While I": activity?.name, "Feedback": feedback, "Beat Duration": timeListened]
    Flurry.logEvent("Feedback", withParameters: params)
    performSegue(withIdentifier: "unwindFromFeedbackToHome", sender: self)
  }
  
}
