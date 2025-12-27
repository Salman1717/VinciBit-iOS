//
//  MLMultiArrayHelper.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 26/12/25.
//

import CoreML
import UIKit

extension MLMultiArray {
    
    static func from(pixelBuffer: CVPixelBuffer) -> MLMultiArray? {
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }

        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)

        guard let array = try? MLMultiArray(
            shape: [3, NSNumber(value: height), NSNumber(value: width)],
            dataType: .float32
        ) else { return nil }

        guard let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer) else {
            return nil
        }

        let buffer = baseAddress.assumingMemoryBound(to: UInt8.self)

        let strideY = CVPixelBufferGetBytesPerRow(pixelBuffer)

        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = y * strideY + x * 4
                let r = Float(buffer[pixelIndex + 2]) / 255.0
                let g = Float(buffer[pixelIndex + 1]) / 255.0
                let b = Float(buffer[pixelIndex + 0]) / 255.0

                array[[0, y as NSNumber, x as NSNumber]] = NSNumber(value: r)
                array[[1, y as NSNumber, x as NSNumber]] = NSNumber(value: g)
                array[[2, y as NSNumber, x as NSNumber]] = NSNumber(value: b)
            }
        }

        return array
    }
}

