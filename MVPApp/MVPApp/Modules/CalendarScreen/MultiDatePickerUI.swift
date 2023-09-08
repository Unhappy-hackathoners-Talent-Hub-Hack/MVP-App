import SwiftUI

struct MultiDatePickerUI: View {
    
    @StateObject var monthModel: ModelCalendar
    
    var body: some View {
        MonthView(monthDataModel: monthModel)
    }
    
    init(
        anyDays: Binding<[Date]>,
        includeDays: DateSelectionChoices = .allDays,
        minDate: Date? = nil,
        maxDate: Date? = nil
    ) {
        _monthModel = StateObject(
            wrappedValue: ModelCalendar(
                anyDays: anyDays,
                includeDays: includeDays,
                minDate: minDate,
                maxDate: maxDate
            )
        )
    }
    
    init(
        singleDay: Binding<Date>,
        includeDays: DateSelectionChoices = .allDays,
        minDate: Date? = nil,
        maxDate: Date? = nil
    ) {
        _monthModel = StateObject(
            wrappedValue: ModelCalendar(
                singleDay: singleDay,
                includeDays: includeDays,
                minDate: minDate,
                maxDate: maxDate
            )
        )
    }
    
    init(
        dateRange: Binding<ClosedRange<Date>?>,
        includeDays: DateSelectionChoices = .allDays,
        minDate: Date? = nil,
        maxDate: Date? = nil
    ) {
        _monthModel = StateObject(
            wrappedValue: ModelCalendar(
                includeDays: includeDays,
                minDate: minDate,
                maxDate: maxDate
            )
        )
    }
}

// MARK: - Types

extension MultiDatePickerUI {
    
    enum PickerType {
        case singleDay
        case anyDays
    }
    
    enum DateSelectionChoices {
        case allDays
        case weekendsOnly
        case weekdaysOnly
    }
    
}
