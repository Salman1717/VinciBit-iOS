//
//  InstructionEngine.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 28/12/25.
//

import SwiftUI

final class InstructionEngine {
    
    static let shared = InstructionEngine()
    
    private init() { }
    
    func generateInstructions(
        gridSize: Int,
        palette: [PaletteColor],
        regions: [DrawRegion],
        mode: DrawMode
    ) -> [InstructionSteps]
    {
        
        var steps: [InstructionSteps] = []
        var id = 0
        
        var totalSquare = gridSize * gridSize
        
        //MARK: - Setup Step
        steps.append(
            InstructionSteps(
                id: id,
                type: .setup,
                title: "Draw The Grid",
                description: "Draw a \(gridSize) X \(gridSize) grid on paper with \(totalSquare) total squares",
                drawMode: nil,
                region: nil,
                color: nil
            )
        )
        
        id += 1
        
        //MARK: - Draw Step
        
        switch mode{
            
            ///MARK:  By Color
        case .byColor:
            for (index, paletteColor) in palette.enumerated() {
                steps.append(
                    InstructionSteps(
                        id: id,
                        type: .draw,
                        title: "Step \(index + 1)",
                        description: "Fill all squares using this  color \(paletteColor.count) steps",
                        drawMode: .byColor,
                        region: nil,
                        color: paletteColor.color
                    )
                )
                id += 1
            }
            
            ///MARK:  By Region
        case .byRegion:
            for (index, region) in regions.enumerated(){
                steps.append(
                    InstructionSteps(
                        id: id,
                        type: .draw,
                        title: "Step \(index + 1)",
                        description: "Fill all squares in  this  region \(region.cellCount) steps",
                        drawMode: .byRegion,
                        region: region,
                        color: region.color
                    )
                )
                id += 1
            }
        }
        
        //MARK: - Finish Steps
        
        steps.append(
            InstructionSteps(
                id: id,
                type: .finish,
                title: "Finish",
                description: "Great job! Your pixel drawing is complete 🎉",
                drawMode: nil,
                region: nil,
                color: nil
            )
        )
        
        return steps
    }
    
}
