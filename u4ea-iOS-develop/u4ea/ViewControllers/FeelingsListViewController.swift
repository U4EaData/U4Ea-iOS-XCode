//
//  FeelingsListViewController.swift
//  u4ea
//
//  Created by TopTier on 8/22/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit
import SwiftyJSON

class FeelingsListViewController: UIViewController {
  
  // MARK: Properties
  
  @IBOutlet weak var scrollStackView: UIStackView!
  @IBOutlet weak var feelingsCollection: UICollectionView!
  @IBOutlet weak var chakraButtonsView: UIView!
  
  var feeling: Feeling?
  var sizingCell: FeelingCell?
  var sizingHeader: FeelingHeader?
  var topHeaders: [CGPoint] = []
  let selectedScrollButtonHeightExpanded: CGFloat = 31
  let selectedScrollButtonHeightCompressed: CGFloat = 7
  let scrollInset: CGFloat = -21
  weak var delegate: FeelingsListViewControllerDelegate?
  
  // MARK: Life-cycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    feelingsCollection.contentInset = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 21)
    let cellNib = UINib(nibName: FeelingCell.reuseIdentifier, bundle: nil)
    sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as? FeelingCell
    feelingsCollection.register(cellNib, forCellWithReuseIdentifier:FeelingCell.reuseIdentifier)
    feelingsCollection.register(UINib(nibName: FeelingHeader.reuseIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: FeelingHeader.reuseIdentifier)
    sizingHeader = (UINib(nibName: FeelingHeader.reuseIdentifier, bundle: nil).instantiate(withOwner: nil, options: nil) as NSArray).firstObject as? FeelingHeader
    feelingsCollection.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.old, context: nil)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if let observedObject = object as? UICollectionView, observedObject == feelingsCollection, topHeaders.isEmpty {
      for index in 0..<Chakra.all.count {
        if let attributes = feelingsCollection.layoutAttributesForSupplementaryElement(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(row: 0, section: index)) {
          topHeaders.append(CGPoint(x: scrollInset, y: attributes.frame.origin.y - feelingsCollection.contentInset.top))
        }
      }
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    self.feelingsCollection.removeObserver(self, forKeyPath: "contentSize")
  }
  
  // MARK: Setup UI
  
  func setupUI() {
    for view in scrollStackView.subviews {
      view.setRoundBorders(view.frame.width/2)
    }
  }
  
  // MARK: Actions
  
  @IBAction func tapScroll(_ sender: UITapGestureRecognizer) {
    let y = sender.location(in: chakraButtonsView).y
    let sectionHeight = chakraButtonsView.frame.height/7
    let indexPath = IndexPath(row: 0, section: Int(y/sectionHeight))
    if let attributes = feelingsCollection.layoutAttributesForSupplementaryElement(ofKind: UICollectionElementKindSectionHeader,
                                                                                   at: indexPath) {
      let topOfHeader = CGPoint(x: scrollInset, y: attributes.frame.origin.y - feelingsCollection.contentInset.top)
      feelingsCollection.setContentOffset(topOfHeader, animated: true)
    } else {
      feelingsCollection.scrollToItem(at: indexPath, at: .top, animated: true)
    }
  }
  
  @IBAction func close(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
}

//MARK: CollectionView Delegate

extension FeelingsListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return Chakra.all.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return LocalDataManager.feelings[section].count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = feelingsCollection.dequeueReusableCell(withReuseIdentifier: FeelingCell.reuseIdentifier, for: indexPath) as? FeelingCell else {
      return UICollectionViewCell()
    }
    let feeling = LocalDataManager.findFeeling(indexPath: indexPath)
    let selected = (self.feeling != nil) && (self.feeling!.name == feeling?.name) && (self.feeling!.frequency == feeling?.frequency)
    cell.setup(feeling: feeling!, selected: selected)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    self.configureCell(cell: self.sizingCell!, forIndexPath: indexPath)
    return self.sizingCell!.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let header = feelingsCollection.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: FeelingHeader.reuseIdentifier, for: indexPath) as? FeelingHeader else {
      return UICollectionReusableView()
    }
    header.loadHeader(feeling: LocalDataManager.feelings[indexPath.section][0])
    
    return header
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let currentCell = collectionView.cellForItem(at: indexPath) as? FeelingCell
    delegate?.selectFeeling(feeling: (currentCell?.feeling)!)
    navigationController?.popViewController(animated: true)
  }
  
  func configureCell(cell: FeelingCell, forIndexPath indexPath: IndexPath) {
    let feeling = LocalDataManager.findFeeling(indexPath: indexPath)
    let selected = (self.feeling != nil) && (self.feeling!.name == feeling?.name) && (self.feeling!.frequency == feeling?.frequency)
    cell.setup(feeling: feeling!, selected: selected)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let feeling = LocalDataManager.feelings[section][0]
    sizingHeader?.frame.size.width = feelingsCollection.frame.width
    sizingHeader?.bounds = CGRect(x: 0, y: 0, width: self.view.frame.width, height: sizingHeader!.bounds.height)
    sizingHeader?.loadHeader(feeling: feeling)
    sizingHeader?.setNeedsLayout()
    sizingHeader?.layoutIfNeeded()
    let targetSize = CGSize(width: feelingsCollection.bounds.size.width - 45, height: 0)
    let size = sizingHeader!.preferredLayoutSizeFittingSize(targetSize: targetSize)
    return CGSize(width: self.view.frame.width, height: size.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return CGSize(width: feelingsCollection.frame.width, height: section == (Chakra.all.count - 1) ? 10 : 0)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let y = scrollView.contentOffset.y
    var section = 0
    if topHeaders.count == Chakra.all.count {
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

protocol FeelingsListViewControllerDelegate: class {
  func selectFeeling(feeling: Feeling)
}
