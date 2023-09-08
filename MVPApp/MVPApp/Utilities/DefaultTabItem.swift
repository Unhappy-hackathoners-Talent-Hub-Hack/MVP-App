import SwiftUI

/**
 Default implementation of the `TabItemStyle` protocol.
 
 This style replicates the default `iOS` style of the
 items of `UITabBar` and used in `TabBar` by default.
 */
public struct DefaultTabItemStyle: TabItemStyle {
    public func tabItem(icon: String, selectedIcon: String, title: String, isSelected: Bool) -> some View {
        VStack(spacing: 5.0) {
            Image(systemName: icon)
                .renderingMode(.template)
            
            Text(title)
                .font(.system(size: 10.0, weight: .medium))
        }
        .foregroundColor(isSelected ? .accentColor : .gray)
    }
}
