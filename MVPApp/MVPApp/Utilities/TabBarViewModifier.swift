import SwiftUI

struct TabBarViewModifier<TabItem: Tabbable>: ViewModifier {
    @EnvironmentObject private var selectionObject: TabBarSelection<TabItem>
    
    let item: TabItem
    
    func body(content: Content) -> some View {
        Group {
            if self.item == self.selectionObject.selection {
                content
            } else {
                Color.clear
            }
        }
        .preference(key: TabBarPreferenceKey.self, value: [self.item])
    }
}

extension View {
    /**
     A function that is used to associated view with the passed item.
     
     Use this function to associate view with the specific item
     of the `TabBar`.
     */
    public func tabItem<TabItem: Tabbable>(for item: TabItem) -> some View {
        return self.modifier(TabBarViewModifier(item: item))
    }
}
