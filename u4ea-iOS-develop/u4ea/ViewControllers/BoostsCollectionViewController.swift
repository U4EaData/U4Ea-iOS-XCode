//
//  AndBoostMyViewController.swift
//  u4ea
//
//  Created by Agustina Chaer on 23/8/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class BoostsCollectionViewController: UIViewController {
  
  // MARK: Properties
  
  var sizingCell: BoostCollectionViewCell?
  var sizingHeader: BoostHeader?
  weak var delegate: BoostsListViewControllerDelegate?
  var selectedBoost: Boost?
  var topHeaders: [CGPoint] = []
  let selectedScrollButtonHeightExpanded: CGFloat = 31
  let selectedScrollButtonHeightCompressed: CGFloat = 7
  let scrollInset: CGFloat = -21
  
  @IBOutlet weak var scrollStackView: UIStackView!
  @IBOutlet weak var scrollButtonsView: UIView!
  @IBOutlet weak var boostsList: UICollectionView!
  
  // MARK: Life-cycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    boostsList.contentInset = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 21)
    setupUI()
    setupCollectionView()
  }
  
  //MARK - Setup
  
  func setupCollectionView() {
    let cellNib = UINib(nibName: BoostCollectionViewCell.reuseIdentifier, bundle: nil)
    sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as? BoostCollectionViewCell
    sizingHeader = (UINib(nibName: BoostHeader.reuseIdentifier, bundle: nil).instantiate(withOwner: nil, options: nil) as NSArray).firstObject as? BoostHeader
    boostsList.register(cellNib, forCellWithReuseIdentifier: BoostCollectionViewCell.reuseIdentifier)
    boostsList.register(UINib(nibName: BoostHeader.reuseIdentifier, bundle: nil),
                        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                        withReuseIdentifier: BoostHeader.reuseIdentifier)
    boostsList.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.old, context: nil)
  }
  
  func setupUI() {
    for view in scrollStackView.subviews {
      view.setRoundBorders(view.frame.width/2)
    }
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if let observedObject = object as? UICollectionView, observedObject == boostsList, topHeaders.isEmpty {
      for index in 0..<LocalDataManager.boosts.count {
        if let attributes = boostsList.layoutAttributesForSupplementaryElement(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(row: 0, section: index)) {
          topHeaders.append(CGPoint(x: scrollInset, y: attributes.frame.origin.y - boostsList.contentInset.top))
        }
      }
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    self.boostsList.removeObserver(self, forKeyPath: "contentSize")
  }
  
  // MARK: Actions
  
  @IBAction func onScrollBarTapped(_ sender: UIGestureRecognizer) {
    let y = sender.location(in: scrollButtonsView).y
    let sectionHeight = scrollButtonsView.frame.height/11
    let indexPath = IndexPath(row: 0, section: Int(y/sectionHeight))
    if let attributes = boostsList.layoutAttributesForSupplementaryElement(ofKind: UICollectionElementKindSectionHeader,
                                                                           at: indexPath) {
      let topOfHeader = CGPoint(x: scrollInset, y: attributes.frame.origin.y - boostsList.contentInset.top)
      boostsList.setContentOffset(topOfHeader, animated: true)
    } else {
      boostsList.scrollToItem(at: indexPath, at: .top, animated: true)
    }
  }
  
  @IBAction func closeTapped(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
}

//MARK: CollectionView Delegate

extension BoostsCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return LocalDataManager.boosts.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = boostsList.dequeueReusableCell(withReuseIdentifier: BoostCollectionViewCell.reuseIdentifier, for: indexPath) as? BoostCollectionViewCell else {
      return UICollectionViewCell()
    }
    let boost = LocalDataManager.boosts[indexPath.section]
    cell.setup(with: boost, selected: boost == selectedBoost)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let header = boostsList.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: BoostHeader.reuseIdentifier, for: indexPath) as? BoostHeader else {
      return UICollectionReusableView()
    }
    header.loadHeader(boost: LocalDataManager.boosts[indexPath.section])
    return header
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let boost = LocalDataManager.boosts[indexPath.section]
    sizingCell!.setup(with: boost, selected: boost == selectedBoost)
    return self.sizingCell!.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let currentCell = collectionView.cellForItem(at: indexPath) as? BoostCollectionViewCell
    selectedBoost = currentCell!.boost
    delegate?.selectBoost(boost: currentCell!.boost)
    navigationController?.popViewController(animated: true)
    collectionView.deselectItem(at: indexPath, animated: true)
  }
  
  func configureCell(cell: BoostCollectionViewCell, forIndexPath indexPath: IndexPath) {
    let selected = (self.selectedBoost != nil) && (self.selectedBoost!.name == LocalDataManager.boosts[indexPath.section].name)
    cell.setup(with: LocalDataManager.boosts[indexPath.section], selected: selected)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let boost = LocalDataManager.boosts[section]
    sizingHeader?.frame.size.width = boostsList.frame.width
    sizingHeader?.bounds = CGRect(x: 0, y: 0, width: self.view.frame.width, height: sizingHeader!.bounds.height)
    sizingHeader?.loadHeader(boost: boost)
    sizingHeader?.setNeedsLayout()
    sizingHeader?.layoutIfNeeded()
    let targetSize = CGSize(width: boostsList.bounds.size.width - 45, height: 0)
    let size = sizingHeader!.preferredLayoutSizeFittingSize(targetSize: targetSize)
    return CGSize(width: self.view.frame.width, height: size.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return CGSize(width: boostsList.frame.width, height: section == (LocalDataManager.boosts.count - 1) ? 10 : 0)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let y = scrollView.contentOffset.y
    var section = 0
    if topHeaders.count == LocalDataManager.boosts.count {
      for index in 1..<topHeaders.count {
        if index != (topHeaders.count - 1) {
          if y >= topHeaders[index].y && y < topHeaders[index + 1].y {
            section = index
          }
        } else if y >= topHeaders[index].y {
          section = index
        }
      }
    }
    for (index, view) in scrollStackView.subviews.enumerated() {
      for constraint in view.constraints where constraint.firstAttribute == .height {
        constraint.constant = index == section ? selectedScrollButtonHeightExpanded : selectedScrollButtonHeightCompressed
      }
    }
  }
}

//MARK: Protocols

protocol BoostsListViewControllerDelegate: class {
  func selectBoost(boost: Boost)
}
