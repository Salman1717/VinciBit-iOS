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
    @Published var showGrid: Bool = false
    
    @Published var inputImage: UIImage?
    @Published var outputImage: UIImage?
    
    @Published var pixelGrid: PixelGrid?
    @Published var palette: [PaletteColor] = []
    @Published var regions: [DrawRegion] = []
    @Published var gridSize: Int = 16
    @Published var instructions: [InstructionSteps] = []
    @Published var currentStepIndex: Int = 0
    @Published var drawMode: DrawMode = .byColor
    
    let supportedGridSizes = [8, 16, 24, 32, 48]
    
    private let gridGenerator = PixelGridGenerator.shared
    
    private let mlservice = MLModelService.shared
    
    private let preprocessor = ImagePreprocessor.shared
    
    private let paletteExtractor = PaletteExtractor.shared
    
    private let regiondetector = RegionDetector.shared
    
    private let instructionEngine = InstructionEngine.shared
    
    init() {
        loadModel()
    }
    
    private func loadModel(){
        _ = mlservice.model
        isModelLoaded = true
    }
    
    func runInference(){
        guard let inputImage else { return }
        
        let resized = preprocessor.resizePreservingAspectRatio(inputImage)
        
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
                
                let grid = self.gridGenerator.generateGrid(
                    from: resized,
                    gridSize: self.gridSize
                )
                self.pixelGrid = grid
                
                let palette = self.paletteExtractor.extractPalette(from: grid)
                self.palette  = palette
                
                let regions = self.regiondetector.detectRegions(from: grid)
                self.regions = regions
                
                self.instructions = self.instructionEngine.generateInstructions(
                    gridSize: self.gridSize,
                    palette: palette,
                    regions: regions,
                    mode: self.drawMode
                )
                
                self.currentStepIndex = 0
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



