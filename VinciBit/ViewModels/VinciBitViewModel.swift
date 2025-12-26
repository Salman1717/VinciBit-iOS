//
//  VinciBitViewModel.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 25/12/25.
//

import Foundation
import Combine
import UIKit
import CoreML


final class VinciBitViewModel: ObservableObject {
    
    @Published var isModelLoaded: Bool = false
    @Published var inputImage: UIImage?
    @Published var outputImage: UIImage?
    
    private let mlservice = MLModelService.shared
    
    private let preprocessor = ImagePreprocessor.shared
    
    init() {
        loadModel()
    }
    
    private func loadModel(){
        _ = mlservice.model
        isModelLoaded = true
    }
    
    func runInference(){
        guard let inputImage else { return }
        
        let resized = preprocessor.resize(
            inputImage,
            to: CGSize(width: 256, height: 256)
        )
        
        guard let pixelBuffer = preprocessor.toPixelBuffer(from: resized) else {
            print("Failed to Create Pixel Buffer")
            return
        }
        
        do {
            guard let mlArray = MLMultiArray.from(pixelBuffer: pixelBuffer) else {
                print("❌ Failed to create MLMultiArray")
                return
            }
            
            let _ = try mlservice.model.prediction(
                input_image: mlArray
            )
            
            DispatchQueue.main.async {
                self.outputImage = resized
            }
            
        }catch{
            print("Inference Failed : \(error)")
        }
        
        
    }
}



