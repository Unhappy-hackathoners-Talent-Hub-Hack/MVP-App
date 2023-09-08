import Combine
import SwiftUI

// FIXME: Need a huge refactoring

final class ModelCalendar: NSObject, ObservableObject {
    
    @Published var days = [DayOfMonth]()
    @Published var title = ""
    @Published var selections = [Date]()
    
    var controlDate: Date = Date() {
        didSet {
            buildDays()
        }
    }
    
    let dayNames = Calendar.current.shortWeekdaySymbols
    
    // MARK: - PRIVATE VARS
    
    private var singleDayWrapper: Binding<Date>?
    private var anyDatesWrapper: Binding<[Date]>?
    private var dateRangeWrapper: Binding<ClosedRange<Date>?>?
    
    private var minDate: Date?
    private var maxDate: Date?
    
    // the type of date picker
    private var pickerType: MultiDatePickerUI.PickerType = .singleDay
    
    // which days are available for selection
    private var selectionType: MultiDatePickerUI.DateSelectionChoices = .allDays
    
    // the actual number of days in this calendar month/year (eg, 28 for February)
    private var numDays = 0
    
    // MARK: - INIT
    
    convenience init(
        anyDays: Binding<[Date]>,
        includeDays: MultiDatePickerUI.DateSelectionChoices,
        minDate: Date?,
        maxDate: Date?
    ) {
        self.init()
        self.anyDatesWrapper = anyDays
        self.selectionType = includeDays
        self.minDate = minDate
        self.maxDate = maxDate
        setAnyDays(anyDays.wrappedValue)
        
        if let useDate = anyDays.wrappedValue.first {
            controlDate = useDate
        }
        buildDays()
    }
    
    convenience init(
        singleDay: Binding<Date>,
        includeDays: MultiDatePickerUI.DateSelectionChoices,
        minDate: Date?,
        maxDate: Date?
    ) {
        self.init()
        self.singleDayWrapper = singleDay
        self.selectionType = includeDays
        self.minDate = minDate
        self.maxDate = maxDate
        setSingleDays(singleDay.wrappedValue)
        
        // set the controlDate to be this singleDay
        controlDate = singleDay.wrappedValue
        buildDays()
    }
    
    convenience init(
        includeDays: MultiDatePickerUI.DateSelectionChoices,
        minDate: Date?,
        maxDate: Date?
    ) {
        self.init()
        self.selectionType = includeDays
        self.minDate = minDate
        self.maxDate = maxDate
        
        buildDays()
    }
    
    func dayOfMonth(byDay: Int) -> DayOfMonth? {
        guard (1...31).contains(byDay) else { return nil }
        
        return days.first { $0.day == byDay }
    }

    func selectDay(_ day: DayOfMonth) {
        guard day.isSelectable else { return }
        guard let date = day.date else { return }
        
        switch pickerType {
                
        case .singleDay:
                selections = [date]
                singleDayWrapper?.wrappedValue = date
        case .anyDays:
                if selections.contains(date), let pos = selections.firstIndex(of: date) {
                    selections.remove(at: pos)
                } else {
                    selections.append(date)
                }
                selections.sort()
                anyDatesWrapper?.wrappedValue = selections
        }
    }
    
    func isSelected(_ day: DayOfMonth) -> Bool {
        guard day.isSelectable else { return false }
        guard let date = day.date else { return false }
        
        if pickerType == .anyDays || pickerType == .singleDay {
            for test in selections where isSameDay(date1: test, date2: date) {
                return true
            }
        } else {
            if selections.isEmpty {
                return false
            } else if selections.count == 1 {
                return isSameDay(date1: selections[0], date2: date)
            } else {
                let range = selections[0]...selections[1]
                return range.contains(date)
            }
        }
        return false
    }
    
    func increaseMonth() {
        let calendar = Calendar.current
        if let newDate = calendar.date(byAdding: .month, value: 1, to: controlDate) {
            controlDate = newDate
        }
    }
    
    func decreaseMonth() {
        let calendar = Calendar.current
        if let newDate = calendar.date(byAdding: .month, value: -1, to: controlDate) {
            controlDate = newDate
        }
    }
    
    func show(month: Int, year: Int) {
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: 1)
        if let newDate = calendar.date(from: components) {
            controlDate = newDate
        }
    }
}

// MARK: - BUILD DAYS

private extension ModelCalendar {
    
    func buildDays() {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: controlDate)
        let month = calendar.component(.month, from: controlDate)
        
        var daysArray = [DayOfMonth]()
        
        daysArray = appendPreviousMonthDays(to: daysArray, calendar: calendar, year: year, month: month)
        daysArray = appendCurrentMonthDays(to: daysArray, calendar: calendar, year: year, month: month)
        daysArray = appendNextMonthDays(to: daysArray, calendar: calendar, year: year, month: month)
        
        daysArray = Array(daysArray.suffix(35)) // Ограничение массива в 35 дней
        
        self.numDays = daysArray.count
        self.title = "\(calendar.monthSymbols[month - 1]) \(year)"
        self.days = daysArray
    }
    
    func appendPreviousMonthDays(to daysArray: [DayOfMonth], calendar: Calendar, year: Int, month: Int) -> [DayOfMonth] {
        var updatedDaysArray = daysArray
        
        let firstDayOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1))
        let firstWeekdayOfMonth = calendar.component(.weekday, from: firstDayOfMonth ?? Date())
        let today = Date()
        
        guard let previousMonth = calendar.date(byAdding: .month, value: -1, to: firstDayOfMonth ?? Date()),
              let previousMonthRange = calendar.range(of: .day, in: .month, for: previousMonth) else {
            return updatedDaysArray
        }
        
        let numDaysInPreviousMonth = previousMonthRange.count
        let startDayOfWeek = firstWeekdayOfMonth - calendar.firstWeekday
        let startIndex = numDaysInPreviousMonth - startDayOfWeek
        
        for index in startIndex..<numDaysInPreviousMonth {
            let realDate = calendar.date(from: DateComponents(year: year, month: month - 1, day: index + 1))
            var dom = DayOfMonth(index: -1, day: index + 1, date: realDate)
            dom.isPreviousOrNextMonth = true
            dom.isToday = isSameDay(date1: today, date2: realDate) &&
                calendar.isDate(realDate ?? Date(), equalTo: today, toGranularity: .day)
            dom.isSelectable = isEligible(date: realDate)
            updatedDaysArray.append(dom)
        }
        
        return updatedDaysArray
    }

    func appendCurrentMonthDays(to daysArray: [DayOfMonth], calendar: Calendar, year: Int, month: Int) -> [DayOfMonth] {
        var updatedDaysArray = daysArray

        let firstDayOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1))
        let today = Date()
        
        guard let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth ?? Date()) else {
            return updatedDaysArray
        }
        
        for indexOfDay in range {
            let realDate = calendar.date(from: DateComponents(year: year, month: month, day: indexOfDay))
            var dom = DayOfMonth(index: indexOfDay - 1, day: indexOfDay, date: realDate)
            dom.isToday = isSameDay(date1: today, date2: realDate) &&
                calendar.isDate(realDate ?? Date(), equalTo: today, toGranularity: .day)
            dom.isSelectable = isEligible(date: realDate)
            updatedDaysArray.append(dom)
        }
        
        return updatedDaysArray
    }

    func appendNextMonthDays(to daysArray: [DayOfMonth], calendar: Calendar, year: Int, month: Int) -> [DayOfMonth] {
        var updatedDaysArray = daysArray
        
        let firstDayOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1))
        let today = Date()
        
        guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: firstDayOfMonth ?? Date()),
              calendar.range(of: .day, in: .month, for: nextMonth) != nil else {
            return updatedDaysArray
        }
        
        let remainingDays = (42 - updatedDaysArray.count) % 7 // максимум отображение дней в календаре
        for index in 0..<remainingDays where index < remainingDays { // ограничение 5 недель
            let realDate = calendar.date(from: DateComponents(year: year, month: month + 1, day: index + 1))
            var dom = DayOfMonth(index: -1, day: index + 1, date: realDate)
            dom.isPreviousOrNextMonth = true
            dom.isToday = isSameDay(date1: today, date2: realDate) &&
            calendar.isDate(realDate ?? Date(), equalTo: today, toGranularity: .day)
            dom.isSelectable = isEligible(date: realDate)
            updatedDaysArray.append(dom)
        }
        
        return updatedDaysArray
    }
}

// MARK: - UTILITIES

private extension ModelCalendar {
    
    func setSingleDays(_ date: Date) {
        pickerType = .singleDay
        selections = [date]
    }
    
    func setAnyDays(_ anyDates: [Date]) {
        pickerType = .anyDays
        selections = anyDates
    }
    
    func isSameDay(date1: Date?, date2: Date?) -> Bool {
        guard let date1 = date1, let date2 = date2 else { return false }
        let day1 = Calendar.current.component(.day, from: date1)
        let day2 = Calendar.current.component(.day, from: date2)
        let year1 = Calendar.current.component(.year, from: date1)
        let year2 = Calendar.current.component(.year, from: date2)
        let month1 = Calendar.current.component(.month, from: date1)
        let month2 = Calendar.current.component(.month, from: date2)
        return (day1 == day2) && (month1 == month2) && (year1 == year2)
    }
    
    func isEligible(date: Date?) -> Bool {
        guard let date = date else { return true }
        
        if let minDate = minDate, let maxDate = maxDate {
            return (minDate...maxDate).contains(date)
        } else if let minDate = minDate {
            return date >= minDate
        } else if let maxDate = maxDate {
            return date <= maxDate
        }
        
        switch selectionType {
        case .weekendsOnly:
            let ord = Calendar.current.component(.weekday, from: date)
            return ord == 1 || ord == 7
        case .weekdaysOnly:
            let ord = Calendar.current.component(.weekday, from: date)
            return 1 < ord && ord < 7
        default:
            return true
        }
    }
}
