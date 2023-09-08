import SwiftUI
import SxUiKit

// FIXME: - Refactoring not needed logic

struct DayView: View {
    
    @ObservedObject var monthDataModel: ModelCalendar
    
    let currentIndex: Int
    
    var body: some View {
        Button(action: handleSelection) {
            calendarDayTitle
        }
        .foregroundColor(.label.secondary)
    }
    
    func handleSelection() {
        if currentDay.isSelectable {
            monthDataModel.selectDay(currentDay)
        }
    }
}

// MARK: - Current day

private extension DayView {
    
    var currentDay: DayOfMonth {
        monthDataModel.days[currentIndex]
    }
    
}

// MARK: - Views

private extension DayView {
    
    var calendarDayTitle: some View {
        Text("\(currentDay.day)")
            .frame(width: 36, height: 36)
            .foregroundColor(currentDay.isPreviousOrNextMonth ? .label.inert : textColor)
            .background(calendarDayBackground)
    }
    
    var calendarDayBackground: some View {
        Circle()
            .stroke(currentDay.isToday ? Color.label.secondary : .clear)
            .frame(width: 36, height: 36)
            .background(Circle().foregroundColor(monthDataModel.isSelected(currentDay) ? .label.secondary : .clear))
    }
}

// MARK: - Colors

private extension DayView {
   
    var textColor: Color {
        if currentDay.isSelectable {
            return monthDataModel.isSelected(currentDay) ? .label.optional : .label.secondary
        } else {
            return .label.secondary
        }
    }
}
