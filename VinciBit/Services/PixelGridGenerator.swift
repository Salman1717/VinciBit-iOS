//
//  PixelGridGenerator.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 27/12/25.
//

import Foundation
import UIKit
import SwiftUI

final class PixelGridGenerator{
    
    static let shared = PixelGridGenerator()
    
    private init() {}
    
    func generateGrid( from image:UIImage, gridSize: Int) -> PixelGrid{
        
        guard let cgImage = image.cgImage else{
            return PixelGrid(gridSize: gridSize, cells: [])
        }
        
        let width = cgImage.width
        let height = cgImage.height
        
        let cellWidth = width / gridSize
        let cellHeight = height / gridSize
        
        guard let dataProvider = cgImage.dataProvider,
              let pixelData = dataProvider.data,
              let data = CFDataGetBytePtr(pixelData) else{
            return PixelGrid(gridSize: gridSize, cells: [])
        }
        
        var cells: [PixelCell] = []
        
        for y in 0..<gridSize{
            for x in 0..<gridSize{
                
                var rTotal = 0
                var gTotal = 0
                var bTotal = 0
                var count = 0
                
                let startX = x * cellWidth
                let startY = y * cellHeight
                
                for py in startY...(startY + cellHeight){
                    for px in startX...(startX + cellWidth){
                        let index = (py * width + px) * 4
                        
                        rTotal += Int(data[index])
                        gTotal += Int(data[index + 1])
                        bTotal += Int(data[index + 2])
                        count += 1
                    }
                }
                
                let r = Double(rTotal) / Double(count) / 255.0
                let g = Double(gTotal) / Double(count) / 255.0
                let b = Double(bTotal) / Double(count) / 255.0
                
                let color = Color(red: r, green: g, blue: b)
                
                cells.append(
                    PixelCell(x: x, y: y, color: color)
                )
            }
        }
        
        return PixelGrid(gridSize: gridSize, cells: cells)
    }
}
