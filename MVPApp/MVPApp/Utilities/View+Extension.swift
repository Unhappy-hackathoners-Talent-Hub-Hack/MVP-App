import SwiftUI

extension View {
    @ViewBuilder func visibility(_ visibility: TabBarVisibility) -> some View {
        switch visibility {
        case .visible:
            self.transition(.move(edge: .bottom))
        case .invisible:
            hidden().transition(.move(edge: .bottom))
        }
    }
}
