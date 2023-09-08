import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        @State var progress: Double = 0
        
        var body: some View {
            VStack {
                Spacer()
                ZStack {
                    
                    CircularProgressView(progress: progress)
                 
                    Text("\(progress * 100, specifier: "%.0f")")
                        .font(.largeTitle)
                        .bold()
                }.frame(width: 200, height: 200)
                Spacer()
                HStack {
                    // 4
                    Slider(value: $progress, in: 0...1)
                    // 5
                    Button("Reset") {
                        resetProgress()
                    }.buttonStyle(.borderedProminent)
                }
            }
        }
        
        func resetProgress() {
            progress = 0
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
