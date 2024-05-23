//
//  FolhetosDeForroApp.swift
//  FolhetosDeForro
//
//  Created by Ana Guimarães on 23/05/24.
//

import SwiftUI

@main
struct FolhetosDeForroApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
