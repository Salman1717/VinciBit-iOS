//
//  ImagePreprocessor.swift
//  VinciBit
//
//  Created by Salman Mhaskar on 26/12/25.
//

import Foundation
import UIKit
import CoreVideo

final class ImagePreprocessor{
    
    static let shared = ImagePreprocessor()
    
    private init(){}
    
    func resize(_ image: UIImage, to size: CGSize) -> UIImage{
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    func toPixelBuffer(from image: UIImage, width:Int = 256, height:Int = 256) -> CVPixelBuffer? {
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true
        ] as CFDictionary
        
        var pixelBuffer: CVPixelBuffer?
        
        CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32BGRA,
            attrs,
            &pixelBuffer
        )
        
        guard let buffer = pixelBuffer else { return nil }
        
        CVPixelBufferLockBaseAddress(buffer, [])
        
        defer {CVPixelBufferUnlockBaseAddress(buffer, [])}
        
        guard let context = CGContext(
            data: CVPixelBufferGetBaseAddress(buffer),
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
        )
        else { return nil }
        
        guard let cgImage = image.cgImage else { return nil }
        
        context.draw(cgImage, in:   CGRect(x: 0, y: 0, width: width, height: height))
        
        return buffer
    }
}
