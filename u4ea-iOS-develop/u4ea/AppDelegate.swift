//
//  AppDelegate.swift
//  swift-base
//
//  Created by TopTier labs on 15/2/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import IQKeyboardManagerSwift
import MBProgressHUD
import Flurry_iOS_SDK
import AVFoundation
import TwitterKit
import Branch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  static let shared: AppDelegate = {
    guard let appD = UIApplication.shared.delegate as? AppDelegate else {
      return AppDelegate()
    }
    return appD
  }()
  var window: UIWindow?
  var spinner: MBProgressHUD!
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    // -Flurry
    Flurry.startSession(ConfigurationManager.getValue(for: "FlurryKey"), with: FlurrySessionBuilder
      .init()
      .withCrashReporting(true)
      .withLogLevel(FlurryLogLevelAll))

    IQKeyboardManager.sharedManager().enable = true
    spinner = UIHelper.initSpinner()
    LocalDataManager.parseJsonData()
    
    // -Twitter
    Twitter.sharedInstance().start(withConsumerKey: ConfigurationManager.getValue(for: "TwitterConsumerKey") ?? "", consumerSecret: ConfigurationManager.getValue(for: "TwitterConsumerSecret") ?? "")
    
    UserDefaults.standard.set(AVAudioSession.sharedInstance().outputVolume, forKey: "u4eaVolume")
    
    let branch: Branch = Branch.getInstance()
    branch.initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: {params, error in
      if error == nil {
        if let feelingName = params?["feeling"] as? String, let boostName = params?["boost"] as? String, let activityName = params?["activity"] as? String {
          if let nvc = self.window!.rootViewController as? UINavigationController {
            if let pvc = nvc.presentedViewController as? PlayerViewController {
              pvc.performSegue(withIdentifier: "unwindFromPlayerToHome", sender: pvc)
            } else if let fvc = nvc.presentedViewController as? FeedbackViewController {
              fvc.performSegue(withIdentifier: "unwindFromFeedbackToHome", sender: fvc)
            } else {
              nvc.popToRootViewController(animated: true)
            }
            if let vc = nvc.viewControllers.first as? HomeViewController {
              if let feeling = LocalDataManager.findFeeling(name: feelingName), let boost = LocalDataManager.findBoost(name: boostName),
                let activity = LocalDataManager.findActivity(name: activityName) {
                vc.setFeeling(feeling: feeling)
                vc.setBoost(boost: boost)
                vc.setActivity(activity: activity)
              }
            }
          }
        }
      }
    })
    return true
  }
  
  // Respond to URI scheme links
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    let isBranchHandled = Branch.getInstance().application(app, open: url, options: options)
    if !isBranchHandled {
      Twitter.sharedInstance().application(app, open: url, options: options)
    }
    return true
  }
  
  // Respond to Universal Links
  func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
    Branch.getInstance().continue(userActivity)

    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when 
    // the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
}
