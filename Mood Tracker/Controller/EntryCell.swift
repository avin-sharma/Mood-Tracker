//
//  EntryCell.swift
//  Mood Tracker
//
//  Created by Avin Sharma on 4/12/19.
//  Copyright © 2019 Avin Sharma. All rights reserved.
//

import UIKit

protocol EntryCellDelegate{
    func deleteButtonPressed(tag: Int)
}

class EntryCell: UITableViewCell{
    var delegate: EntryCellDelegate?
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var moodImage: UIImageView!
    @IBOutlet weak var activities: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        delegate?.deleteButtonPressed(tag: sender.tag)
    }
}
