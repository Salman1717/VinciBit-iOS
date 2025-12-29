//
//  InstructionSteps.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 28/12/25.
//

import SwiftUI

enum DrawMode{
    case byRegion
    case byColor
    
}

enum InstructionType{
    case setup
    case draw
    case finish
}


struct InstructionStep: Identifiable {
    let id: Int
    let type: InstructionType
    let title: String
    let description: String

    let drawMode: DrawMode?
    let colorID: Int?          // ✅ LOGICAL identity
    let color: Color?          // ✅ UI swatch only
    let region: DrawRegion?
}

