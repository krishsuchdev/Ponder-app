//
//  RoomViewController.swift
//  Ponder
//
//  Created by Krish Suchdev on 2/23/19.
//  Copyright © 2019 Krish Suchdev. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var itemTableView: UITableView!
  
  var managing = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "/ \(Room.current.code!)"
    
    self.itemTableView.backgroundColor = UIColor(patternImage: UIImage(named: "Hexagons.png")!)
    
    Room.current.getReference().observe(.value) { (snapshot) in
      var items = [Room.Item]()
      User.current.upvotedFor = [Room.Item]()
      User.current.downvotedFor = [Room.Item]()
      if let itemsDictionary = snapshot.childSnapshot(forPath: "Items").value as? [AnyHashable : Any] {
        itemsDictionary.keys.forEach({ (key) in
          let itemDictionary = itemsDictionary[key] as! [AnyHashable : Any]
          let item = Room.Item(room: Room.current, code: key as! String, dictionary: itemDictionary)
          items.append(item)
          
          if let votedDictionary = (itemDictionary["Votes"] as? [AnyHashable : Any]), let isUpvote = votedDictionary["\(User.current.name!)"] as? Bool {
            if isUpvote {
              User.current.upvotedFor.append(item)
            } else {
              User.current.downvotedFor.append(item)
            }
          }
        })
      }
      items.sort { (item1, item2) -> Bool in
        let compare = item1.votes - item2.votes
        if compare == 0 { return item1.name.compare(item2.name) == .orderedAscending }
        return compare >= 0
      }
      
      UIView.animate(withDuration: 0.5, animations: {
        self.itemTableView.beginUpdates()
        Room.current.items.enumerated().forEach({ (element) in
          let item = element.element
          let previousIndex = element.offset
          if let newIndex = items.firstIndex(of: item) {
            if previousIndex != newIndex {
              self.itemTableView.reloadSections(IndexSet(integer: previousIndex), with: .left)
            }
          } else {
            self.itemTableView.deleteSections(IndexSet(integer: previousIndex), with: .left)
          }
        })
        items.enumerated().forEach({ (element) in
          let item = element.element
          let newIndex = element.offset
          if !Room.current.items.contains(item) {
            self.itemTableView.insertSections(IndexSet(integer: newIndex), with: .left)
          }
        })
        Room.current.items = items
        self.itemTableView.endUpdates()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
          self.itemTableView.reloadData()
        })
      })
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return Room.current.items.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Item") as! RoomItemTableViewCell
    
    cell.roomItem = Room.current.items[indexPath.section]
    
    cell.itemTitle.text = cell.roomItem.name
    cell.upvoteButton.imageView?.image = cell.upvoteButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
    cell.downvoteButton.imageView?.image = cell.downvoteButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
    cell.upvoteButton.tintColor = User.current.upvotedFor.contains(cell.roomItem) ? UIColor.green : UIColor.black
    cell.downvoteButton.tintColor = User.current.downvotedFor.contains(cell.roomItem) ? UIColor.red : UIColor.black
    cell.updateLabels()
    
    cell.contentView.alpha = self.managing && cell.creatorLabel.text != User.current.name ? 0.25 : 1.0
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90.0
  }
  
  @IBAction func manageItems(_ sender: Any) {
    self.managing = !self.managing
    self.itemTableView.reloadData()
  }
  
  @IBAction func addItem(_ sender: Any) {
    let addItemAlert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
    addItemAlert.addTextField { (textfield) in
      textfield.placeholder = "Name"
      textfield.tintColor = UIColor.ponderOrange
      textfield.clearButtonMode = .whileEditing
    }
    addItemAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
      let newItem = Room.Item(room: Room.current, name: addItemAlert.textFields!.first!.text!, votes: 0, creator: User.current.name)
      Room.current.getReference().child("Items").child(newItem.code!).updateChildValues(["Content" : newItem.name, "Creator" : User.current.name!], withCompletionBlock: { (error, reference) in
      })
    }))
    addItemAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
    }))
    self.present(addItemAlert, animated: true) {}
  }
  
}
