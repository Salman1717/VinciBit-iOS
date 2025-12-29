//
//  InstructionEngine.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 28/12/25.
//

import SwiftUI

final class InstructionEngine {

    static let shared = InstructionEngine()
    private init() {}

    func generateInstructions(
        gridSize: Int,
        palette: [PaletteColor],
        regions: [DrawRegion],
        mode: DrawMode
    ) -> [InstructionStep] {

        var steps: [InstructionStep] = []
        var id = 0
        let totalSquares = gridSize * gridSize

        // MARK: - Setup Step
        steps.append(
            InstructionStep(
                id: id,
                type: .setup,
                title: "Draw the Grid",
                description: "Draw a \(gridSize) × \(gridSize) grid on paper (\(totalSquares) squares).",
                drawMode: nil,
                colorID: nil,
                color: nil,
                region: nil
            )
        )
        id += 1

        // MARK: - Draw Steps
        switch mode {

        case .byColor:
            for (index, paletteColor) in palette.enumerated() {
                steps.append(
                    InstructionStep(
                        id: id,
                        type: .draw,
                        title: "Step \(index + 1)",
                        description: "Fill all squares using this color (\(paletteColor.count) squares).",
                        drawMode: .byColor,
                        colorID: paletteColor.id,
                        color: paletteColor.color,  
                        region: nil
                    )
                )
                id += 1
            }

        case .byRegion:
            for (index, region) in regions.enumerated() {
                steps.append(
                    InstructionStep(
                        id: id,
                        type: .draw,
                        title: "Step \(index + 1)",
                        description: "Fill this region (\(region.cellCount) squares).",
                        drawMode: .byRegion,
                        colorID: region.colorID,
                        color: palette.first { $0.id == region.colorID }?.color,
                        region: region
                    )

                )
                id += 1
            }
        }

        // MARK: - Finish Step
        steps.append(
            InstructionStep(
                id: id,
                type: .finish,
                title: "Finish",
                description: "Great job! Your pixel drawing is complete 🎉",
                drawMode: nil,
                colorID: nil,
                color: nil,
                region: nil
            )
        )

        return steps
    }
}

