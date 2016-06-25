//
//  ViewController.swift
//  Demo
//
//  Created by George on 2016-06-23.
//  Copyright © 2016 George Kye. All rights reserved.
//

import UIKit


class ViewController: UIViewController, GKAutoScrollingViewDataSource, GKAutoScrollingViewDelegate {
  
  
  @IBOutlet var imageV: UIImageView!
  var autoScrollView: GKAutoScrollingView!
  var dataSource = [UIImageView]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    autoScrollView = GKAutoScrollingView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
    autoScrollView.dataSource = self
    autoScrollView.delegate = self
    self.view.addSubview(autoScrollView)
  }
  
  
  //MARK: Helpers
  
  func createCustomViews()->[UIView]{
    var array: [UIView] = []
    for index in 0...3 {
      array.append(CardView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300), labelText: "\(index)"))
    }
    return array
  }
  
  func createImageViews()->[UIImageView]{
    var array: [UIImageView] = []
    for index in 0...3 {
      let img = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
      img.image = UIImage(named: "\(index)")
      array.append(img)
      dataSource.append(img)
    }
    return array
  }
  
  
  //MARK: IBActions
  
  @IBAction func pauseScrolling(){
    autoScrollView.pauseScrolling()
  }
  
  @IBAction func startScrolling(){
    autoScrollView.startScrolling()
  }
  
  @IBAction func reloadData(){
    dataSource.append(UIImageView(image: UIImage(named: "screenshot")))
    autoScrollView.reloadData()
  }
  
  
  //MARK: ASView Datasource
  func setAutoScrollingViewDataSource(autoScrollingView: GKAutoScrollingView) -> [UIView] {
    _ = createImageViews()
    return dataSource
  }
  
  //MAKR: ASView delegates
  
  func autoScrollingView(autoScrollingView: GKAutoScrollingView, didSelectItem index: Int) {
    print("did select")
    
  }
  
  func autoScrollingView(autoScrollingView: GKAutoScrollingView, didChangeStatus status: ScrollingState) {
    print(status.rawValue)
  }
  
  func autoScrollingView(autoScrollingView: GKAutoScrollingView, didAutoScroll index: Int) {
    print("auto scrolling at index ", index)
  }
  
  
}


class CardView: UIView {
  
  var label:UILabel
  init(frame: CGRect, labelText: String) {
    label               = UILabel()
    label.font          = UIFont.boldSystemFontOfSize(24)
    label.text          = labelText
    label.textAlignment = NSTextAlignment.Center
    super.init(frame: frame)
    
    self.addSubview(self.label)
    self.backgroundColor    = UIColor.whiteColor()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.label.frame = self.bounds
  }
  
}