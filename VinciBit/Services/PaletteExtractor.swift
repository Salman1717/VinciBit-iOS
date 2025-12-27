//
//  PaletteExtractor.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 27/12/25.
//

import Foundation
import SwiftUI

final class PaletteExtractor{
    
    static let shared = PaletteExtractor()
    
    private init(){ }
    
    func extractPalette( from  grid: PixelGrid, tolerance: Int = 20 ) -> [PaletteColor] {
        
        var buckets: [(color: Color, rgb: (Int, Int, Int), count: Int) ] = []
        
        for cell in grid.cells {
            guard let rgb = cell.color.toRGB() else { continue }
            
            if let index = buckets.firstIndex(where: {
                abs($0.rgb.0 - rgb.0) < tolerance &&
                abs($0.rgb.1 - rgb.1) < tolerance &&
                abs($0.rgb.2 - rgb.2) < tolerance
            }){
                buckets[index].count += 1
            }else{
                buckets.append((cell.color, rgb, 1))
            }
        }
        
        return buckets
            .enumerated()
            .sorted { $0.element.count > $1.element.count }
            .map{ index, bucket in
                PaletteColor(
                    id: index,
                    color: bucket.color,
                    count: bucket.count
                )
            }
    }
}
