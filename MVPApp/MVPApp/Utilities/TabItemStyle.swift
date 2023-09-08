import SwiftUI

/**
 A type that represents tab item style.
 
 This type is used by `TabBar` to apply custom styles to its items.
 You can easily pass your custom item style to `TabBar` by
 using `tabItem(style:)` function.
 */
public protocol TabItemStyle {
    associatedtype Content : View
    
    func tabItem(icon: String, title: String, isSelected: Bool) -> Content
    func tabItem(icon: String, selectedIcon: String, title: String, isSelected: Bool) -> Content
}

extension TabItemStyle {
    public func tabItem(icon: String, title: String, isSelected: Bool) -> Content {
        return self.tabItem(icon: icon, selectedIcon: icon, title: title, isSelected: isSelected)
    }
    
    public func tabItem(icon: String, selectedIcon: String, title: String, isSelected: Bool) -> Content {
        return self.tabItem(icon: icon, title: title, isSelected: isSelected)
    }
    
    func tabItemErased(icon: String, selectedIcon: String, title: String, isSelected: Bool) -> AnyView {
        return .init(self.tabItem(icon: icon, selectedIcon: selectedIcon, title: title, isSelected: isSelected))
    }
}
