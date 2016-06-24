//
//  ViewController.swift
//  Demo
//
//  Created by George on 2016-06-23.
//  Copyright © 2016 George Kye. All rights reserved.
//

import UIKit

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

class ViewController: UIViewController, AutoScrollingViewDataSource, AutoScrollingViewDelegate {
  
  
  var imgs = ["0", "1", "2", "3"]
  @IBOutlet var imageV: UIImageView!
  var asview: AutoScrollingView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    asview = AutoScrollingView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
    asview.dataSource = self
    asview.delegate = self
    self.view.addSubview(asview)
  }
  
  
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
    }
    return array
  }
  
  func setAutoScrollingViewDataSource(autoScrollingView: AutoScrollingView) -> [UIView] {
    return createImageViews()
  }
  
  @IBAction func pauseScrolling(){
    asview.pauseScrolling()
  }
  
  @IBAction func startScrolling(){
    asview.startScrolling()
  }

  //MAKR: ASView delegates
  
  func autoScrollingView(autoScrollingView: AutoScrollingView, didSelectItem index: Int) {
    imageV.image = UIImage(named: imgs[index])
    print("did select")

  }
  
  func autoScrollingView(autoScrollingView: AutoScrollingView, didChangeStatus status: ScrollingState) {
    print(status.rawValue)
  }
  
  func autoScrollingView(autoScrollingView: AutoScrollingView, didAutoScroll index: Int) {
    print("auto scrolling at index ", index)
  }
  
  
}

