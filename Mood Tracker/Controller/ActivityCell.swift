//
//  ActivityCell.swift
//  Mood Tracker
//
//  Created by Avin Sharma on 4/13/19.
//  Copyright © 2019 Avin Sharma. All rights reserved.
//

import UIKit

protocol ActivityCellDelegate {
    func deleteButtonPressed(tag: Int)
}

class ActivityCell: UITableViewCell {
    var delegate: ActivityCellDelegate?
    @IBOutlet weak var activity: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        delegate?.deleteButtonPressed(tag: sender.tag)
    }
}
