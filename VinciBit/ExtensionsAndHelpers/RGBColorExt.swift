//
//  RGBColorExt.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 27/12/25.
//

import UIKit
import SwiftUI

extension Color{
    
    func toRGB() -> (r: Int, g: Int, b: Int)? {
        
        let uiColor = UIColor(self)
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard  uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }
        
        return (
            Int(r * 255),
            Int(g * 255),
            Int(b * 255)
        )
        
    }
    
    func toRGBTuple() -> (r: Int, g: Int, b: Int)? {
        let uiColor = UIColor(self)
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }
        
        return (
            Int((r * 255).rounded()),
            Int((g * 255).rounded()),
            Int((b * 255).rounded())
        )
    }
    
    
    func isApproximatelyEqual(
        to other: Color,
        tolerance: Int = 20
    ) -> Bool {
        guard let a = self.toRGBTuple(),
              let b = other.toRGBTuple() else {
            return false
        }
        
        return abs(a.r - b.r) <= tolerance &&
        abs(a.g - b.g) <= tolerance &&
        abs(a.b - b.b) <= tolerance
    }
    
}
