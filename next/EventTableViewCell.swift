//
//  EventTableViewCell.swift
//  next
//
//  Created by Przemyslaw Jablonski on 25/03/2018.
//  Copyright © 2018 Przemyslaw Jablonski. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    func setEvent(date: Date, title: String, calendarTitle: String, calendarColour: CGColor) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-yyyy"
        let myStringafd = formatter.string(from: yourDate!)
        
        dateLabel.text = myStringafd
        titleLabel.text = title
        detailsLabel?.text = "Calendar: \(calendarTitle)"
        detailsLabel?.backgroundColor = UIColor(cgColor: calendarColour).withAlphaComponent(0.10)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
