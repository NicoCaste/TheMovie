//
//  UIImageExtension.swift
//  TheMovie
//
//  Created by nicolas castello on 26/08/2022.
//

import Foundation
import UIKit

extension UIImage {
    // return a newBlackAndWhite Image
    func grayscale() -> UIImage {
        // Core image filter doc: https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/uid/TP40004346
        let context = CIContext(options: nil)
        
        guard let filter = CIFilter(name: "CIPhotoEffectTonal") else { return self}
        filter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        
        guard let output = filter.outputImage,
              let cgImage = context.createCGImage(output, from: output.extent)
        else { return self }
        return  UIImage(cgImage: cgImage)
    }
    
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}
