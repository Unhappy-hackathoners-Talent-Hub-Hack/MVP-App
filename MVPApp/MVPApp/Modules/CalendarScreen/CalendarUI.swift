import SwiftUI
import SxUiKit

struct CalendarUI: View {
    
    @State var selectDay = Date()
    @State var currentDate: Date
    
    let updateAction: (Date) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.background.overflow.ignoresSafeArea(.all)
            
            VStack {
                title
                MultiDatePickerUI(singleDay: $selectDay).tint(.label.secondary)
                
                VStack {
                    Divider().padding(.top, 23)
                    applyDateButton
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - Title

private extension CalendarUI {
    
    var title: some View {
        ZStack {
            HStack {
                todayButton
                Spacer()
                dismissButton
            }
            
            date
        }
        .padding(.top, 33)
    }
    
    var todayButton: some View {
        Button(action: handleSelection) {
            todayButtonDescription
        }
    }
    
    var todayButtonDescription: some View {
        HStack(spacing: 6) {
            calendarImage
            todayTitle
        }
        .padding(.leading, 30)
    }
    
    var calendarImage: some View {
        SxImage.calendar.image
            .frame(width: 24, height: 24)
            .foregroundColor(.label.secondary)
    }
    
    var date: some View {
        Text(R.CalendarView.date)
            .font(.h1.sxWeight(.medium))
            .foregroundColor(.label.primary)
    }
  
    func handleSelection() {
        dismiss()
        currentDate = selectDay
        updateAction(selectDay)
    }
}

// MARK: - Today

private extension CalendarUI {
  
    var todayTitle: some View {
        Text(R.CalendarView.today)
            .font(.bodyFont.sxWeight(.medium))
            .foregroundColor(.label.secondary)
    } 
}

// MARK: - Dismiss

private extension CalendarUI {
    
    var dismissButton: some View {
        Button(
            action: { dismiss() },
            label: { dismissTitle }
        )
        .padding(.trailing, 30)
    }
    
    var dismissTitle: some View {
        SxImage.close.image
            .frame(width: 36, height: 36)
            .background(Color.background.secondary)
            .foregroundColor(.accent.main)
            .clipShape(Capsule())
    }  
}

// MARK: - Apply date

private extension CalendarUI {
    
    var applyDateButton: some View {
        Button(action: handleSelection) {
            applyDateTitle
        }
        .padding(.top, 24)
        .padding(.bottom, 10)
    }
    
    var applyDateTitle: some View {
        Text(R.CalendarView.applyDate)
            .frame(maxWidth: .infinity)
            .frame(height: 65)
            .background(Color.accent.main)
            .foregroundColor(.label.optional)
            .cornerRadius(15)
    } 
}
