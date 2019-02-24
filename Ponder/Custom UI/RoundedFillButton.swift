//
//  RoundedFillButton.swift
//  Ponder
//
//  Created by Krish Suchdev on 2/23/19.
//  Copyright © 2019 Krish Suchdev. All rights reserved.
//

import UIKit

class RoundedFillButton: UIButton {

  @IBInspectable var growAndShrinkMethod: Bool = true
  @IBInspectable var disappearMethod: Bool = false
  @IBInspectable var borderPressDown: Bool = true
  
  override open var isHighlighted: Bool {
    willSet {
      if self.isHighlighted != newValue {
        self.performAnimation(touch: newValue)
      }
    }
  }
  override open var isSelected: Bool {
    willSet {
      if self.isSelected != newValue {
        self.performAnimation(touch: newValue)
      }
    }
  }
  
  private var initialAlpha: CGFloat!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    if self.initialAlpha == nil { self.initialAlpha = self.alpha }
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    self.setTitleColor(UIColor.white, for: .normal)
    let shadowLayer = CAShapeLayer()
    shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height / 2).cgPath
    shadowLayer.fillColor = UIColor.ponderOrange.cgColor
    
    shadowLayer.shadowColor = UIColor.ponderOrange.darker(amount: 0.5).cgColor
    shadowLayer.shadowPath = shadowLayer.path
    shadowLayer.shadowOffset = CGSize(width: 0.0, height: 6.0)
    shadowLayer.shadowOpacity = 1.0
    shadowLayer.shadowRadius = 0
    
    layer.insertSublayer(shadowLayer, at: 0)
  }
  
  func performAnimation(touch: Bool) {
    if self.growAndShrinkMethod {
      let scale = (touch ? 0.85 : 1.0) as CGFloat
      UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
        self.transform = CGAffineTransform(scaleX: scale, y: scale)
      }, completion: nil)
    }
    if self.disappearMethod {
      UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
        self.alpha = touch ? self.initialAlpha / 2.0 : self.initialAlpha
      }, completion: nil)
    }
    if self.borderPressDown {
      /*if let shadowLayer = self.layer.sublayers?.first {
        let shadowOffset = CABasicAnimation(keyPath: "shadowOffset.height")
        shadowOffset.duration = 0.2
        shadowOffset.isRemovedOnCompletion = false
        shadowOffset.fromValue = shadowLayer.shadowOffset.height
        shadowOffset.toValue = 6.0 / (touch ? 2.0 : 1.0)
        shadowOffset.timingFunction = CAMediaTimingFunction(name: .linear)
        shadowLayer.add(shadowOffset, forKey: "ShadowOffsetHeight")
      }*/
      UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
        if let shadowLayer = self.layer.sublayers?.first {
          shadowLayer.shadowOffset.height = 6.0 / (touch ? 2.0 : 1.0)
        }
      }, completion: nil)
    }
  }

}

extension UIColor {
  static var blueGray: UIColor { return UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 241.0/255.0, alpha: 1.0) }
  
  func lighter(amount: CGFloat) -> UIColor {
    return self.hueColorWithBrightnessAmount(amount: 1.0 + amount)
  }
  
  func darker(amount: CGFloat) -> UIColor {
    return self.hueColorWithBrightnessAmount(amount: 1.0 - amount)
  }
  
  private func hueColorWithBrightnessAmount(amount: CGFloat) -> UIColor {
    var hue: CGFloat = 0.0,  saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
    
    if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
      return UIColor(hue: hue, saturation: saturation, brightness: brightness * amount, alpha: alpha)
    } else {
      return self
    }
  }
}
