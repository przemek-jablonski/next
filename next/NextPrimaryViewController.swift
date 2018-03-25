//
//  ViewController.swift
//  next
//
//  Created by Przemyslaw Jablonski on 25/03/2018.
//  Copyright © 2018 Przemyslaw Jablonski. All rights reserved.
//

import UIKit
import EventKit

class NextPrimaryViewController: UIViewController, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCellReuseIdentifier")
        let event = events?[indexPath.row]
        if (cell != nil && event != nil) {
            cell!.textLabel?.text = event!.title
            cell!.detailTextLabel?.text = "Calendar: \(event!.calendar.title)"
            cell!.backgroundColor = UIColor(cgColor: event!.calendar.cgColor).withAlphaComponent(0.5)
        }
        return cell! //todo: !, this may be null
    }
    

    @IBOutlet weak var eventsTableView: UITableView!
    lazy var eventStore: EKEventStore = EKEventStore()
    var events: [EKEvent]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("eventStore: %@", eventStore)
        _ = checkAuthorizationStatus(eventStore: eventStore)
        eventStore.requestAccess(to: EKEntityType.event, completion: { (granted, error) in
            NSLog("requesting access for: event, granted: \(granted), error: \(String(describing: error))")
        })
        eventStore.requestAccess(to: EKEntityType.reminder, completion: { (granted, error) in
            NSLog("requesting access for: reminder, granted: \(granted), error: \(String(describing: error))")
        })
        let calendars = eventStore.calendars(for: EKEntityType.event)
        
        for (index, calendar) in calendars.enumerated() {
            NSLog("calendar[\(index)]: \(calendar)")
        }
        
        events = eventStore.events(matching: eventStore.predicateForEvents(withStart: Date(), end: Date().addingTimeInterval(60*60*24*7), calendars: nil))
        NSLog("events: \(events)")
        
        eventStore.fetchReminders(matching: eventStore.predicateForReminders(in: nil)) { (reminder) in
            NSLog("Reminder: \(String(describing: reminder))\n")
        }
        
        eventsTableView.dataSource = self
    }
    
    private func checkAuthorizationStatus(eventStore: EKEventStore) -> Bool {
        let authorizationStatusEvents = EKEventStore.authorizationStatus(for: EKEntityType.event)
        let authorizationStatusReminders = EKEventStore.authorizationStatus(for: EKEntityType.reminder)
        NSLog("EventStore authorization status, events: \(authorizationStatusEvents), reminders: \(authorizationStatusReminders)")
        return authorizationStatusEvents == EKAuthorizationStatus.authorized && authorizationStatusReminders == EKAuthorizationStatus.authorized
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func showAlert() {
        
    }

}

