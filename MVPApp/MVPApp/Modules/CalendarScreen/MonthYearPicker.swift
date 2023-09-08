import SwiftUI

struct MonthYearPicker: View {
    
    @State private var selectedMonth = 0
    @State private var selectedYear = 2020
    
    private var action: (Int, Int) -> Void
    private var date: Date
    
    private let months = Array(0...11)
    private let years = Array(2020...2030)
        
    var body: some View {
        HStack(spacing: 20) {
            monthPicker
            yearsPicker
        }
        .padding(.leading, 30)
    }
    
    init(date: Date, action: @escaping (Int, Int) -> Void) {
        self.date = date
        self.action = action
        
        let month = getMonth(from: date)
        let year = getYear(from: date)
        
        self._selectedMonth = State(initialValue: month - 1)
        self._selectedYear = State(initialValue: year)
    }

    private func getMonth(from date: Date) -> Int {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        return month
    }

    private func getYear(from date: Date) -> Int {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        return year
    }
}

// MARK: - Pickers

private extension MonthYearPicker {
    
    var monthPicker: some View {
        Picker("", selection: $selectedMonth) {
            ForEach(months, id: \.self) { month in
                Text("\(Calendar.current.monthSymbols[month])")
            }
        }
        .onChange(of: selectedMonth) { value in
            action(value + 1, selectedYear)
        }
    }
    
    var yearsPicker: some View {
        Picker("", selection: $selectedYear) {
            ForEach(years, id: \.self) { year in
                Text(String(format: "%d", year))
            }
        }
        .onChange(of: selectedYear) { value in
            action(selectedMonth + 1, value)
        }
    }
}
