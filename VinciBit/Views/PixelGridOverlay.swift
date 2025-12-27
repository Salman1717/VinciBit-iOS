//
//  PixelGridOverlay.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 26/12/25.
//

import Foundation
import SwiftUI

struct PixelGridOverlay: View {
    
    let grid: PixelGrid
    let size: CGSize
    
    var body: some View {
        
        let cellSize = size.width / CGFloat(grid.gridSize)
        
        ZStack{
            ForEach(grid.cells) { cell in
                Rectangle()
                    .foregroundStyle(cell.color)
                    .frame(width: cellSize, height: cellSize)
                    .position(
                        x: CGFloat(cell.x) * cellSize + cellSize / 2,
                        y: CGFloat(cell.y) * cellSize + cellSize / 2,
                    )
            }
            
            Path{ path in
                for i in 0...grid.gridSize {
                    let p = CGFloat(i) * cellSize
                    path.move(to: CGPoint(x: p, y: 0))
                    path.addLine(to: CGPoint(x: p , y: size.height))
                    path.move(to: CGPoint(x: 0 , y: p ))
                    path.addLine(to: CGPoint(x: size.width, y: p))
                }
            }
            .stroke(Color.black.opacity(0.3) ,lineWidth: 0.5)
        }
        
    }
}
