//
//  BorderedTextField.swift
//  Ponder
//
//  Created by Krish Suchdev on 2/23/19.
//  Copyright © 2019 Krish Suchdev. All rights reserved.
//

import UIKit

class BorderedTextField: UITextField {
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    self.setUpBorder()
  }
  
  func setUpBorder() {
    self.layer.borderWidth = 3.0
    self.layer.borderColor = UIColor.ponderOrange.cgColor
    self.layer.masksToBounds = true
    self.layer.cornerRadius = 10.0
  }
  
}
