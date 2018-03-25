//
//  ViewController.swift
//  next
//
//  Created by Przemyslaw Jablonski on 25/03/2018.
//  Copyright © 2018 Przemyslaw Jablonski. All rights reserved.
//

import UIKit
import EventKit

class NextPrimaryViewController: UIViewController {

    lazy var eventStore: EKEventStore = EKEventStore()
    
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
        
        let events = eventStore.events(matching: eventStore.predicateForEvents(withStart: Date(), end: Date().addingTimeInterval(60*60*24*7), calendars: nil))
        NSLog("events: \(events)")
        
        eventStore.fetchReminders(matching: eventStore.predicateForReminders(in: nil)) { (reminder) in
            NSLog("Reminder: \(String(describing: reminder))\n")
        }
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

