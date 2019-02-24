//
//  MainViewController.swift
//  Ponder
//
//  Created by Krish Suchdev on 2/24/19.
//  Copyright © 2019 Krish Suchdev. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  @IBOutlet weak var ponderTitleLabel: UILabel!
  @IBOutlet weak var lightBulbImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Hexagons.png")!)
    
    self.lightBulbImageView.transform = CGAffineTransform(translationX: 0.0, y: -50.0)
    self.lightBulbImageView.alpha = 0.0
    UIView.animate(withDuration: 2.0, delay: 0.5, options: .curveEaseIn, animations: {
      self.lightBulbImageView.transform = CGAffineTransform.identity
      self.lightBulbImageView.alpha = 1.0
    }) { (success) in }
    
  }
  
}
