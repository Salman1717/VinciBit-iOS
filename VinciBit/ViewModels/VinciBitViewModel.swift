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
    @Published var pixelGrid: PixelGrid?
    @Published var showGrid: Bool = false
    
    private let gridGenerator = PixelGridGenerator.shared
    
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
                self.pixelGrid = self.gridGenerator.generateGrid(
                    from: resized,
                    gridSize: 32
                )
            }
            
        }catch{
            print("Inference Failed : \(error)")
        }
    }
    
//    func loadPixelGrid(){
//        guard let url = Bundle.main.url(forResource: "pixel_grid", withExtension: ".json") else{
//            print("pixel_grid.json NOT FOUND")
//            return
//        }
//        
//        do {
//            let data = try Data(contentsOf: url)
//            DispatchQueue.main.async{
//               
//            }
//        }catch{
//            print("PIXEL GRID LOADING FAILED: \(error)")
//        }
//    }
}



