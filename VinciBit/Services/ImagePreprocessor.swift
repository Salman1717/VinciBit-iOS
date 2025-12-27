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
    
    func resizePreservingAspectRatio(
        _ image: UIImage,
        targetSize: CGSize = CGSize(width: 256, height: 256)
    ) -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            let aspectWidth  = targetSize.width / image.size.width
            let aspectHeight = targetSize.height / image.size.height
            let aspectRatio = max(aspectWidth, aspectHeight)
            
            let scaledWidth  = image.size.width * aspectRatio
            let scaledHeight = image.size.height * aspectRatio
            
            let x = (targetSize.width - scaledWidth) / 2
            let y = (targetSize.height - scaledHeight) / 2
            
            image.draw(
                in: CGRect(
                    x: x,
                    y: y,
                    width: scaledWidth,
                    height: scaledHeight
                )
            )
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
