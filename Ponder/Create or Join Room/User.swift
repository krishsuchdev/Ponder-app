//
//  User.swift
//  Ponder
//
//  Created by Krish Suchdev on 2/23/19.
//  Copyright © 2019 Krish Suchdev. All rights reserved.
//

import UIKit

class User: NSObject {
  static var current: User!
  
  var name: String!
  var upvotedFor: [Room.Item]!
  var downvotedFor: [Room.Item]!
  
  init(name: String) {
    self.name = name
    self.upvotedFor = [Room.Item]()
    self.downvotedFor = [Room.Item]()
  }
}
