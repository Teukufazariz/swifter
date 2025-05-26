import SwiftUI
import SwiftData

struct EditPreferencesModal: View {
    @Binding var isPresented: Bool

    var modelContext: ModelContext
    @Query private var preferences: [PreferencesModel]

    @State private var selectedTimesOfDay: Set<TimeOfDay> = []
    @State private var selectedDaysOfWeek: Set<DayOfWeek> = []
    @State private var avgTimeOnFeet: Int = 30
    @State private var preJogDuration: Int = 15
    @State private var postJogDuration: Int = 15
    
    // States for time picker visibility
    @State private var showingAvgTimeOnFeetPicker = false
    @State private var showingPreJogDurationPicker = false
    @State private var showingPostJogDurationPicker = false
    
    @State private var showingTimesOfDayPicker = false
    @State private var showingDaysOfWeekPicker = false

    @State private var showSaveAlert = false

    private let columns = Array(repeating: GridItem(.flexible()), count: 4)

    private var currentPreference: PreferencesModel? {
        preferences.first
    }

    var onSave: () -> Void

    init(isPresented: Binding<Bool>, modelContext: ModelContext, onSave: @escaping () -> Void) {
        self._isPresented = isPresented
        self.modelContext = modelContext
        self.onSave = onSave
    }

    var body: some View {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header
                        HStack {
                            Button(action: { isPresented = false }) {
                                Text("Cancel")
                                    .font(.headline)
                                    .foregroundColor(.red)
                            }
                            Spacer()
                            Text("Edit Preferences")
                                .font(.headline)
                            Spacer()
                            Text("Cancel")
                                    .font(.headline)
                                    .opacity(0)
//                            Button(action: { showSaveAlert = true }) {
//                                Text("Save")
//                                    
//                                    .font(.headline)
//                                    .foregroundColor(.primary)
//                            }
//                            .alert(isPresented: $showSaveAlert) {
//                                Alert(
//                                    title: Text("Save Changes?"),
//                                    message: Text("Are you sure you want to save your preferences?"),
//                                    primaryButton: .default(Text("OK")) {
//                                        updatePreference()
//                                        onSave()
//                                        isPresented = false
//                                    },
//                                    secondaryButton: .cancel()
//                                )
//                            }
                        }

                        VStack(alignment: .leading, spacing: 20) {
                            // Avg Time On Feet Section
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Average Time On Feet")
                                        .font(.subheadline)
                                        .bold()
                                    Text("*")
                                        .foregroundColor(.red)
                                    
                                    Spacer()
                                    
                                    TimePickerButton(
                                        value: $avgTimeOnFeet,
                                        isShowingPicker: $showingAvgTimeOnFeetPicker,
                                        minValue: 5,
                                        maxValue: 120,
                                        step: 5,
                                        unit: "min",
                                        onValueChange: updatePreference
                                    )
                                }
                            
                                // Modern time picker design
//                                TimePickerButton(
//                                    value: $avgTimeOnFeet,
//                                    isShowingPicker: $showingAvgTimeOnFeetPicker,
//                                    minValue: 5,
//                                    maxValue: 120,
//                                    step: 5,
//                                    unit: "minutes",
//                                    onValueChange: updatePreference
//                                )
                            }

                            // Avg Pre Jog Duration Section
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Average Pre Jog Duration")
                                        .font(.subheadline)
                                        .bold()
                                    
                                    Spacer()
                                    
                                    TimePickerButton(
                                        value: $preJogDuration,
                                        isShowingPicker: $showingPreJogDurationPicker,
                                        minValue: 0,
                                        maxValue: 60,
                                        step: 5,
                                        unit: "min",
                                        onValueChange: updatePreference
                                    )
                                }
                                
                               
                            }

                            // Avg Post Jog Duration Section
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Average Post Jog Duration")
                                        .font(.subheadline)
                                        .bold()
                                    Spacer()
                                    TimePickerButton(
                                        value: $postJogDuration,
                                        isShowingPicker: $showingPostJogDurationPicker,
                                        minValue: 0,
                                        maxValue: 60,
                                        step: 5,
                                        unit: "min",
                                        onValueChange: updatePreference
                                        )
                                }
                            }
                            
                            // Times of Day Section - Now using NavigationLink
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Preferred Times of Day")
                                    .font(.subheadline)
                                    .bold()
                                Button(action: {
                                    showingTimesOfDayPicker = true
                                }) {
                                    HStack {
                                        selectionSummaryText(for: selectedTimesOfDay.map { $0.rawValue })
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 16)
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(10)
                                }
                                .sheet(isPresented: $showingTimesOfDayPicker) {
                                    TimesOfDaySelectionView(
                                        selectedTimes: $selectedTimesOfDay,
                                        onSave: {
                                            updatePreference()
                                            showingTimesOfDayPicker = false
                                        }
                                    )
                                }
                            }
                            
                            
                            
                            // Days of Week Section
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Preferred Days of the Week")
                                    .font(.subheadline)
                                    .bold()
                                Button(action: {
                                    showingDaysOfWeekPicker = true
                                }) {
                                    HStack {
                                        selectionSummaryText(for: selectedDaysOfWeek.map { $0.name })
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 16)
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(10)
                                }
                                .sheet(isPresented: $showingDaysOfWeekPicker) {
                                    DaysOfWeekSelectionView(
                                        selectedDays: $selectedDaysOfWeek,
                                        onSave: {
                                            updatePreference()
                                            showingDaysOfWeekPicker = false
                                        }
                                    )
                                }
                            }
//                            VStack(alignment: .leading, spacing: 10) {
//                                Text("Preferred Days of the Week")
//                                    .font(.subheadline)
//                                    .bold()
//
//                                LazyVGrid(columns: columns, spacing: 8) {
//                                    ForEach(DayOfWeek.allCases) { day in
//                                        DayButton(
//                                            title: day.name.prefix(3),
//                                            isSelected: selectedDaysOfWeek.contains(day),
//                                            action: { toggleDayOfWeek(day) }
//                                        )
//                                    }
//                                }
//                                .padding(.bottom, 5)
//                            }
                        }

                        Button(action: {
                            showSaveAlert = true
                        }) {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top, 10)
                        .alert(isPresented: $showSaveAlert) {
                            Alert(
                                title: Text("Save Changes?"),
                                message: Text("Are you sure you want to save your preferences?"),
                                primaryButton: .default(Text("OK")) {
                                    updatePreference()
                                    onSave()
                                    isPresented = false
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                    .padding(20)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.horizontal, 20)
                .frame(maxHeight: UIScreen.main.bounds.height * 0.75)
            }
            .frame(maxWidth: 700)
            .transition(.move(edge: .bottom))
            .onAppear {
                loadPreferenceData()
                if let prefs = currentPreference {
                    selectedTimesOfDay = Set(prefs.preferredTimesOfDay)
                    selectedDaysOfWeek = Set(prefs.preferredDaysOfWeek ?? [])
                    avgTimeOnFeet = prefs.jogDuration
                    preJogDuration = prefs.preJogDuration
                    postJogDuration = prefs.postJogDuration
                }
            }
    }
    
    private func selectionSummaryText(for items: [String]) -> Text {
        // Check if empty
        if items.isEmpty {
            return Text("None selected")
                .foregroundColor(.secondary)
        }
        
        // Check if this is days of week
        let isDaysOfWeek = items.first?.contains("day") ?? false
        
        // Check if this is times of day
        let isTimesOfDay = items.first?.contains("Morning") ?? false || 
                           items.first?.contains("Noon") ?? false ||
                           items.first?.contains("Afternoon") ?? false ||
                           items.first?.contains("Evening") ?? false
        
        if isDaysOfWeek {
            // Process days of week as before
            let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
            let weekend = ["Saturday", "Sunday"]
            let allDays = weekdays + weekend
            
            let sortedItems = items.sorted { day1, day2 in
                let order = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
                return order.firstIndex(of: day1)! < order.firstIndex(of: day2)!
            }
                    
            if items.count == 7 || Set(items) == Set(allDays) {
                return Text("Every day")
            } else if Set(items) == Set(weekdays) {
                return Text("Weekdays")
            } else if Set(items) == Set(weekend) {
                return Text("Weekends")
            } else if items.count <= 6 {
                // Abbreviate day names for small selections
                let abbreviated = sortedItems.map { String($0.prefix(3)) }
                return Text(abbreviated.joined(separator: ", "))
            } else {
                return Text("\(items.count) days")
            }
        } else if isTimesOfDay {
            // Custom abbreviations for times of day
            let abbreviations: [String: String] = [
                "Morning": "Morn",
                "Noon": "Noon", 
                "Afternoon": "Aft",
                "Evening": "Eve"
            ]
            
            // Sort times of day in chronological order
            let sortedItems = items.sorted { time1, time2 in
                let order = ["Morning", "Noon", "Afternoon", "Evening"]
                return order.firstIndex(of: time1)! < order.firstIndex(of: time2)!
            }
            
            if items.count == 4 {
                return Text("All day")
            } else if items.count <= 3 {
                // Use abbreviations for selected times
                let abbreviated = sortedItems.map { abbreviations[$0] ?? $0 }
                return Text(abbreviated.joined(separator: ", "))
            } else {
                return Text("\(items.count) times")
            }
        } else if items.count <= 2 {
            return Text(items.joined(separator: ", "))
        } else {
            return Text("\(items.count) selected")
        }
    }

    private func loadPreferenceData() {
        guard let preference = currentPreference else { return }
        selectedTimesOfDay = Set(preference.preferredTimesOfDay)
        selectedDaysOfWeek = Set(preference.preferredDaysOfWeek ?? [])
        avgTimeOnFeet = preference.jogDuration
        preJogDuration = preference.preJogDuration
        postJogDuration = preference.postJogDuration
    }

    private func updatePreference() {
        guard let preference = currentPreference else { return }

        preference.preferredTimesOfDay = Array(selectedTimesOfDay)
        preference.preferredDaysOfWeek = Array(selectedDaysOfWeek)
        preference.jogDuration = avgTimeOnFeet
        preference.preJogDuration = preJogDuration
        preference.postJogDuration = postJogDuration

        do {
            try modelContext.save()
            print("✅ Preferences updated successfully")
        } catch {
            print("❌ Failed to save preferences: \(error)")
        }
    }

    private func toggleTimeOfDay(_ time: TimeOfDay) {
        if selectedTimesOfDay.contains(time) {
            selectedTimesOfDay.remove(time)
        } else {
            selectedTimesOfDay.insert(time)
        }
        updatePreference()
    }

    private func toggleDayOfWeek(_ day: DayOfWeek) {
        if selectedDaysOfWeek.contains(day) {
            selectedDaysOfWeek.remove(day)
        } else {
            selectedDaysOfWeek.insert(day)
        }
        updatePreference()
    }
}

// MARK: - Times of Day Selection View
struct TimesOfDaySelectionView: View {
    @Binding var selectedTimes: Set<TimeOfDay>
    @Environment(\.dismiss) private var dismiss
    var onSave: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                ForEach(TimeOfDay.allCases) { time in
                    Button(action: {
                        toggleSelection(time)
                    }) {
                        HStack {
                            Text(time.rawValue)
                                .foregroundColor(.primary)
                            Spacer()
                            if selectedTimes.contains(time) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
//                    .listRowBackground(selectedTimes.contains(time) ? Color(.systemGray6) : nil)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Select Times")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onSave()
                    }
                }
            }
        }
        .presentationDetents([.height(350), .medium])
    }
    
    private func toggleSelection(_ time: TimeOfDay) {
        if selectedTimes.contains(time) {
            selectedTimes.remove(time)
        } else {
            selectedTimes.insert(time)
        }
    }
}

// MARK: - Days of Week Selection View
struct DaysOfWeekSelectionView: View {
    @Binding var selectedDays: Set<DayOfWeek>
    @Environment(\.dismiss) private var dismiss
    var onSave: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                ForEach(DayOfWeek.allCases) { day in
                    Button(action: {
                        toggleSelection(day)
                    }) {
                        HStack {
                            Text(day.name)
                                .foregroundColor(.primary)
                            Spacer()
                            if selectedDays.contains(day) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
//                    .listRowBackground(selectedDays.contains(day) ? Color(.systemGray6) : nil)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Select Days")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onSave()
                    }
                }
            }
        }
        .presentationDetents([.height(500), .medium])
    }
    
    private func toggleSelection(_ day: DayOfWeek) {
        if selectedDays.contains(day) {
            selectedDays.remove(day)
        } else {
            selectedDays.insert(day)
        }
    }
}

// MARK: - Time Picker Components

struct TimePickerButton: View {
    @Binding var value: Int
    @Binding var isShowingPicker: Bool
    let minValue: Int
    let maxValue: Int
    let step: Int
    let unit: String
    let onValueChange: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation {
                    isShowingPicker.toggle()
                }
            }) {
                HStack {
                    Text("\(value) \(unit)")
                        .font(.system(size: 16, weight: .medium))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    
//                    Spac
//                    er()
//                    Image(systemName: isShowingPicker ? "chevron.up" : "chevron.down")
//                        .foregroundColor(.primary)
//                        .font(.system(size: 14, weight: .medium))
//                        .frame(width: 30)
//                        .padding(.trailing, 8)
                }
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color(.systemGray4), lineWidth: 1)
//                )
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $isShowingPicker) {
                NavigationView {
                    VStack {
                        TimePickerView2(
                            value: $value,
                            minValue: minValue,
                            maxValue: maxValue,
                            step: step,
                            unit: unit,
                            onValueChange: onValueChange
                        )
                        .padding()
                        
                        Spacer()
                    }
                    .navigationTitle("Select \(unit.capitalized)")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                isShowingPicker = false
                            }
                        }
                    }
                }
                .presentationDetents([.height(350), .medium])
            }
//            
//            if isShowingPicker {
//                TimePickerView2(
//                    value: $value,
//                    minValue: minValue,
//                    maxValue: maxValue,
//                    step: step,
//                    unit: unit,
//                    onValueChange: onValueChange
//                )
//                .padding(.top, 8)
//                .transition(.opacity)
//            }
        }
    }
}

struct TimePickerView: View {
    @Binding var value: Int
    let minValue: Int
    let maxValue: Int
    let step: Int
    let unit: String
    let onValueChange: () -> Void
    
    // Generate available values based on min, max and step
    private var availableValues: [Int] {
        stride(from: minValue, through: maxValue, by: step).map { $0 }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Slider
            HStack {
                Text("\(minValue)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Slider(
                    value: Binding(
                        get: {
                            Double(availableValues.firstIndex(of: value) ?? 0)
                        },
                        set: { newPosition in
                            if let newIndex = Int(exactly: newPosition),
                               newIndex >= 0 && newIndex < availableValues.count {
                                value = availableValues[newIndex]
                                onValueChange()
                            }
                        }
                    ),
                    in: 0...Double(availableValues.count - 1),
                    step: 1
                )
                .accentColor(.accentColor)
                
                Text("\(maxValue)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Value selection buttons
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(availableValues, id: \.self) { timeValue in
                        Button(action: {
                            value = timeValue
                            onValueChange()
                        }) {
                            Text("\(timeValue)")
                                .font(.system(size: 15, weight: .medium))
                                .frame(width: 44, height: 44)
                                .background(value == timeValue ? Color.accentColor : Color(UIColor.tertiarySystemBackground))
                                .foregroundColor(value == timeValue ? .white : .primary)
                                .cornerRadius(22)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .padding(12)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct TimePickerView2: View {
    @Binding var value: Int
    let minValue: Int
    let maxValue: Int
    let step: Int
    let unit: String
    let onValueChange: () -> Void
    
    private var availableValues: [Int] {
        stride(from: minValue, through: maxValue, by: step).map { $0 }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Picker("Select \(unit)", selection: $value) {
                    ForEach(availableValues, id: \.self) { timeValue in
                        Text("\(timeValue)")
                            .tag(timeValue)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
        }
    }
}

// MARK: - Original Buttons (Unchanged)

struct TimeButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13))
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.primary : Color.clear)
                .foregroundColor(isSelected ? Color(UIColor.systemBackground) : Color.primary)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.primary, lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DayButton: View {
    let title: String.SubSequence
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13))
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.primary : Color.clear)
                .foregroundColor(isSelected ? Color(UIColor.systemBackground) : Color.primary)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.primary, lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

#Preview {
    let container: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            let container = try ModelContainer(for: PreferencesModel.self, configurations: config)
            let samplePreference = PreferencesModel(
                timeOnFeet: 15,
                preJogDuration: 15,
                postJogDuration: 10,
                timeOfDay: [.morning, .evening],
                dayOfWeek: [.monday, .wednesday, .friday]
            )
            container.mainContext.insert(samplePreference)
            return container
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }()

    return EditPreferencesModal(isPresented: .constant(true), modelContext: container.mainContext, onSave: {})
}
