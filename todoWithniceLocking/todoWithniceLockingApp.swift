//
//  todoWithniceLockingApp.swift
//  todoWithniceLocking
//
//  Created by رنيم القرني on 09/10/1445 AH.
//

import SwiftUI

@main
struct todoWithniceLockingApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
