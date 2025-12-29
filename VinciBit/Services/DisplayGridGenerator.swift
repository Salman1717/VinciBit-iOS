//
//  DisplayGridGenerator.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 29/12/25.
//


import UIKit
import SwiftUI

final class DisplayGridGenerator {

    static let shared = DisplayGridGenerator()
    private init() {}

    func generate(from image: UIImage, gridSize: Int) -> DisplayGrid {
        guard let cgImage = image.cgImage else {
            return DisplayGrid(gridSize: gridSize, cells: [])
        }

        let width = cgImage.width
        let height = cgImage.height
        let cellW = width / gridSize
        let cellH = height / gridSize

        guard let data = cgImage.dataProvider?.data,
              let ptr = CFDataGetBytePtr(data) else {
            return DisplayGrid(gridSize: gridSize, cells: [])
        }

        var cells: [DisplayGridCell] = []

        for y in 0..<gridSize {
            for x in 0..<gridSize {
                var r = 0, g = 0, b = 0, count = 0

                let sx = x * cellW
                let sy = y * cellH
                let ex = min(sx + cellW, width)
                let ey = min(sy + cellH, height)

                for py in sy..<ey {
                    for px in sx..<ex {
                        let i = (py * width + px) * 4
                        b += Int(ptr[i])
                        g += Int(ptr[i + 1])
                        r += Int(ptr[i + 2])
                        count += 1
                    }
                }

                let color = Color(
                    red: Double(r) / Double(count) / 255,
                    green: Double(g) / Double(count) / 255,
                    blue: Double(b) / Double(count) / 255
                )

                cells.append(DisplayGridCell(x: x, y: y, color: color))
            }
        }

        return DisplayGrid(gridSize: gridSize, cells: cells)
    }
}
