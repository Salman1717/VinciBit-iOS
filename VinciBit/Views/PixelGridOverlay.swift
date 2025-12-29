//
//  PixelGridOverlay.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 26/12/25.
//

import SwiftUI

struct PixelGridOverlay: View {

    let displayGrid: DisplayGrid
    let logicalGrid: LogicalGrid
    let activeColorID: Int?   // nil = show all

    private var logicalMap: [String: Int] {
        Dictionary(
            uniqueKeysWithValues: logicalGrid.cells.map {
                ("\($0.x)-\($0.y)", $0.colorID)
            }
        )
    }

    var body: some View {
        GeometryReader { geo in
            let cellSize = geo.size.width / CGFloat(displayGrid.gridSize)

            ZStack {
                ForEach(displayGrid.cells) { cell in
                    Rectangle()
                        .fill(cell.color)
                        .opacity(opacity(for: cell))
                        .frame(width: cellSize, height: cellSize)
                        .position(
                            x: CGFloat(cell.x) * cellSize + cellSize / 2,
                            y: CGFloat(cell.y) * cellSize + cellSize / 2
                        )
                }
            }
        }
    }

    private func opacity(for cell: DisplayGridCell) -> Double {
        guard let activeColorID else { return 1.0 }

        let key = "\(cell.x)-\(cell.y)"
        let cellColorID = logicalMap[key]

        return cellColorID == activeColorID ? 1.0 : 0.12
    }
}

