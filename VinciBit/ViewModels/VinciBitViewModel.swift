//
//  VinciBitViewModel.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 25/12/25.
//

import Foundation
import Combine
import UIKit
import SwiftUI

final class VinciBitViewModel: ObservableObject {

    // MARK: - Published UI state
    @Published var isModelLoaded: Bool = false
    @Published var showGrid: Bool = false

    @Published var inputImage: UIImage?
    @Published var outputImage: UIImage?

    // Two-grid architecture
    @Published var displayGrid: DisplayGrid?           // colors for UI
    @Published var logicalGrid: LogicalGrid?           // colorIDs for logic

    @Published var palette: [PaletteColor] = []
    @Published var regions: [DrawRegion] = []

    @Published var gridSize: Int = 16
    @Published var instructions: [InstructionStep] = []
    @Published var currentStepIndex: Int = 0
    @Published var drawMode: DrawMode = .byRegion

    let supportedGridSizes = [8, 16, 24, 32, 48]

    // MARK: - Services (implementations per reset plan)
    private let preprocessor = ImagePreprocessor.shared
    private let displayGridGenerator = DisplayGridGenerator.shared
    private let paletteExtractor = PaletteExtractor.shared
    private let logicalGridBuilder = LogicalGridBuilder.shared
    private let regionDetector = RegionDetector.shared
    private let instructionEngine = InstructionEngine.shared

    // Optional ML service (kept for completeness)
    private let mlservice = MLModelService.shared

    init() {
        loadModel()
    }

    private func loadModel() {
        // Keep this in case you want to use the Core ML identity model later
        _ = mlservice.model
        isModelLoaded = true
    }

    // MARK: - Primary pipeline
    func runInference() {
        guard let input = inputImage else { return }

        // 1) Resize / preprocess image on main thread (fast)
        let resized = preprocessor.resizePreservingAspectRatio(input, targetSize: CGSize(width: 256, height: 256))

        // Keep a quick preview on the UI immediately
        DispatchQueue.main.async {
            self.outputImage = resized
        }

        // 2) Heavy work on background thread
        DispatchQueue.global(qos: .userInitiated).async {
            // DISPLAY GRID: averaged colors for UI
            let displayGrid = self.displayGridGenerator.generate(from: resized, gridSize: self.gridSize)

            // PALETTE: quantize / bucket colors (returns PaletteColor array)
            let palette = self.paletteExtractor.extract(from: displayGrid)

            // LOGICAL GRID: map each display cell to a palette index (colorID)
            let logicalGrid = self.logicalGridBuilder.build(from: displayGrid, palette: palette)

            // REGIONS: detect connected regions on logical grid (by colorID)
            let regions = self.regionDetector.detect(from: logicalGrid)

            // INSTRUCTIONS: build user-facing steps (include colorIDs for byColor steps)
            let instructions = self.instructionEngine.generateInstructions(
                gridSize: self.gridSize,
                palette: palette,
                regions: regions,
                mode: self.drawMode
            )

            // 3) Publish results on main thread
            DispatchQueue.main.async {
                self.outputImage = resized
                self.displayGrid = displayGrid
                self.logicalGrid = logicalGrid
                self.palette = palette
                self.regions = regions
                self.instructions = instructions
                self.currentStepIndex = 0
            }
        }
    }
}
