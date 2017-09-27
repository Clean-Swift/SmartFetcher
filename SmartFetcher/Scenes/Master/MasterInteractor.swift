//
//  MasterInteractor.swift
//  SmartFetcher
//
//  Created by Raymond Law on 9/1/17.
//  Copyright (c) 2017 Clean Swift LLC. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

// MARK: - Business logic

protocol MasterBusinessLogic
{
  // MARK: CRUD operations
  func fetchEvents(request: Master.FetchEvents.Request)
  func fetchEventAndConfigureCell(request: Master.FetchEventAndConfigureCell.Request)
  func fetchEventAndReturn(request: Master.FetchEventAndReturn.Request) -> Master.DisplayedEvent
  func fetchEventWithClosure(request: Master.FetchEventWithClosure.Request)
  func createEvent(request: Master.CreateEvent.Request)
  func deleteEvent(request: Master.DeleteEvent.Request)
  // MARK: Count
  func count(request: Master.EventCount.Request) -> Int
  // MARK: Event update lifecycle
  func startEventUpdates(request: Master.StartEventUpdates.Request)
  func stopEventUpdates(request: Master.StopEventUpdates.Request)
}

// MARK: - Data store

protocol MasterDataStore
{
}

// MARK: - Interactor

class MasterInteractor: MasterBusinessLogic, MasterDataStore
{
  var presenter: MasterPresentationLogic?
  var eventWorker: EventWorkerAPI = Master.eventWorker
  
  // MARK: - CRUD operations
  
  // MARK: Fetch events
  
  func fetchEvents(request: Master.FetchEvents.Request)
  {
    let events = eventWorker.list()
    
    if let _ = eventWorker as? EventArrayWorker {
      let response = Master.FetchEvents.Response(events: events)
      presenter?.presentFetchedEvents(response: response)
    }
  }
  
  // MARK: Fetch event
  
  func fetchEventAndConfigureCell(request: Master.FetchEventAndConfigureCell.Request)
  {
    let event = eventWorker.show(at: request.indexPath)
    
    let response = Master.FetchEventAndConfigureCell.Response(event: event, cell: request.cell)
    presenter?.presentFetchedEventAndConfigureCell(response: response)
  }
  
  func fetchEventAndReturn(request: Master.FetchEventAndReturn.Request) -> Master.DisplayedEvent
  {
    let event = eventWorker.show(at: request.indexPath)
    
    let response = Master.FetchEventAndReturn.Response(event: event)
    let displayedEvent = presenter?.presentFetchedEventAndReturn(response: response)
    return displayedEvent!
  }
  
  func fetchEventWithClosure(request: Master.FetchEventWithClosure.Request)
  {
    let event = eventWorker.show(at: request.indexPath)
    
    let response = Master.FetchEventWithClosure.Response(event: event, resultHandler: request.resultHandler)
    presenter?.presentFetchedEventWithClosure(response: response)
  }
  
  // MARK: Create event
  
  func createEvent(request: Master.CreateEvent.Request)
  {
    let event = eventWorker.new(timestamp: request.timestamp)
    eventWorker.create(event: event)
    
    if let _ = eventWorker as? EventArrayWorker {
      let response = Master.CreateEvent.Response(event: event)
      presenter?.presentCreatedEvent(response: response)
    }
  }
  
  // MARK: Delete event
  
  func deleteEvent(request: Master.DeleteEvent.Request)
  {
    eventWorker.delete(at: request.indexPath)
    
    if let _ = eventWorker as? EventArrayWorker {
      let response = Master.DeleteEvent.Response()
      presenter?.presentDeletedEvent(response: response)
    }
  }
  
  // MARK: - Count
  
  func count(request: Master.EventCount.Request) -> Int
  {
    return eventWorker.count()
  }
}

// MARK: - NSFetchedResultsController

extension MasterInteractor: EventCoreDataWorkerDelegate
{
  // MARK: Event update lifecycle
  
  func startEventUpdates(request: Master.StartEventUpdates.Request)
  {
    if let eventWorker = eventWorker as? EventCoreDataWorker {
      eventWorker.delegates.append(self)
    }
  }
  
  func stopEventUpdates(request: Master.StopEventUpdates.Request)
  {
    if let eventWorker = eventWorker as? EventCoreDataWorker {
      if let index = eventWorker.delegates.index(where: { $0 === self }) {
        eventWorker.delegates.remove(at: index)
      }
    }
  }
  
  func eventCoreDataWorkerWillUpdate(eventCoreDataWorker: EventCoreDataWorker)
  {
    let response = Master.StartEventUpdates.Response()
    presenter?.presentStartEventUpdates(response: response)
  }
  
  func eventCoreDataWorkerDidUpdate(eventCoreDataWorker: EventCoreDataWorker)
  {
    let response = Master.StopEventUpdates.Response()
    presenter?.presentStopEventUpdates(response: response)
  }
  
  // MARK: Event section updates
  
  func eventCoreDataWorker(eventCoreDataWorker: EventCoreDataWorker, shouldInsertSection section: IndexSet)
  {
    presenter?.presentInsertedSection(section: section)
  }
  
  func eventCoreDataWorker(eventCoreDataWorker: EventCoreDataWorker, shouldDeleteSection section: IndexSet)
  {
    presenter?.presentDeletedSection(section: section)
  }
  
  func eventCoreDataWorker(eventCoreDataWorker: EventCoreDataWorker, shouldUpdateSection section: IndexSet)
  {
    presenter?.presentUpdatedSection(section: section)
  }
  
  func eventCoreDataWorker(eventCoreDataWorker: EventCoreDataWorker, shouldMoveSectionFrom from: IndexSet, to: IndexSet)
  {
    presenter?.presentMovedSection(from: from, to: to)
  }
  
  // MARK: Event row updates
  
  func eventCoreDataWorker(eventCoreDataWorker: EventCoreDataWorker, shouldInsertRowAt row: IndexPath)
  {
    presenter?.presentInsertedRowAt(row: row)
  }
  
  func eventCoreDataWorker(eventCoreDataWorker: EventCoreDataWorker, shouldDeleteRowAt row: IndexPath)
  {
    presenter?.presentDeletedRowAt(row: row)
  }
  
  func eventCoreDataWorker(eventCoreDataWorker: EventCoreDataWorker, shouldUpdateRowAt row: IndexPath, withEvent event: Event)
  {
    presenter?.presentUpdatedRowAt(row: row, withEvent: event)
  }
  
  func eventCoreDataWorker(eventCoreDataWorker: EventCoreDataWorker, shouldMoveRowFrom from: IndexPath, to: IndexPath, withEvent event: Event)
  {
    presenter?.presentMovedRow(from: from, to: to, withEvent: event)
  }
}