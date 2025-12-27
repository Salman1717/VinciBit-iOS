//
//  PixelGridGenerator.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 27/12/25.
//

import UIKit
import SwiftUI

final class PixelGridGenerator {

    static let shared = PixelGridGenerator()
    private init() {}

    func generateGrid(from image: UIImage, gridSize: Int) -> PixelGrid {

        guard let cgImage = image.cgImage else {
            return PixelGrid(gridSize: gridSize, cells: [])
        }

        let width = cgImage.width
        let height = cgImage.height

        let cellWidth = width / gridSize
        let cellHeight = height / gridSize

        guard let dataProvider = cgImage.dataProvider,
              let pixelData = dataProvider.data,
              let data = CFDataGetBytePtr(pixelData) else {
            return PixelGrid(gridSize: gridSize, cells: [])
        }

        var cells: [PixelCell] = []

        for y in 0..<gridSize {
            for x in 0..<gridSize {

                var rTotal = 0
                var gTotal = 0
                var bTotal = 0
                var count = 0

                let startX = x * cellWidth
                let startY = y * cellHeight
                let endX = min(startX + cellWidth, width)
                let endY = min(startY + cellHeight, height)

                for py in startY..<endY {
                    for px in startX..<endX {

                        let index = (py * width + px) * 4

                        // ✅ iOS pixel order is BGRA
                        let b = Int(data[index])
                        let g = Int(data[index + 1])
                        let r = Int(data[index + 2])

                        rTotal += r
                        gTotal += g
                        bTotal += b
                        count += 1
                    }
                }

                guard count > 0 else { continue }

                let rNorm = Double(rTotal) / Double(count) / 255.0
                let gNorm = Double(gTotal) / Double(count) / 255.0
                let bNorm = Double(bTotal) / Double(count) / 255.0

                let color = Color(
                    red: rNorm,
                    green: gNorm,
                    blue: bNorm
                )

                cells.append(
                    PixelCell(x: x, y: y, color: color)
                )
            }
        }

        return PixelGrid(gridSize: gridSize, cells: cells)
    }
}
