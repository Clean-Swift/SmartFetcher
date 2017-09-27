//
//  EventArrayWorker.swift
//  SmartFetcher
//
//  Created by Raymond Law on 9/8/17.
//  Copyright (c) 2017 Clean Swift LLC. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

// MARK: - Event array worker

final class EventArrayWorker: NSObject, EventWorkerAPI
{
  var events = [Event]()
  
  // MARK: - Object lifecycle
  
  static let shared = EventArrayWorker()
  private override init() {}
  
  // MARK: - Validation
  
  func validate(event: Event) -> Bool
  {
    return true
  }
  
  // MARK: - CRUD operations
  
  func list() -> [Event]
  {
    return events
  }
  
  func show(at indexPath: IndexPath) -> Event
  {
    return events[indexPath.row]
  }
  
  func new(timestamp: Date) -> Event
  {
    return Event(timestamp: Date())
  }
  
  func create(event: Event)
  {
    events.insert(event, at: 0)
  }
  
  func edit(at indexPath: IndexPath) -> Event
  {
    return events[indexPath.row]
  }
  
  func update(event: Event)
  {
    if let index = events.index(of: event) {
      events[index] = event
    }
  }
  
  func delete(at indexPath: IndexPath)
  {
    events.remove(at: indexPath.row)
  }
  
  // MARK: - Count
  
  func count() -> Int
  {
    return events.count
  }
}