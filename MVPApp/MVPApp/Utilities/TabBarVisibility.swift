import Foundation

/**
 Possible states of `TabBar's` visibility.
 
 If there is a need to hide `TabBar` you can use
 these states to control its visiblity. Changes could be
 animated by using `withAnimation` function.
 */
public enum TabBarVisibility: CaseIterable {
    /**
     After applying this state to `TabBar` it
     will be visible for the user.
     */
    case visible
    
    /**
     After applying this state to `TabBar` it will
     be hidden from the user.
     */
    case invisible
    
    /**
     A convenience function that is used to quickly switch
     between the visibility states.
     
     Use this function when you need to toggle current
     state: `visible` will become `invisible` and vice versa.
     */
    public mutating func toggle() {
        switch self {
        case .visible:
            self = .invisible
        case .invisible:
            self = .visible
        }
    }
}
