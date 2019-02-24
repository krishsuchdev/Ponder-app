//
//  ViewController.swift
//  Ponder
//
//  Created by Krish Suchdev on 2/23/19.
//  Copyright © 2019 Krish Suchdev. All rights reserved.
//

import UIKit
import Firebase

class CreateRoomViewController: UITableViewController, UITextFieldDelegate {

  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var roomCodeTextField: UITextField!
  
  var roomsReference: DatabaseReference!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    self.roomsReference = Database.database().reference().child("Rooms")
    
    self.roomCodeTextField.text = self.generateRandomRoomCode()
    self.usernameTextField.becomeFirstResponder()
    
    self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "Hexagons.png")!)
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if self.roomCodeTextField == textField {
      let filteredString = string.components(separatedBy: CharacterSet.letters.inverted).joined(separator: "")
      return string == filteredString && self.roomCodeTextField.text!.count < 6
    }
    return true
  }
  
  @IBAction func createRoom(_ sender: Any) {
    var passThrough = true
    if self.usernameTextField.text!.isEmpty {
      self.usernameTextField.backgroundColor = UIColor(red: 1.0, green: 0.808, blue: 0.8, alpha: 1.0)
      passThrough = false
    }
    if self.roomCodeTextField.text!.count != 6 {
      self.roomCodeTextField.backgroundColor = UIColor(red: 1.0, green: 0.808, blue: 0.8, alpha: 1.0)
      passThrough = false
    }
    if !passThrough { return }
    self.usernameTextField.backgroundColor = UIColor.white
    self.roomCodeTextField.backgroundColor = UIColor.white
    
    User.current = User(name: self.usernameTextField.text!)
    Room.current = Room(code: self.roomCodeTextField.text!)
    self.roomsReference.child(Room.current.code).updateChildValues(["Creator" : User.current.name])
    self.roomsReference.child(Room.current.code).child("Users").updateChildValues(["\(User.current.name!)" : true])
    
    self.performSegue(withIdentifier: "CreateRoom", sender: self)
  }
  
  func generateRandomRoomCode() -> String {
    var letters = ""
    for letter in Unicode.Scalar("A").value...Unicode.Scalar("Z").value { letters += String(format: "%c", letter) }
    var generatedCode = ""
    for _ in 0..<6 { generatedCode += String(letters[letters.index(letters.startIndex, offsetBy: Int(arc4random_uniform(UInt32(letters.count))))]) }
    return generatedCode
  }
  
}

