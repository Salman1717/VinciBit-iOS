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

    let activeColorID: Int?
    let activeRegion: DrawRegion?

    private var logicalMap: [String: LogicalCell] {
        Dictionary(
            uniqueKeysWithValues: logicalGrid.cells.map {
                ("\($0.x)-\($0.y)", $0)
            }
        )
    }

    private var activeRegionKeys: Set<String> {
        guard let region = activeRegion else { return [] }
        return Set(region.cells.map { "\($0.x)-\($0.y)" })
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

    // MARK: - Fade Logic
    private func opacity(for cell: DisplayGridCell) -> Double {

        let key = "\(cell.x)-\(cell.y)"

        // 🔵 DRAW BY REGION
        if let activeRegion {
            return activeRegionKeys.contains(key) ? 1.0 : 0.12
        }

        // 🟡 DRAW BY COLOR
        if let activeColorID,
           let logicalCell = logicalMap[key] {
            return logicalCell.colorID == activeColorID ? 1.0 : 0.02
        }

        // 🔘 DEFAULT
        return 1.0
    }
}


