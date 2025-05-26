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

enum TimeOfDayIntent: String, AppEnum {
    case morning = "Morning"
    case noon = "Noon"
    case afternoon = "Afternoon"
    case evening = "Evening"
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Time of Day"
    }
    
    static var caseDisplayRepresentations: [TimeOfDayIntent: DisplayRepresentation] {
        [
            .morning: "Morning",
            .noon: "Noon",
            .afternoon: "Afternoon",
            .evening: "Evening"
        ]
    }
}

enum DayOfWeekIntent: String, AppEnum {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Day of Week"
    }
    
    static var caseDisplayRepresentations: [DayOfWeekIntent: DisplayRepresentation] {
        [
            .monday: "Monday",
            .tuesday: "Tuesday",
            .wednesday: "Wednesday",
            .thursday: "Thursday",
            .friday: "Friday",
            .saturday: "Saturday",
            .sunday: "Sunday"
        ]
    }
    
    func toModelDay() -> DayOfWeek? {
        switch self {
        case .monday: return .monday
        case .tuesday: return .tuesday
        case .wednesday: return .wednesday
        case .thursday: return .thursday
        case .friday: return .friday
        case .saturday: return .saturday
        case .sunday: return .sunday
        }
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
        // 1. Edit Pre-Jog Duration
        AppShortcut(
            intent: EditPreJog(),
            phrases: [
                "Set \(.applicationName) pre-jog duration",
                "Update \(.applicationName) warm-up time", 
                "Change \(.applicationName) preparation time"
            ],
            shortTitle: "Edit Pre-Jog",
            systemImageName: "timer"
        )
        
        // 2. Edit Time on Feet
        AppShortcut(
            intent: EditTimeOnFeet(),
            phrases: [
                "Set \(.applicationName) jogging duration",
                "Update \(.applicationName) time on feet", 
                "Change \(.applicationName) run length"
            ],
            shortTitle: "Edit Time on Feet",
            systemImageName: "figure.run.circle.fill"
        )
        
        // 3. Edit Post-Jog Duration
        AppShortcut(
            intent: EditPostJog(),
            phrases: [
                "Set \(.applicationName) post-jog duration",
                "Update \(.applicationName) cool down time", 
                "Change \(.applicationName) recovery time"
            ],
            shortTitle: "Edit Post-Jog",
            systemImageName: "timer.circle"
        )
        
        // 4. Edit Preferred Times of Day
        AppShortcut(
            intent: EditPreferredTimes(),
            phrases: [
                "Update \(.applicationName) preferred times",
                "Change when I jog in \(.applicationName)", 
                "Set my jogging time preferences in \(.applicationName)"
            ],
            shortTitle: "Edit Times",
            systemImageName: "clock"
        )
        
        // 5. Edit Preferred Days
        AppShortcut(
            intent: EditPreferredDays(),
            phrases: [
                "Update \(.applicationName) jogging days",
                "Change which days I jog in \(.applicationName)", 
                "Set my preferred jogging days in \(.applicationName)"
            ],
            shortTitle: "Edit Days",
            systemImageName: "calendar"
        )
    }
}

// 1. Pre-Jog Duration Intent
struct EditPreJog: AppIntent, ProvidesDialog {
    var value: Never?
    
    @Parameter(title: "Duration in Minutes")
    var duration: Int
    
    static var title: LocalizedStringResource { "Edit Pre-Jog Duration" }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Set pre-jog duration to \(\.$duration) minutes")
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let container = try ModelContainer(
            for: PreferencesModel.self,
            configurations: ModelConfiguration(groupContainer: .identifier("group.swifter"))
        )
        let modelContext = container.mainContext
        let preferencesManager = PreferencesManager(modelContext: modelContext)
        
        if preferencesManager.fetchPreferences() != nil {
            preferencesManager.setPrejogTime(prejogTime: duration)
            return .result(dialog: "Updated pre-jog duration to \(duration) minutes")
        } else {
            throw IntentError("Preferences not found")
        }
    }
}

// 2. Time on Feet Intent
struct EditTimeOnFeet: AppIntent, ProvidesDialog {
    var value: Never?
    
    @Parameter(title: "Duration in Minutes")
    var duration: Int
    
    static var title: LocalizedStringResource { "Edit Time on Feet" }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Set jogging time to \(\.$duration) minutes")
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let container = try ModelContainer(
            for: PreferencesModel.self,
            configurations: ModelConfiguration(groupContainer: .identifier("group.swifter"))
        )
        let modelContext = container.mainContext
        let preferencesManager = PreferencesManager(modelContext: modelContext)
        
        if preferencesManager.fetchPreferences() != nil {
            preferencesManager.setJogTime(timeOnFeet: duration)
            return .result(dialog: "Updated jogging duration to \(duration) minutes")
        } else {
            throw IntentError("Preferences not found")
        }
    }
}

// 3. Post-Jog Duration Intent
struct EditPostJog: AppIntent, ProvidesDialog {
    var value: Never?
    
    @Parameter(title: "Duration in Minutes")
    var duration: Int
    
    static var title: LocalizedStringResource { "Edit Post-Jog Duration" }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Set post-jog duration to \(\.$duration) minutes")
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let container = try ModelContainer(
            for: PreferencesModel.self,
            configurations: ModelConfiguration(groupContainer: .identifier("group.swifter"))
        )
        let modelContext = container.mainContext
        let preferencesManager = PreferencesManager(modelContext: modelContext)
        
        if preferencesManager.fetchPreferences() != nil {
            preferencesManager.setPostjogTime(postjogTime: duration)
            return .result(dialog: "Updated post-jog duration to \(duration) minutes")
        } else {
            throw IntentError("Preferences not found")
        }
    }
}

// 4. Preferred Times Intent
struct EditPreferredTimes: AppIntent, ProvidesDialog {
    var value: Never?
    
    @Parameter(title: "Select Times of Day", description: "Choose one or more preferred times")
    var selectedTimes: [TimeOfDayIntent]
    
    static var title: LocalizedStringResource { "Edit Preferred Times of Day" }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Set preferred times to \(\.$selectedTimes)")
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let container = try ModelContainer(
            for: PreferencesModel.self, // Ensures PreferencesModel schema is loaded
            configurations: ModelConfiguration(groupContainer: .identifier("group.swifter"))
        )
        let modelContext = container.mainContext
        let preferencesManager = PreferencesManager(modelContext: modelContext)
        
        if let preferences = preferencesManager.fetchPreferences() {
            let modelTimes: [TimeOfDay] = selectedTimes.compactMap { intentTime in
                switch intentTime {
                case .morning: return .morning
                case .noon: return .noon
                case .afternoon: return .afternoon
                case .evening: return .evening
                }
            }
            
            preferencesManager.setTimesOfDay(timesOfDay: modelTimes)
            
            let timeNames = selectedTimes.map { $0.rawValue }.joined(separator: ", ")
            return .result(dialog: "Updated preferred times to: \(timeNames)")
        } else {
            throw IntentError("Preferences not found")
        }
    }
}

// 5. Preferred Days Intent
struct EditPreferredDays: AppIntent, ProvidesDialog {
    var value: Never?
    
    @Parameter(title: "Select Days of Week", description: "Choose one or more preferred days")
    var selectedDays: [DayOfWeekIntent]
    
    static var title: LocalizedStringResource { "Edit Preferred Days of Week" }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Set preferred days to \(\.$selectedDays)")
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let container = try ModelContainer(
            for: PreferencesModel.self, // Ensures PreferencesModel schema is loaded
            configurations: ModelConfiguration(groupContainer: .identifier("group.swifter"))
        )
        let modelContext = container.mainContext
        let preferencesManager = PreferencesManager(modelContext: modelContext)
        
        if let preferences = preferencesManager.fetchPreferences() {
            let modelDays: [DayOfWeek] = selectedDays.compactMap { $0.toModelDay() }
            
            preferencesManager.setDaysOfWeek(daysOfWeek: modelDays)
            
            let dayNames = selectedDays.map { $0.rawValue }.joined(separator: ", ")
            return .result(dialog: "Updated preferred days to: \(dayNames)")
        } else {
            throw IntentError("Preferences not found")
        }
    }
}

// Shared error struct
struct IntentError: Swift.Error, CustomStringConvertible {
    let description: String
    init(_ description: String) { self.description = description }
}

