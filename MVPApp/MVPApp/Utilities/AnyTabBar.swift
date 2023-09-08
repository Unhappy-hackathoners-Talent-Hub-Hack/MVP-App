import SwiftUI

/**
 Type eraser which is used to represent
 any style of `TabBar's` bar.
 
 Use this type only when there is a necessity
 to represent any bar style.
 */
public struct AnyTabBarStyle: TabBarStyle {
    private let _makeTabBar: (GeometryProxy, @escaping () -> AnyView) -> AnyView
    
    public init<BarStyle: TabBarStyle>(barStyle: BarStyle) {
        self._makeTabBar = barStyle.tabBarErased
    }
    
    public func tabBar(with geometry: GeometryProxy, itemsContainer: @escaping () -> AnyView) -> some View {
        return self._makeTabBar(geometry, itemsContainer)
    }
}
