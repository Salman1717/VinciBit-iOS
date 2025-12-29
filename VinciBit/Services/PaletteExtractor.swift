//
//  PaletteExtractor.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 27/12/25.
//

import SwiftUI
import UIKit

final class PaletteExtractor {

    static let shared = PaletteExtractor()
    private init() {}

    func extract(from grid: DisplayGrid, tolerance: Int = 24) -> [PaletteColor] {
        var buckets: [(Color, Int)] = []

        for cell in grid.cells {
            if let idx = buckets.firstIndex(where: {
                $0.0.isApproximatelyEqual(to: cell.color, tolerance: tolerance)
            }) {
                buckets[idx].1 += 1
            } else {
                buckets.append((cell.color, 1))
            }
        }

        return buckets
            .sorted { $0.1 > $1.1 }
            .enumerated()
            .map { PaletteColor(id: $0.offset, color: $0.element.0, count: $0.element.1) }
    }
}

