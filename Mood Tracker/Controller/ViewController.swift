//
//  ViewController.swift
//  Mood Tracker
//
//  Created by Avin Sharma on 2/25/19.
//  Copyright © 2019 Avin Sharma. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, NewEntryDelegate {
    
    @IBOutlet weak var moodList: UITableView!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        moodList.delegate = self
        moodList.dataSource = self
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addMood"{
            print("In segue prep")
            let destinationVC = segue.destination as! MoodEntryViewController
            destinationVC.delegate = self
        }
    }
    @IBAction func addMoodButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "addMood", sender: self)
    }
    
    func refreshEntries() {
        print("Refreshing TableView")
        moodList.reloadData()
    }

}

extension ViewController: UITableViewDataSource, EntryCellDelegate{
    
    // Return total number of rows/entries in our DataBase
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let entries = realm.objects(Entry.self).filter("isDeleted == false")
        return entries.count
    }
    
    // Map entries of each cell to its respective data entry
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Creating/Reusing tableview cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell") as! EntryCell
        
        let entries = realm.objects(Entry.self).filter("isDeleted == false").sorted(byKeyPath: "date", ascending: false)
        let entry = entries[indexPath.row]
        let formatter = DateFormatter() // Set date label
        formatter.dateFormat = "MMMM dd"
        cell.date.text = formatter.string(from: entry.date)
        cell.moodImage.image = UIImage(named: entry.mood) // Set mood image
        cell.activities.text = entry.activities.joined(separator: ", ") // Set activities label
        cell.deleteButton.tag = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
    func deleteButtonPressed(tag: Int) {
        let entries = realm.objects(Entry.self).sorted(byKeyPath: "date", ascending: false)
        let entry = entries[tag]
        try! realm.write {
            print("Inside realm.write")
// Uncomment the line below to use iCloud capabilities to delete the record from the cloud and comment `realm.delete` .
            entry.isDeleted = true
//            realm.delete(entry)
        }
        print(realm.objects(Entry.self).sorted(byKeyPath: "date", ascending: false))
        refreshEntries()
    }
}
