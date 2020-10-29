//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Mete Alp Kizilcay on 29.10.2020.
//

import SwiftUI

@main
struct BookwormApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
