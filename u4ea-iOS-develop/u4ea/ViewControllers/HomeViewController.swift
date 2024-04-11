//
//  HomeViewController.swift
//  u4ea
//
//  Created by Agustina Chaer on 21/8/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {

  // MARK: Properties
  var boost: Boost?
  var activity: Activity?
  var feeling: Feeling?
  let moodPlaceHolderText = "Select Mood"
  
  @IBOutlet weak var iWantToFeelMood: UILabel!
  @IBOutlet weak var andBoostMyMood: UILabel!
  @IBOutlet weak var whileIMood: UILabel!
  
  @IBOutlet weak var wave1View: UIView!
  @IBOutlet weak var wave2View: UIView!
  @IBOutlet weak var wave3View: UIView!
  
  @IBOutlet weak var feelView: UIView!
  @IBOutlet weak var boostView: UIView!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var playFrequencyLabel: UILabel!
  @IBOutlet weak var completeMoodLabel: UILabel!
  
  // MARK: Life-cycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print(error)
    }
    setupUI()
    NotificationCenter.default.addObserver(self, selector: #selector(loadWaves), name: .UIApplicationWillEnterForeground, object: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goToBoosts", let vc = segue.destination as? BoostsCollectionViewController {
      vc.delegate = self
      vc.selectedBoost = boost
    } else if segue.identifier == "goToActivities", let vc = segue.destination as? ActivitiesCollectionViewController {
      vc.delegate = self
      vc.selectedActivity = activity
    } else if let vc = segue.destination as? FeelingsListViewController {
      vc.delegate = self
      vc.feeling = self.feeling
    } else if let vc = segue.destination as? GeneratingFrequencyViewController {
      vc.feeling = feeling
      vc.boost = boost
      vc.activity = activity
    }
  }
  
  // MARK: Setup UI
  
  func setupUI() {
    self.navigationController?.isNavigationBarHidden = true

    loadWaves()
    playButton.setRoundBorders(playButton.frame.height/2)
    playButton.setImage(#imageLiteral(resourceName: "TriangleDeactive"), for: .disabled)
  }
  
  func togglePlayButton() {
    playButton.isEnabled = boost != nil && feeling != nil && activity != nil
    playButton.backgroundColor = playButton.isEnabled ? .white : .u4PlayDisabled
    playFrequencyLabel.isHidden = !playButton.isEnabled
    completeMoodLabel.isHidden = playButton.isEnabled
  }

  // MARK: Actions
  
  @IBAction func unwindToHomeViewController(segue: UIStoryboardSegue) {
    loadWaves()
  }
  
  func setFeeling(feeling: Feeling) {
    self.feeling = feeling
    iWantToFeelMood.text = feeling.name
    iWantToFeelMood.alpha = 1
    if let color = Chakra(rawValue: feeling.chakra.lowercased())?.color() {
      feelView.backgroundColor = color
      wave2View.backgroundColor = color
      loadWaves()
    }
    togglePlayButton()
  }
  
  func setBoost(boost: Boost) {
    self.boost = boost
    andBoostMyMood.text = boost.name
    andBoostMyMood.alpha = 1
    loadWaves()
    boostView.backgroundColor = boost.color
    wave3View.backgroundColor = boost.color
    togglePlayButton()
  }
  
  func setActivity(activity: Activity) {
    self.activity = activity
    whileIMood.text = activity.name
    whileIMood.alpha = 1
    loadWaves()
    togglePlayButton()
  }
  
  func loadWaves() {
    wave1View.wave(displacementFactor: 0, fillColor: self.feeling != nil ? (Chakra(rawValue: (self.feeling?.chakra.lowercased())!)?.color())! : .u4DefaultFeeling)
    wave2View.wave(displacementFactor: -0.5, fillColor: self.boost != nil ? self.boost!.color : .u4DefaultBoost)
    wave3View.wave(displacementFactor: 0, fillColor: .u4DefaultActivity)
  }
}

extension HomeViewController: FeelingsListViewControllerDelegate {
  func selectFeeling(feeling: Feeling) {
    setFeeling(feeling: feeling)
  }
}

extension HomeViewController: BoostsListViewControllerDelegate {
  func selectBoost(boost: Boost) {
    setBoost(boost: boost)
  }
}

extension HomeViewController: ActivitiesCollectionViewControllerDelegate {
  func selectActivity(activity: Activity) {
    setActivity(activity: activity)
  }
}
