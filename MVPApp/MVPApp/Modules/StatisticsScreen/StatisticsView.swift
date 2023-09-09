import SwiftUI
import Charts

struct StatisticsView: View {
    
    @State private var progress: CGFloat = 0
    
    let todayStatusValues: [Double] = [0.5, 0.3, 0.6, 0.3, 1.0, 0.6, 0.8]
    let weekStatusValues: [Double] = [0.25, 0.38, 0.4, 0.45, 0.2, 0.9, 0.86]
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 40) {
                    
                    todayStatus
                    
                    weekStatus
                }
            }
            .padding(.top, 100)
            .padding(.horizontal, 40)
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

private extension StatisticsView {
    
    var backgroundGradient: some View {
        Rectangle()
            .animatableGradient(
                fromGradient: ColorTheme.lastTheme.gradient,
                toGradient: defaultTheme.gradient,
                progress: progress
            )
    }
    
    var defaultTheme: Theme {
        ColorTheme.blueTheme
    }
}

// MARK: - Charts

private extension StatisticsView {
    
    var todayStatus: some View {
        VStack {
            Text("Daily Status")
                .foregroundColor(.black)
                .bold()
            
            todayStatusChart
        }
    }
    
    var todayStatusChart: some View {
        Chart {
            RuleMark(y: .value("Limit", 1.0)).foregroundStyle(.black)
            
            ForEach(Array(todayStatusValues.enumerated()), id: \.offset) { index, value in
                LineMark(
                    x: .value("Index", index),
                    y: .value("Value", value)
                ).foregroundStyle(.black)
                
                PointMark(
                    x: .value("Index", index),
                    y: .value("Value", value)
                ).foregroundStyle(Color(hex: 0xF3FF47).opacity(0.7))
            }
        }
    }
    
    var weekStatus: some View {
        VStack {
            Text("Weekly Status")
                .foregroundColor(.black)
                .bold()
            
            weekStatusChart
        }
    }
    
    var weekStatusChart: some View {
        Chart {
            RuleMark(y: .value("Limit", 1.0)).foregroundStyle(.black)
            
            ForEach(Array(weekStatusValues.enumerated()), id: \.offset) { index, value in
                LineMark(
                    x: .value("Index", index),
                    y: .value("Value", value)
                ).foregroundStyle(.black)
                
                PointMark(
                    x: .value("Index", index),
                    y: .value("Value", value)
                ).foregroundStyle(Color(hex: 0xF3FF47).opacity(0.7))
            }
        }
    }
}
