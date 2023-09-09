import Foundation
import CoreML
import SwiftUI

final class StatusViewModel: ObservableObject {
    
    let model = try? model_AD(configuration: MLModelConfiguration())
    
    @Published var statusPercent: CGFloat = 0
    
    func updatePredictedPrice(_ input: model_ADInput) {
        guard let modelOutput = try? model?.prediction(input: input) else {
            print(model)
            fatalError("kek")
        }

        statusPercent = CGFloat(convertToArray(from: modelOutput.Identity).first ?? 0)
    }
    
    func convertToArray(from mlMultiArray: MLMultiArray) -> [Double] {
        var array: [Double] = []
        
        let length = mlMultiArray.count
        
        for i in 0...length - 1 {
            array.append(Double(truncating: mlMultiArray[[0,NSNumber(value: i)]]))
        }
        
        return array
    }
}
