//
//  Room.swift
//  Ponder
//
//  Created by Krish Suchdev on 2/23/19.
//  Copyright © 2019 Krish Suchdev. All rights reserved.
//

import UIKit
import Firebase

class Room: NSObject {
  
  class Item: NSObject {
    
    var room: Room!
    var code: String!
    var name: String!
    var votes: Int!
    var creator: String!
    
    init(room: Room, name: String, votes: Int, creator: String) {
      self.room = room
      self.code = String(describing: self.room.getReference().child("Items").childByAutoId()).components(separatedBy: "/").last!
      self.name = name
      self.votes = votes
      self.creator = creator
    }
    
    init(room: Room, code: String, dictionary: [AnyHashable : Any]) {
      self.room = room
      self.code = code
      self.name = dictionary["Content"] as? String
      self.votes = (dictionary["Votes"] as? [AnyHashable : Any] ?? [:]).compactMap({ (element) -> Int in
        return element.value as? Bool == true ? 1 : -1
      }).reduce(0, +)
      self.creator = dictionary["Creator"] as? String
    }
    
    func getReference() -> DatabaseReference {
      return self.room.getReference().child("Items").child(self.code)
    }
    
    static func ==(lhs: Room.Item, rhs: Room.Item) -> Bool {
      return lhs.name == rhs.name
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
      return self.name == (object as? Room.Item)?.name
    }
    
  }
  
  static var current: Room!
  
  var code: String!
  var items: [Room.Item]!
  
  override init() {
    self.code = "POTATO"
    self.items = [Room.Item]()
  }
  
  init(code: String) {
    self.code = code
    self.items = [Room.Item]()
  }
  
  func getReference() -> DatabaseReference {
    return Database.database().reference().child("Rooms").child(self.code)
  }
  
}
