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
    
    func detectRegions( from grid: PixelGrid) -> [DrawRegion] {
        
        let size = grid.gridSize
        
        /// Fast lookup (x, y) -> PixelCell
        var cellMap: [String: PixelCell] = [:]
        
        for cell in grid.cells{
            cellMap[ key(cell.x, cell.y)] = cell
        }
        
        var visited = Set<String>()
        var regions: [DrawRegion] = []
        var regionId = 0
        
        for cell in grid.cells{
            
            let startKey = key(cell.x, cell.y)
            
            if visited .contains(startKey) { continue }
            
            var queue: [PixelCell] = [cell]
            var regionCells: [PixelCell] = []
            
            visited.insert(startKey)
            
            /// Flood Fill using Breadth-First Search (BFS)
            while !queue.isEmpty{
                
                let current = queue.removeFirst()
                regionCells.append(current)
                
                let neighbors = [
                    (current.x + 1, current.y),
                    (current.x - 1, current.y),
                    (current.x, current.y + 1),
                    (current.x, current.y - 1 )
                ]
                
                for (nx, ny) in neighbors{
                    
                    guard nx >= 0, ny >= 0, nx < size, ny < size else{
                        continue
                    }
                    
                    let nKey = key(nx, ny)
                    
                    if visited.contains(nKey) { continue }
                    
                    guard let neighbor =  cellMap[nKey] else {continue}
                    
                    ///Same Color == Same Region
                    if neighbor.color == cell.color{
                        visited.insert(nKey)
                        queue.append(neighbor)
                    }
                }
            }
            
            regions.append(
                DrawRegion(
                    id: regionId,
                    color: cell.color,
                    cells: regionCells
                )
            )
            
            regionId += 1
        }

        return regions.sorted { $0.cellCount > $1.cellCount }
        
    }
    
    private func key(_ x: Int, _ y: Int) -> String {
        "\(x)-|\(y)"
    }
}
