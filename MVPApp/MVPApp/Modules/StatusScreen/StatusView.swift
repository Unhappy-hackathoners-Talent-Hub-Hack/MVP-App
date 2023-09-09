import SwiftUI
import CoreML

struct StatusView: View {
    
    @StateObject private var viewModel = StatusViewModel()
    
    @State var showModal: Bool = false
    
    @State private var isStatusChecked = false
    @State private var progress: CGFloat = 0
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            VStack(spacing: 60) {
                StatusBar(isStartDrawn: $isStatusChecked, statusPercent: $viewModel.statusPercent)
                
                updateButton
                
                alert.background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(.black, lineWidth: 2)
                        .blur(radius: 0.5)
                        .padding(-10)
                )
                
                Spacer()
            }
            .padding(100)
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
            viewModel.updatePredictedPrice(model_ADInput(dense_3_input: convertToMLMultiArray(from: [0.1, 0, 0.1, 0.1, 0.1, 0.1, 0, 0, 0.1, 0.1])))
            isStatusChecked = true
        }
        .onDisappear {
            progress = 0.0
        }
        .overlay(ModalView(showModal: $showModal))
    }
    
    func convertToMLMultiArray(from array: [Double]) -> MLMultiArray {
        let length = NSNumber(value: array.count)
        
        // Define shape of array
        guard let mlMultiArray = try? MLMultiArray(shape:[1, length], dataType:MLMultiArrayDataType.double) else {
            fatalError("Unexpected runtime error. MLMultiArray")
        }
        
        // Insert elements
        for (index, element) in array.enumerated() {
            mlMultiArray[index] = NSNumber(floatLiteral: element)
        }
        
        return mlMultiArray
    }
}

// MARK: - Background Gradient

private extension StatusView {
    
    var backgroundGradient: some View {
        Rectangle()
            .animatableGradient(
                fromGradient: ColorTheme.lastTheme.gradient,
                toGradient: defaultTheme.gradient,
                progress: progress
            )
    }
    
    var defaultTheme: Theme {
        ColorTheme.yellowTheme
    }
}

// MARK: - Update Status Button

private extension StatusView {
    
    var updateButton: some View {
        Button(
            action: {
                isStatusChecked.toggle()
                //showModal.toggle()
                viewModel.updatePredictedPrice(model_ADInput(dense_3_input: convertToMLMultiArray(from: [randomNumber, randomNumber, randomNumber, randomNumber, randomNumber, randomNumber, randomNumber, randomNumber, randomNumber, randomNumber])))
            },
            label: { updateButtonTitle }
        )
    }
    
    var updateButtonTitle: some View {
        Text("Update Status")
            .foregroundColor(.black)
            .padding()
            .background {
                Capsule()
                    .stroke(.black, lineWidth: 1.5)
                    .blur(radius: 0.5)
            }
    }
    
    var randomNumber: Double {
        Double.random(in: 0...1.0)
    }
}

// MARK: - Status Alerts

private extension StatusView {
    
    @ViewBuilder
    var alert: some View {
        switch viewModel.statusPercent {
        case 0.0...0.125:
            perfectAlert
        case 0.126...0.25:
            goodAlert
        case 0.26...0.5:
            mediumAlert
        case 0.6...0.75:
            badAlert
        case 0.76...0.99:
            awfulAlert
        case 1.0:
            deadAlert
        default:
            EmptyView()
        }
    }
    
    var perfectAlert: some View {
        VStack {
            Text("Perfect.")
                .foregroundColor(.black)
                .bold()
            Text("Great scores! Don't forget to stretch your working muscle group at the end of your workout!").foregroundColor(.black)
        }
    }
    
    var goodAlert: some View {
        VStack {
            Text("Good.")
                .foregroundColor(.black)
                .bold()
            Text("You're in great shape! You can devote training to individual muscle groups.").foregroundColor(.black)
        }
    }
    
    var mediumAlert: some View {
        VStack {
            Text("Medium.")
                .foregroundColor(.black)
                .bold()
            Text("There are strengths, but they must be protected! Pay attention to individual muscle groups, alternating this with flexibility exercises.").foregroundColor(.black)
        }
    }
    
    var badAlert: some View {
        VStack {
            Text("Bad.")
                .foregroundColor(.black)
                .bold()
            Text("You should avoid overly strenuous activities! Diversify your activities with coordination exercises, paying attention to different muscle groups.").foregroundColor(.black)
        }
    }
    
    var awfulAlert: some View {
        VStack {
            Text("Awful.")
                .foregroundColor(.black)
                .bold()
            Text("It's worth saving your energy! Continue to focus on your heart health and flexibility exercises!").foregroundColor(.black)
        }
    }
    
    var deadAlert: some View {
        VStack {
            Text("You are dead.")
                .foregroundColor(.black)
                .bold()
            Text("Rest, rest and more rest! Dedicate the day to recreational activities to fully restore your body!").foregroundColor(.black)
        }
    }
}

struct ModalView: View { // draws a semi-transparent rectangle that contains the modal
    @Binding var showModal: Bool

    var body: some View {
        Group {
            if showModal {
                Rectangle()
                    .foregroundColor(Color.black.opacity(0.5))
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        GeometryReader { geometry in
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundColor(.white)
                                .frame(width: min(geometry.size.width - 100, 300), height: min(geometry.size.height - 100, 200))
                                .overlay(ModalContentView(showModal: self.$showModal))
                        }
                )
            }
        }
    }
}

struct ModalContentView: View { // the real modal content
    @Binding var showModal: Bool

    var body: some View {
        VStack {
            Text("Modal Content")

            Button(action: {
                self.showModal.toggle()
            }) {
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                    Text("Close Modal")
                }
            }
        }
    }
}
