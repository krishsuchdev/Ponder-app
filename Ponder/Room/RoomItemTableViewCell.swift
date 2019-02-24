//
//  RoomItemTableViewCell.swift
//  Ponder
//
//  Created by Krish Suchdev on 2/23/19.
//  Copyright © 2019 Krish Suchdev. All rights reserved.
//

import UIKit
import Firebase

class RoomItemTableViewCell: UITableViewCell {
  
  @IBOutlet weak var itemTitle: UILabel!
  
  @IBOutlet weak var upvoteButton: UIButton!
  @IBOutlet weak var votesLabel: UILabel!
  @IBOutlet weak var downvoteButton: UIButton!
  
  @IBOutlet weak var creatorLabel: UILabel!
  
  var roomItem: Room.Item!
  
  func updateLabels() {
    self.votesLabel.text = "\(self.roomItem.votes!)"
    self.creatorLabel.text = "\(self.roomItem.creator!)"
  }
  
  @IBAction func upvoted(_ sender: Any) {
    if self.downvoteButton.tintColor != UIColor.black { self.downvoted(self) }
    if User.current.upvotedFor.contains(self.roomItem) {
      self.roomItem.getReference().child("Votes").child("\(User.current.name!)").removeValue()
      self.upvoteButton.tintColor = UIColor.black
    } else {
      self.roomItem.getReference().child("Votes").updateChildValues(["\(User.current.name!)" : true])
      self.upvoteButton.tintColor = UIColor.green
    }
    self.updateLabels()
  }
  
  @IBAction func downvoted(_ sender: Any) {
    if self.upvoteButton.tintColor != UIColor.black { self.upvoted(self) }
    if User.current.downvotedFor.contains(self.roomItem) {
      self.roomItem.getReference().child("Votes").child("\(User.current.name!)").removeValue()
      self.downvoteButton.tintColor = UIColor.black
    } else {
      self.roomItem.getReference().child("Votes").updateChildValues(["\(User.current.name!)" : false])
      self.downvoteButton.tintColor = UIColor.red
    }
    self.updateLabels()
  }
  
}

extension Array where Element : Equatable {
  mutating func remove(object: Element) {
    if let index = self.index(of: object) {
      self.remove(at: index)
    }
  }
}
