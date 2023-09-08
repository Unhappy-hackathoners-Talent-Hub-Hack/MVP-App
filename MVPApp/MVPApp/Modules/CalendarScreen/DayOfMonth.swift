import Foundation

struct DayOfMonth: Hashable {
    var index = 0
    var day = 0
    var date: Date?
    var isSelectable = false
    var isToday = false
    var isPreviousOrNextMonth = false
}
