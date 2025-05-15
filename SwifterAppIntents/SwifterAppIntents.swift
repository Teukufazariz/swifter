//
//  SwifterAppIntents.swift
//  SwifterAppIntents
//
//  Created by Teuku Fazariz Basya on 15/05/25.
//

import AppIntents

struct SwifterAppIntents: AppIntent {
    static var title: LocalizedStringResource { "SwifterAppIntents" }
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}

struct AppIntentShortcutProvider: AppShortcutsProvider {
    
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: Average(),
                    phrases: ["Order coffee in \(.applicationName)"]
                    ,shortTitle: "Average", systemImageName: "cup.and.saucer.fill")
        
        AppShortcut(intent: Preferred(),
                    phrases: ["Order a cappuccino in \(.applicationName)"]
                    ,shortTitle: "Preferred", systemImageName: "cup.and.saucer.fill")
    }
}

struct Average: AppIntent {
    static var title: LocalizedStringResource { "Average" }
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}


struct Preferred: AppIntent {
    static var title: LocalizedStringResource { "Preferred" }
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}

