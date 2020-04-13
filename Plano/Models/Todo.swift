//
//  TaskModel.swift
//  Plano
//
//  Created by Rayhan Martiza Faluda on 09/04/20.
//  Copyright © 2020 Mini Challenge 1 - Group 7. All rights reserved.
//

import Foundation
import UIKit
import CloudKit
import CoreData

public class Todo: NSManagedObject {
    static func fetchAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [Todo] {
        //let request : NSFetchRequest<Task> = Task.fetchRequest()
        let request = NSFetchRequest<Todo>(entityName: "Todo")
        let primarySortDescriptor = NSSortDescriptor(key: "dateAndTime", ascending: true)
        //let secondarySortDescriptor = NSSortDescriptor(key: "status", ascending: true)
        //let tertiarySortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [primarySortDescriptor/*, secondarySortDescriptor, tertiarySortDescriptor*/]
        guard let tasks = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return tasks
    }
    
    static func deleteAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        Todo.fetchAll(viewContext: viewContext).forEach({ viewContext.delete($0) })
        try? viewContext.save()
    }
    
    static var entityName: String { return "Todo" }
}
