import Foundation

enum TabItems: Int, CaseIterable {
    case statistics
    case status
    case profile
    
    var title: String {
        switch self {
        case .statistics:
            return "Statistics"
        case .status:
            return "Status"
        case .profile:
            return "Profile"
        }
    }
    
    var icon: String {
        switch self {
        case .statistics:
            return "chart.pie"
        case .status:
            return "heart"
        case .profile:
            return "brain.head.profile"
        }
    }
}

