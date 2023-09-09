import SwiftUI

struct ProfileView: View {
    
    @State private var progress: CGFloat = 0
    
    @State private var messages: [Message] = [
        Message(content: "Musculoskeletal system"),
        Message(content: "Visually impaired")
    ]
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            AvatarView(image: Image(systemName: "person.circle.fill"), size: 200).padding(.bottom, 450)
            
            List {
                Section(header: Text("Peculiarities")) {
                    ForEach(messages, id: \.id) { message in
                        Text(message.content)
                    }.listRowBackground(Color.red.opacity(0.4))
                    
                }
            }
            .scrollContentBackground(.hidden)
            .background(.clear)
            .padding(.top, 300)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        .onAppear {
            withAnimation(.linear(duration: 1.0)) {
                progress = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                ColorTheme.lastTheme = defaultTheme
            }
        }
        .onDisappear {
            progress = 0.0
        }
    }
}

// MARK: - Background Gradient

private extension ProfileView {
    
    var backgroundGradient: some View {
        Rectangle()
            .animatableGradient(
                fromGradient: ColorTheme.lastTheme.gradient,
                toGradient: defaultTheme.gradient,
                progress: progress
            )
    }
    
    var defaultTheme: Theme {
        ColorTheme.redTheme
    }
}

struct AvatarView: View {
    let image: Image
    let size: CGFloat
    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .cornerRadius(size / 2)
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 4)
                    .frame(width: size, height: size)
            )
            .shadow(radius: 10)
    }
}


struct Message {
    let id = UUID()
    let content: String
}
