//
//  PixelGrid.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 26/12/25.
//

import Foundation
import SwiftUI

struct PixelGrid{
    let gridSize: Int
    let cells : [PixelCell]
}

struct PixelCell:  Identifiable{
    let id = UUID()
    let x: Int
    let y: Int
    let color: Color
}
