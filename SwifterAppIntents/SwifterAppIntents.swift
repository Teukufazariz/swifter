//
//  SwifterAppIntents.swift
//  SwifterAppIntents
//
//  Created by Teuku Fazariz Basya on 15/05/25.
//

import AppIntents
import SwiftData
import SwiftUI

enum EditAverageType: String, AppEnum {
    case preJogDuration, avgTimeOnFeet, postJogDuration
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Average Type"
    }

    static var caseDisplayRepresentations: [EditAverageType : DisplayRepresentation] {
        [
            .preJogDuration: "Pre-Jog Duration",
            .avgTimeOnFeet: "Time on Feet",
            .postJogDuration: "Post-Jog Duration"
        ]
    }
}

enum EditPreferredType: String, AppEnum {
    case preferredDaysOfWeek, preferredTimesOfDay
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Preferred Type"
    }
        
    static var caseDisplayRepresentations: [EditPreferredType : DisplayRepresentation] {
        [
            .preferredDaysOfWeek: "Preferred Days of Week",
            .preferredTimesOfDay: "Preferred Times of Day"
        ]
    }
}



struct SwifterAppIntents: AppIntent {
    static var title: LocalizedStringResource { "SwifterAppIntents" }
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}

struct AppIntentShortcutProvider: AppShortcutsProvider {
    
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: EditAverage(),
            phrases: [
                "Set \(.applicationName) jogging duration",
                "Update \(.applicationName) jogging time",
                "Change \(.applicationName) jog settings"
            ],
            shortTitle: "Edit Average",
            systemImageName: "figure.run.circle.fill"
        )
        
        AppShortcut(
            intent: EditPreferred(),
            phrases: ["Adjust preferred days in \(.applicationName)"],
            shortTitle: "Edit Preferred", 
            systemImageName: "calendar"
        )
    }
}

struct EditAverage: AppIntent {
    
    @Parameter(title: "Average Type") 
    var editAverageType: EditAverageType
    
    @Parameter(title: "Duration")
//    @ParameterSummary("$", default: "minutes")
    var duration: Int
    
    static var title: LocalizedStringResource { "Edit Average Duration" }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Set \(\.$editAverageType) to \(\.$duration) minutes")
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        // Get the shared ModelContext
        let modelContext = try ModelContainer(for: PreferencesModel.self).mainContext
        let preferencesManager = PreferencesManager(modelContext: modelContext)
        
        if preferencesManager.fetchPreferences() != nil {
            // Update the appropriate value based on the selected type
            switch editAverageType {
            case .preJogDuration:
                preferencesManager.setPrejogTime(prejogTime: duration)
            case .avgTimeOnFeet:
                preferencesManager.setJogTime(timeOnFeet: duration)
            case .postJogDuration:
                preferencesManager.setPostjogTime(postjogTime: duration)
            }
            
            return .result(value: "Updated \(editAverageType.rawValue) to \(duration) minutes")
        } else {
            throw Error("Preferences not found")
        }
    }
    
    struct Error: Swift.Error, CustomStringConvertible {
        let description: String
        init(_ description: String) { self.description = description }
    }
}


struct EditPreferred: AppIntent {

    static var title: LocalizedStringResource { "Preferred" }
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}

