//
//  DrawRegion.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 28/12/25.
//

import SwiftUI

struct DrawRegion: Identifiable {
    let id: Int
    let colorID: Int
    let cells: [LogicalCell]

    var cellCount: Int {
        cells.count
    }
}


