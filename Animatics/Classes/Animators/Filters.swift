//
//  Filters.swift
//  Animatics
//
//  Created by Nikita Arkhipov on 02.11.16.
//  Copyright © 2016 Anvics. All rights reserved.
//

import UIKit

public class Filter{
    public typealias Applyer = (CIImage) -> CIImage
    
    public static func Hue(_ angle: CGFloat) -> Applyer{
        let filter = CIFilter(name: "CIHueAdjust")!
        filter.setValue(NSNumber(value: Float(angle * .pi / 180) as Float), forKey: kCIInputAngleKey)
        return { image in
            filter.setValue(image, forKey: kCIInputImageKey)
            return filter.outputImage!
        }
    }
    
    public static func Saturation(_ saturation: CGFloat = 1, brightness: CGFloat = 1, contrast: CGFloat = 1) -> Applyer{
        let filter = CIFilter(name: "CIColorControls")!
        filter.setValue(saturation, forKey: kCIInputSaturationKey)
        filter.setValue(brightness, forKey: kCIInputBrightnessKey)
        filter.setValue(contrast, forKey: kCIInputContrastKey)
        return { image in
            filter.setValue(image, forKey: kCIInputImageKey)
            return filter.outputImage!
        }
    }
    
}

public func +(left: @escaping Filter.Applyer, right: @escaping Filter.Applyer) -> Filter.Applyer{
    return { image in return right(left(image)) }
}

prefix operator ^
prefix public func ^(filter: @escaping Filter.Applyer) -> (UIImage) -> UIImage{
    return { image in UIImage(ciImage: filter(image.ciImage!)) }
}


