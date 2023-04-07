//
//  ResolutionApp.swift
//  Resolution
//
//  Created by 류지예 on 2023/04/01.
//

import SwiftUI

@main
struct ResolutionApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
