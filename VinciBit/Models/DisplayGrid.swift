//
//  DisplayGrid.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 29/12/25.
//

import SwiftUI

struct DisplayGrid {
    let gridSize: Int
    let cells: [DisplayGridCell]
}

struct DisplayGridCell: Identifiable {
    let id = UUID()
    let x: Int
    let y: Int
    let color: Color
}
