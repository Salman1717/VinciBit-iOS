//
//  PixelGrid.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 26/12/25.
//

import Foundation
import SwiftUI

struct LogicalGrid{
    let gridSize: Int
    let cells : [LogicalCell]
}

struct LogicalCell: Identifiable {
    let id = UUID()
    let x: Int
    let y: Int
    var colorID: Int
}
