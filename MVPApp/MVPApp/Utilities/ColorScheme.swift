import SwiftUI

struct ColorTheme {
    
    static var lastTheme = Theme(
        name: "yellow",
        gradient: Gradient(colors: [.white, Color(hex: 0xF3FF47).opacity(0.7)])
    )
    
    static let yellowTheme = Theme(
        name: "yellow",
        gradient: Gradient(colors: [.white, Color(hex: 0xF3FF47).opacity(0.7)])
    )

    static let blueTheme = Theme(
        name: "blue",
        gradient: Gradient(colors: [.white, .blue.opacity(0.7)])
    )
    
    static let redTheme = Theme(
        name: "red",
        gradient: Gradient(colors: [.white, .red.opacity(0.7)])
    )
}

struct Theme: Identifiable {
    let id = UUID()
    let name: String
    let gradient: Gradient
}

extension Theme: Equatable {
    static func == (lhs: Theme, rhs: Theme) -> Bool { lhs.id == rhs.id }
}
