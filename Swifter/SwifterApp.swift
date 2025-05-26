//
//  SwifterApp.swift
//  Swifter
//
//  Created by Adeline Charlotte Augustinne on 24/03/25.
//

import SwiftUI
import SwiftData

@main
struct SwifterApp: App {
  @StateObject private var eventStoreManager = EventStoreManager()
  let container: ModelContainer

    init() {
        container = try! ModelContainer(
            for: PreferencesModel.self,
                 GoalModel.self,
                 SessionModel.self,        // ← no square brackets
            configurations: ModelConfiguration(
                groupContainer: .identifier("group.swifter")
            )
        )
    }


  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(eventStoreManager)
    }
    // Here we hand it our pre-built container:
    .modelContainer(container)
  }
}

