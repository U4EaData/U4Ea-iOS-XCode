//
//  ActivitiesViewController.swift
//  u4ea
//
//  Created by Agustina Chaer on 24/8/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class ActivitiesCollectionViewController: UIViewController {
  
  // MARK: Properties
  
  var sizingCell: ActivityCollectionViewCell?
  weak var delegate: ActivitiesCollectionViewControllerDelegate?
  var selectedActivity: Activity?
  
  @IBOutlet weak var activityList: UICollectionView!
  
  // MARK: Life-cycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    activityList.contentInset = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 21)
    setupCollectionView()
  }
  
  //MARK: Stetup
  
  func setupCollectionView() {
    let cellNib = UINib(nibName: ActivityCollectionViewCell.reuseIdentifier, bundle: nil)
    sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as? ActivityCollectionViewCell
    activityList.register(cellNib, forCellWithReuseIdentifier: ActivityCollectionViewCell.reuseIdentifier)
  }
  
  // MARK: Actions
  
  @IBAction func closeTapped(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
}

//MARK: CollectionView Delegate

extension ActivitiesCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout { 
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return LocalDataManager.activities.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = activityList.dequeueReusableCell(withReuseIdentifier: ActivityCollectionViewCell.reuseIdentifier, for: indexPath) as? ActivityCollectionViewCell else {
      return UICollectionViewCell()
    }
    let activity = LocalDataManager.activities[indexPath.row]
    cell.setup(with: activity, selected: activity == selectedActivity)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let activity = LocalDataManager.activities[indexPath.row]
    sizingCell!.setup(with: activity, selected: activity == selectedActivity)
    return self.sizingCell!.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let currentCell = collectionView.cellForItem(at: indexPath) as? ActivityCollectionViewCell
    selectedActivity = currentCell!.activity
    delegate?.selectActivity(activity: currentCell!.activity)
    navigationController?.popViewController(animated: true)
    collectionView.deselectItem(at: indexPath, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: QuestionCollectionReusableView.reuseIdentifier, for: indexPath) as? QuestionCollectionReusableView else {
      return UICollectionReusableView()
    }
    return header
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return CGSize(width: activityList.frame.width, height: section == (LocalDataManager.activities.count - 1) ? 10 : 0)
  }
}

//MARK: Protocols

protocol ActivitiesCollectionViewControllerDelegate: class {
  func selectActivity(activity: Activity)
}
