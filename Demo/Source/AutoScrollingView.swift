//
//  AutoScrollingView.swift
//
//  Created by George on 2016-06-23.
//  Copyright © 2016 George Kye. All rights reserved.
//

import Foundation
import UIKit

private class ASViewCell: UICollectionViewCell{
  
  init() {
    super.init(frame: CGRectZero)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

//MARK: Protocols

public protocol AutoScrollingViewDataSource: class{
  func setAutoScrollingViewDataSource(autoScrollingView: AutoScrollingView)->[UIView]
}

@objc public protocol AutoScrollingViewDelegate: class {
  optional func autoScrollingView(autoScrollingView: AutoScrollingView, didAutoScroll index: Int)
  optional func autoScrollingView(autoScrollingView: AutoScrollingView, didSelectItem index: Int)
  optional func autoScrollingView(autoScrollingView: AutoScrollingView, didChangeStatus status: ScrollingState)
}

@objc public enum ScrollingState: Int {
  case  NotPaused, Paused
}


@IBDesignable public class AutoScrollingView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate{
  
  public weak var delegate: AutoScrollingViewDelegate?
  
  public weak var dataSource: AutoScrollingViewDataSource? {
    didSet {
      if let views = dataSource?.setAutoScrollingViewDataSource(self){
        dataSourceViews = views
        collectionView.reloadData()
      }
    }
  }
  
  //MARK: private
  private var dataSourceViews = [UIView]()
  
  private var timer = NSTimer()
  private var scrollTimer: NSTimer!
  private var currentIndex: Int = 0
  private var timerPaused: Bool = false
  

  //MARK: public
  public var timerInterval: Double = 2 {
    didSet{
      setupTimer()
      if timerPaused {
        self.pauseScrolling()
      }else { self.startScrolling() }
    }
  }
  
  
  lazy var collectionView: UICollectionView = {
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.itemSize = self.frame.size
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .Horizontal
    let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.registerClass(ASViewCell.self, forCellWithReuseIdentifier: "ASViewCell")
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.pagingEnabled = true
    return collectionView
  }()
  
  private func initialize() {
    collectionView.frame = self.frame
    collectionView.removeFromSuperview()
    self.addSubview(self.collectionView)
    setupTimer()
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.initialize()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  //MARK: AutoScroll (NSTimer)
  
  @objc private func autoScrollView(){
    print("index is \(currentIndex)")
    let indexPath = NSIndexPath(forRow: currentIndex, inSection: 0)
    collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
    delegate?.autoScrollingView?(self, didAutoScroll: currentIndex)
    currentIndex += 1
    if currentIndex == dataSourceViews.count{
      currentIndex = 0
    }
  }
  
  private func setupTimer(){
    timer.invalidate()
    timer = NSTimer.scheduledTimerWithTimeInterval(timerInterval, target: self, selector: #selector(self.autoScrollView), userInfo: nil, repeats: true)
  }
  
  public func pauseScrolling(){
    timer.invalidate()
    delegate?.autoScrollingView?(self, didChangeStatus: .Paused)
  }
  
  public func startScrolling(){
    setupTimer()
    delegate?.autoScrollingView?(self, didChangeStatus: .NotPaused)
  }
  
  
  //MARK: CollectionView DataSource
  
  public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSourceViews.count
  }
  
  public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ASViewCell", forIndexPath: indexPath) as! ASViewCell
    let view = dataSourceViews[indexPath.row]
    cell.contentView.addSubview(view)
    addContrains(cell.contentView, subView: view)
    self.layoutIfNeeded()
    return cell
    
  }
  
  public func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    currentIndex = indexPath.row
  }
  
  //MARK: CollectionView Delegate
  
  public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    delegate?.autoScrollingView?(self, didSelectItem: indexPath.row)
  }
  
  //MARK: UIScrollView delegate method
  public func scrollViewWillBeginDragging(scrollView: UIScrollView)
  {
    pauseScrolling()
  }
  
  public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool)
  {
    startScrolling()
  }
  
  //HELPERS
  
  private func addContrains(superView: UIView, subView: UIView){
    subView.translatesAutoresizingMaskIntoConstraints = false
    let views = ["myView" : subView]
    superView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[myView]|", options:[] , metrics: nil, views: views))
    superView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[myView]|", options:[] , metrics: nil, views: views))
  }

}
















