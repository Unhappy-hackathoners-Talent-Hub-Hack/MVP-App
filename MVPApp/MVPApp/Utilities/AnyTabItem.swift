import SwiftUI

/**
 Type eraser which is used to represent
 any style of `TabBar's` item.
 
 Use this type only when there is a necessity
 to represent any item style.
 */
public struct AnyTabItemStyle: TabItemStyle {
    private let _makeTabItem: (String, String, String, Bool) -> AnyView
    
    public init<TabItem: TabItemStyle>(itemStyle: TabItem) {
        self._makeTabItem = itemStyle.tabItemErased(icon:selectedIcon:title:isSelected:)
    }
    
    public func tabItem(icon: String, selectedIcon: String, title: String, isSelected: Bool) -> some View {
        return self._makeTabItem(icon, selectedIcon, title, isSelected)
    }
}
