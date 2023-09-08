import Foundation

/**
 A type that represents an item of your `TabBar` component.
 */
public protocol Tabbable: Hashable {
    /// Icon name of `TabBar's` item.
    var icon: String { get }
    
    /// Selected icon name of `TabBar's` item.
    var selectedIcon: String { get }
    
    /// Title of `TabBar's` item.
    var title: String { get }
}

public extension Tabbable {
    var selectedIcon: String {
        return self.icon
    }
}
