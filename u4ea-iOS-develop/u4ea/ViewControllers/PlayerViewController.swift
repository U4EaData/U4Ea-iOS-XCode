//
//  PlayerViewController.swift
//  u4ea
//
//  Created by Agustina Chaer on 30/8/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit
import AVFoundation
import FBSDKShareKit
import TwitterKit
import Branch

class PlayerViewController: UIViewController {

  // MARK: Properties
  var feeling: Feeling?
  var boost: Boost?
  var activity: Activity?
  
  var beatFrequency: Float?
  var baseFrequency: Float?
  
  var counter = 0.0
  var timer = Timer()
  var timerStr: String?
  
  var shouldAskFeedback = false
  
  let binauralBeat = BinauralBeat()
  
  var statusBarView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIApplication.shared.statusBarFrame.height))
  
  let imageSeparatorHeight = CGFloat(32)
  
  @IBOutlet weak var volumeSlider: UISlider!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var infoSectionView: UIView!
  @IBOutlet weak var animationSectionHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var waveView: UIView!
  @IBOutlet weak var mainDescriptionLabel: UILabel!
  @IBOutlet weak var frequencyLabel: UILabel!
  
  @IBOutlet weak var controlsButton: UIButton!
  @IBOutlet weak var playPauseButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  
  @IBOutlet weak var descriptionLabel: UILabel!

  @IBOutlet weak var shareButton: UIButton!
  
  // MARK: Life-cycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    setupData()
    setupPlayer()
    registerForNotifications()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    UIApplication.shared.statusBarStyle = .lightContent
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    UIApplication.shared.statusBarStyle = .default
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    if segue.identifier == "goToFeedback", let vc = segue.destination as? FeedbackViewController {
      vc.feeling = feeling
      vc.boost = boost
      vc.activity = activity
      vc.timeListened = timerStr
    } else if segue.identifier == "unwindFromPlayerToHome" {
      binauralBeat.stop()
    }
  }
  
  //MARK: Setup
  
  func setupUI() {
    baseFrequency = feeling?.frequency
    beatFrequency = activity?.frequencies[boost!.id]
    animationSectionHeightConstraint.constant = UIScreen.main.bounds.height + imageSeparatorHeight
    controlsButton.setRoundBorders(controlsButton.frame.width/2)
    statusBarView.backgroundColor = .white
    self.view.addSubview(statusBarView)
    statusBarView.isHidden = true
    volumeSlider.setValue(UserDefaults.standard.float(forKey: "u4eaVolume"), animated: true)
    if #available(iOS 11.0, *) {
      scrollView.contentInsetAdjustmentBehavior = .never
    } else {
      automaticallyAdjustsScrollViewInsets = false
    }
    let wave = SwiftyWaveView(frame: CGRect(x: 0, y: waveView.frame.height/2, width: self.view.frame.width, height: 100))
    let wave2 = SwiftyWaveView(frame: CGRect(x: 0, y: (waveView.frame.height/2 + 1), width: self.view.frame.width, height: 100))
    wave.frequency = beatFrequency!
    wave2.amplitude = 0.4
    wave2.frequency = baseFrequency!
    let chakraColor = Chakra(rawValue: feeling!.chakra.lowercased())?.color() ?? .black
    wave.color = boost!.color
    wave2.color = chakraColor    
    waveView.addSubview(wave2)
    waveView.addSubview(wave)
    wave2.start()
    wave.start()
  }
  
  func setupData() {
    let mainDescriptionText = "I want to feel \(feeling!.name)\n and boost my \(boost!.name)\n while I \(activity!.name)" as NSString
    mainDescriptionText.range(of: feeling!.name)
    let mainDescriptionAttributedText = NSMutableAttributedString(
      string: mainDescriptionText as String,
      attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: 600)])
    
    let chakraColor = Chakra(rawValue: feeling!.chakra.lowercased())?.color() ?? .black
    mainDescriptionAttributedText.colorForRange(color: chakraColor, range:mainDescriptionText.range(of: feeling!.name))
    mainDescriptionAttributedText.colorForRange(color: boost!.color, range:mainDescriptionText.range(of: boost!.name))
    mainDescriptionAttributedText.colorForRange(color: .u4DarkBlue, range:mainDescriptionText.range(of: activity!.name))
    
    frequencyLabel.text = "\((baseFrequency! * 1000).rounded() / 1000)Hz x \((beatFrequency! * 1000).rounded() / 1000)Hz"
    
    mainDescriptionLabel.attributedText = mainDescriptionAttributedText
    
    let paragraph1 = "Music has the ability to impact us physically and emotionally. Such is its magic. U4Ea puts the benefits of music’s sounds and frequencies in your hands. "
    let paragraph2 = "Binaural Beats are the rhythmic pulses you hear when you have two different tones within a small range playing in each ear.\n\n"
    let paragraph3 = "Bass tones (frequencies between 60 and 30 Hz) interact with your deeper consciousness Gamma state. "
    let paragraph4 = "When experienced with peak awareness and intelligence they enable greater insight and information processing.\n\n"
    let paragraph5 = "Octaves for the note '\(feeling!.a)' help you address the \(feeling!.b), according to the Solfeggio scale. "
    let paragraph6 = "Mindfulness practitioners transmute negative emotions like \(feeling!.c) by focusing on the \(feeling!.chakra.lowercased()) chakra during various forms of meditation.\n\n"
    let paragraph7 = "\(activity!.a) brainwave patterns take place between \(activity!.b) and are most active when people \(activity!.c).\n\n"
    let paragraph8 = "Boosting your \(boost!.a) in \(activity!.a.lowercased()) uses the \(boost!.c) chakra energy to create a \(activity!.d) state of mind."
    
    let descriptionAttributedText = NSMutableAttributedString(
      string: paragraph1 + paragraph2 + paragraph3 + paragraph4 + paragraph5 + paragraph6 + paragraph7 + paragraph8 as String,
      attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 10
    descriptionAttributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, descriptionAttributedText.length))
    descriptionLabel.attributedText = descriptionAttributedText
  }
  
  func setupPlayer() {
    binauralBeat.baseFrequency = baseFrequency!
    binauralBeat.beatFrequency = beatFrequency!
    binauralBeat.setVolume(volumeSlider.value)
    binauralBeat.play()
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
  }
  
  func registerForNotifications() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleInterruption),
                                           name: .AVAudioSessionInterruption,
                                           object: AVAudioSession.sharedInstance())
  }
  
  func handleInterruption(_ notification: Notification) {
    guard let info = notification.userInfo,
      let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
      let type = AVAudioSessionInterruptionType(rawValue: typeValue) else {
        return
    }
    if type == .began {
      timer.invalidate()
      playPauseButton.setImage(UIImage(named: "play"), for: .normal)
      playPauseButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
      binauralBeat.stop()
    } else if type == .ended {
      guard let optionsValue =
        info[AVAudioSessionInterruptionOptionKey] as? UInt else {
          return
      }
      let options = AVAudioSessionInterruptionOptions(rawValue: optionsValue)
      if options.contains(.shouldResume) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        playPauseButton.setImage(UIImage(named: "Pause Beat"), for: .normal)
        playPauseButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        binauralBeat.play()
      }
    }
  }
  
  // MARK: Actions
  
  @IBAction func controlsButtonTapped(_ sender: Any) {
    scrollView.setContentOffset(
      infoSectionView.frame.origin,
      animated: true)
  }
  
  @IBAction func volumeChanged(_ sender: UISlider) {
    binauralBeat.setVolume(sender.value)
    UserDefaults.standard.set(sender.value, forKey: "u4eaVolume")
  }
  
  @IBAction func playPauseTapped(_ sender: Any) {
    if binauralBeat.playing {
      timer.invalidate()
    } else {
      timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    playPauseButton.setImage(UIImage(named: binauralBeat.playing ? "play" : "Pause Beat"), for: .normal)
    playPauseButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: binauralBeat.playing ? 3 : 0, bottom: 0, right: 0)
    binauralBeat.playing ? (binauralBeat.stop()) : (binauralBeat.play())
  }
  
  @IBAction func cancelTapped(_ sender: Any) {
    binauralBeat.stop()
    timer.invalidate()
    parseTimerToString()
    performSegue(withIdentifier: shouldAskFeedback ? "goToFeedback" : "unwindFromPlayerToHome", sender: self)
  }
  
  @IBAction func shareTapped(_ sender: Any) {
    let alert = UIAlertController(title: "Share", message: "Share the beat that you are listening", preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
    
    let branchUniversalObject: BranchUniversalObject = BranchUniversalObject(canonicalIdentifier: "combo")
    branchUniversalObject.title = "Combo"
    branchUniversalObject.contentDescription = "U4Ea beat combo"
    
    branchUniversalObject.addMetadataKey("feeling", value: "\(feeling!.name)")
    branchUniversalObject.addMetadataKey("boost", value: "\(boost!.name)")
    branchUniversalObject.addMetadataKey("activity", value: "\(activity!.name)")
    
    let linkProperties: BranchLinkProperties = BranchLinkProperties()
    linkProperties.channel = "link"
    linkProperties.feature = "sharing"
    
    branchUniversalObject.getShortUrl(with: linkProperties) { (url, error) in
      if error == nil {
        let facebookAction = UIAlertAction(title: "Share on Facebook", style: .default) { _ in
          let content = FBSDKShareLinkContent()
          content.contentURL = URL(string: url!)
          content.quote = "Listen to my combo on U4Ea"
          content.hashtag = FBSDKHashtag(string: "#U4Ea")
          FBSDKShareDialog.show(from: self, with: content, delegate: nil)
        }
        let twitterAction = UIAlertAction(title: "Share on Twitter", style: .default) { _ in
          if (Twitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
            let composer = TWTRComposerViewController.init(initialText: "Listen to my combo on #U4Ea \(url!)", image: nil, videoURL: nil)
            self.present(composer, animated: true, completion: nil)
          } else {
            Twitter.sharedInstance().logIn { session, _ in
              if session != nil {
                let composer = TWTRComposerViewController.init(initialText: "Listen to my combo on #U4Ea \(url!)", image: nil, videoURL: nil)
                self.present(composer, animated: true, completion: nil)
              } else {
                let alert = UIAlertController(title: "No Twitter Accounts Available", message: "You must log in before presenting a composer.", preferredStyle: .alert)
                self.present(alert, animated: false, completion: nil)
              }
            }
          }
        }
        let copyAction = UIAlertAction(title: "Copy link", style: .default) { _ in
          UIPasteboard.general.string = url!
          self.showMessage(title: "Success", message: "Link copied to pasteboard")
        }
        
        if UIApplication.shared.canOpenURL(URL(string: "fb://")!) {
          alert.addAction(facebookAction)
        }
        if UIApplication.shared.canOpenURL(URL(string: "twitter://")!) {
          alert.addAction(twitterAction)
        }
        alert.addAction(copyAction)
      }
    }

    self.present(alert, animated: true, completion: nil)
  }
  
  func updateTimer() {
    counter += 1
  }
  
  func parseTimerToString() {
    var cnt = counter
    
    let hours = floor(cnt/3600)
    cnt -= hours * 3600
    let minutes = floor(cnt/60)
    cnt -= minutes * 60
    let seconds = cnt
    
    shouldAskFeedback = !((hours == 0.0)&&(minutes == 0.0)&&(seconds < 30.0))
    
    timerStr = "\(String(format: "%02.0f", hours)):\(String(format: "%02.0f", minutes)):\(String(format: "%02.0f", seconds))"
  }
}

//MARK: UIScrollViewDelegate

extension PlayerViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    UIApplication.shared.statusBarStyle = scrollView.contentOffset.y >= infoSectionView.frame.origin.y ? .default : .lightContent
    statusBarView.isHidden = scrollView.contentOffset.y < infoSectionView.frame.origin.y
    view.backgroundColor = scrollView.contentOffset.y < infoSectionView.frame.origin.y ? .white : .clear
  }
}
