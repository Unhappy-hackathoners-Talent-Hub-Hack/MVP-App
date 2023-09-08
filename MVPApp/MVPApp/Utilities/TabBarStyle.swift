import SwiftUI

/**
 A type that represents tab bar style.
 
 This type is used by `TabBar` to apply custom
 styles to its bar. You can easily pass your
 custom bar style to `TabBar` by
 using `tabBar(style:)` function.
 */
public protocol TabBarStyle {
    associatedtype Content: View
    
    func tabBar(with geometry: GeometryProxy, itemsContainer: @escaping () -> AnyView) -> Content
}

extension TabBarStyle {
    func tabBarErased(with geometry: GeometryProxy, itemsContainer: @escaping () -> AnyView) -> AnyView {
        return .init(self.tabBar(with: geometry, itemsContainer: itemsContainer))
    }
}
