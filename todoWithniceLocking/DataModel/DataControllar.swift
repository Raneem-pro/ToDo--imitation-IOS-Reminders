//
//  DataControllar.swift
//  ToDoList-Swift
//
//  Created by رنيم القرني on 07/09/1445 AH.
//

import Foundation

import CoreData

class DataController: ObservableObject{
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "TaskModel")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load the data \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved!!! WUHU!!!")
        } catch {
            print("We could not save the data......")
        }
    }
    
    func addTask(name: String,taskDescription: String,dueDate: Date,context: NSManagedObjectContext) {
        let task = Tasks(context: context)
        task.iD = UUID()
        task.taskTitle = name
        task.taskDec = taskDescription
        task.date = dueDate
        task.taskAddDdate = Date()
        task.isDone = false
        save(context: context)
    }
    
    func editTask(task: Tasks, name: String,taskDescription: String,dueDate: Date,context: NSManagedObjectContext) {
        task.taskTitle = name
        task.taskDec = taskDescription
        task.date = dueDate
        save(context: context)
    }
}
