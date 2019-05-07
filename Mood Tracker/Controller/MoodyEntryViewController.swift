//
//  MoodyEntryViewController.swift
//  Mood Tracker
//
//  Created by Avin Sharma on 4/13/19.
//  Copyright © 2019 Avin Sharma. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


protocol NewEntryDelegate {
     func refreshEntries()
}

class MoodEntryViewController: UIViewController {
    
    @IBOutlet weak var activityTable: UITableView!
    @IBOutlet weak var newActivityTextField: UITextField!
    @IBOutlet weak var selectedMeh: UIView!
    @IBOutlet weak var selectedHappy: UIView!
    @IBOutlet weak var selectedSad: UIView!
    
    var delegate: NewEntryDelegate?
    
    let realm = try! Realm()
    var selectedActivities = [String]()
    var selectedMood = ""
    
    override func viewDidLoad() {
        
        // Get the default Realm
        activityTable.delegate = self
        activityTable.dataSource = self
        activityTable.allowsMultipleSelection = true
        
    }
    
    // HIGHLIGHT MOOD WHEN CLICKED
    @IBAction func moodSelected(_ sender: UIButton) {
        selectedMeh.isHidden = true
        selectedSad.isHidden = true
        selectedHappy.isHidden = true
        
        if sender.tag == 0 {
            selectedSad.isHidden = false
            selectedMood = "Sad"
        }
        else if sender.tag == 1 {
            selectedMeh.isHidden = false
            selectedMood = "Meh"
        }
        else {
            selectedHappy.isHidden = false
            selectedMood = "Happy"
        }
        
    }
    
    // ADD NEW ACTIVITY TO THE ACTIVITY LIST
    @IBAction func addNewActivity(_ sender: UIButton) {
        // Do something when pressed
        if newActivityTextField.text != ""{
            let newActivity = Activity()
            newActivity.activity = newActivityTextField.text!
            let predicate = NSPredicate(format: "activity = %@", newActivity.activity)
            let activities = realm.objects(Activity.self).filter(predicate)
            newActivityTextField.text = ""
            if activities.count != 0 {
                // Alert activity already present
                let alertController = UIAlertController(title: "Activity already exists!", message:"", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            else{
                try! realm.write {
                    realm.add(newActivity)
                }
                activityTable.reloadData()
                selectedActivities = []
                
            }
        }
    }
    
    
    @IBAction func addNewEntry(_ sender: UIButton) {
        if(selectedMood == ""){
            let alertController = UIAlertController(title: "No Mood Selected!", message:"Please select a mood!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        if(selectedActivities.count == 0){
            let alertController = UIAlertController(title: "No Activity Selected!", message:"Please select alteast one activity!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let entry = Entry()
        entry.mood = selectedMood
        entry.activities.append(objectsIn: selectedActivities)
        try! realm.write {
            realm.add(entry)
            delegate?.refreshEntries()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}

// ALL ACTIVITY TABLEVIEW PROTOCOLS AND OPERATIONS
extension MoodEntryViewController: UITableViewDelegate, UITableViewDataSource, ActivityCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let activities = realm.objects(Activity.self).filter("isDeleted = false")
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Creating/Reusing tableview cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell") as! ActivityCell
        let activities = realm.objects(Activity.self).filter("isDeleted = false")
        cell.activity.text = activities[indexPath.row].activity
        cell.deleteButton.tag = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let activities = realm.objects(Activity.self).filter("isDeleted = false")
        selectedActivities.append(activities[indexPath.row].activity)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let activities = realm.objects(Activity.self).filter("isDeleted = false")
        selectedActivities = selectedActivities.filter{$0 != activities[indexPath.row].activity}
    }
    
    func deleteButtonPressed(tag: Int) {
        let activities = realm.objects(Activity.self).filter("isDeleted = false")
        let activity = activities[tag]
        try! realm.write {
            activity.isDeleted = true
        }
        selectedActivities = []
        activityTable.reloadData()
    }
}
