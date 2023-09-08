import SwiftUI
import SxUiKit

struct ContentPickerView: View {
    
    @ObservedObject var monthDataModel: ModelCalendar
    
    private let columns = [
        GridItem(.fixed(30), spacing: 22),
        GridItem(.fixed(30), spacing: 22),
        GridItem(.fixed(30), spacing: 22),
        GridItem(.fixed(30), spacing: 22),
        GridItem(.fixed(30), spacing: 22),
        GridItem(.fixed(30), spacing: 22),
        GridItem(.fixed(30), spacing: 22)
    ]
    
    var body: some View {
        VStack {
            dayOfTheWeek
            Divider().padding(.top, 10)
            calendar
        }
    }
}

// MARK: - Setup calendar

private extension ContentPickerView {
    
    var dayOfTheWeek: some View {
        LazyVGrid(columns: columns) {
            ForEach(monthDataModel.dayNames, id: \.self) { dayName in
                Text(dayName.uppercased())
                    .font(.descriptionM.sxWeight(.medium))
                    .foregroundColor(.label.inert)
            }
        }
    }

    var calendar: some View {
        LazyVGrid(columns: columns) {
            ForEach(0..<monthDataModel.days.count, id: \.self) { index in
                DayView(monthDataModel: monthDataModel, currentIndex: index)
            }
        }
        .padding(.top, 23)
    }
}
