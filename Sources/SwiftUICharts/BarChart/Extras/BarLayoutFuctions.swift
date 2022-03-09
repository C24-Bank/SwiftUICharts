//
//  BarLayoutFunctions.swift
//  
//
//  Created by Will Dale on 04/12/2021.
//

import CoreGraphics

@available(iOS 14.0, *)
internal struct BarLayout {
    internal static func barWidth(_ totalWidth: CGFloat, _ widthFactor: CGFloat) -> CGFloat {
        return totalWidth * widthFactor
    }
    
    internal static func barHeight(_ totalHeight: CGFloat, _ value: Double, _ maxValue: Double) -> CGFloat {
        return totalHeight * divideByZeroProtection(CGFloat.self, value, maxValue)
    }
    
    internal static func barOffset(_ section: CGSize, _ widthFactor: CGFloat, _ value: Double, _ maxValue: Double) -> CGSize {
        return CGSize(width: barXOffset(section.width, widthFactor),
                      height: barYOffset(section.height, value, maxValue))
    }
    
    internal static func barXOffset(_ total: CGFloat, _ factor: CGFloat) -> CGFloat {
        return (-(total * factor) / 2) + (total / 2)
    }
    
    internal static func barYOffset(_ total: CGFloat, _ value: Double, _ maxValue: Double) -> CGFloat {
        return total - (total * divideByZeroProtection(CGFloat.self, value, maxValue))
    }
}
