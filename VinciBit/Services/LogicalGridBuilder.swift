//
//  LogicalGridBuilder.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 29/12/25.
//

import SwiftUI

final class LogicalGridBuilder {

    static let shared = LogicalGridBuilder()
    private init() {}

    func build(from displayGrid: DisplayGrid, palette: [PaletteColor]) -> LogicalGrid {

        let cells = displayGrid.cells.map { cell -> LogicalCell in
            let colorID = palette.firstIndex {
                $0.color.isApproximatelyEqual(to: cell.color, tolerance: 24)
            } ?? -1

            return LogicalCell(
                x: cell.x,
                y: cell.y,
                colorID: colorID
            )
        }

        return LogicalGrid(
            gridSize: displayGrid.gridSize,
            cells: cells
        )
    }
}
