import SwiftUI
import SxUiKit

struct MonthView: View {
    
    @State private var showMonthYearPicker = false
    
    @ObservedObject var monthDataModel: ModelCalendar
    
    var body: some View {
        VStack {
            monthButtons.padding(.bottom, 30)
            calendar.padding(.horizontal, 20)
        }
        .padding(.top, 27)
    }
}

// MARK: - Title

private extension MonthView {
        
    var monthPicker: some View {
        Button(
            action: { showMonthYearPicker.toggle() },
            label: { monthPickerTitle }
        )
    }
    
    var monthPickerTitle: some View {
        HStack {
            Text(monthDataModel.title)
                .foregroundColor(.label.secondary)
                .font(.bodyFont.sxWeight(.medium))
        }
    }
    
    var monthButtons: some View {
        HStack {
            showPreviousMonthButton
            Spacer()
            monthPicker
            Spacer()
            showNextMonthButton
        }
        .padding(.horizontal, 32)
    }
    
    var calendar: some View {
        GeometryReader { _ in
            if showMonthYearPicker {
                MonthYearPicker(date: monthDataModel.controlDate) { month, year in
                    monthDataModel.show(month: month, year: year)
                }
            } else {
                ContentPickerView(monthDataModel: monthDataModel)
            }
        }
    }
    
}

// MARK: - Previous month

private extension MonthView {
    
    var showPreviousMonthButton: some View {
        Button(
            action: { showPreviousMonth() },
            label: { showPreviousMonthButtonImage }
        )
    }
    
    var showPreviousMonthButtonImage: some View {
        SxImage.arrowLeft.image.foregroundColor(.label.primary)
    }
    
    func showPreviousMonth() {
        withAnimation {
            monthDataModel.decreaseMonth()
            showMonthYearPicker = false
        }
    }
    
}

// MARK: - Next month

private extension MonthView {
    
    var showNextMonthButton: some View {
        Button(
            action: { showNextMonth() },
            label: { SxImage.arrowRight.image.foregroundColor(.label.primary) }
        )
    }
    
    func showNextMonth() {
        withAnimation {
            monthDataModel.increaseMonth()
            showMonthYearPicker = false
        }
    }
    
}
