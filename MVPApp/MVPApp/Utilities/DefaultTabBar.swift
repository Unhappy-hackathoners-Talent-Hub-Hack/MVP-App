import SwiftUI

/**
 Default implementation of the `TabBarStyle` protocol.
 
 This style replicates the default `iOS` style of the
 bar of `UITabBar` and used in `TabBar` by default.
 */
public struct DefaultTabBarStyle: TabBarStyle {
    
    public func tabBar(with geometry: GeometryProxy, itemsContainer: @escaping () -> AnyView) -> some View {
        VStack(spacing: 0.0) {
            Divider()
            
            VStack {
                itemsContainer()
                    .frame(height: 50.0)
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
            }
            .background(
                Color(
                    red:   249 / 255,
                    green: 249 / 255,
                    blue:  249 / 255,
                    opacity: 0.94
                )
            )
            .frame(height: 50.0 + geometry.safeAreaInsets.bottom)
        }
    }
    
}
