//
//  RegionDetector.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 28/12/25.
//

import Foundation
import SwiftUI

final class RegionDetector {

    static let shared = RegionDetector()
    private init() {}

    func detect(from grid: LogicalGrid) -> [DrawRegion] {

        let size = grid.gridSize
        var map = Dictionary(uniqueKeysWithValues:
            grid.cells.map { ("\($0.x)-\($0.y)", $0) }
        )

        var visited = Set<String>()
        var regions: [DrawRegion] = []
        var id = 0

        for cell in grid.cells {
            let key = "\(cell.x)-\(cell.y)"
            if visited.contains(key) { continue }

            var stack = [cell]
            var regionCells: [LogicalCell] = []
            visited.insert(key)

            while let current = stack.popLast() {
                regionCells.append(current)

                for (nx, ny) in [
                    (current.x+1,current.y),
                    (current.x-1,current.y),
                    (current.x,current.y+1),
                    (current.x,current.y-1)
                ] {
                    let nk = "\(nx)-\(ny)"
                    if let n = map[nk],
                       !visited.contains(nk),
                       n.colorID == current.colorID {
                        visited.insert(nk)
                        stack.append(n)
                    }
                }
            }

            regions.append(
                DrawRegion(
                    id: id,
                    colorID: cell.colorID,
                    cells: regionCells
                )
            )
            id += 1
        }

        return regions.sorted { $0.cells.count > $1.cells.count }
    }
}

