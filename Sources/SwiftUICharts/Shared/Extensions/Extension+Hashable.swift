//
//  CGPoint+Hashable.swift
//  
//
//  Created by Will Dale on 05/12/2021.
//

import SwiftUI

@available(iOS 14.0, *)
extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

@available(iOS 14.0, *)
extension Gradient.Stop: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(color)
        hasher.combine(location)
    }
}

@available(iOS 14.0, *)
extension StrokeStyle: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(lineWidth)
        hasher.combine(lineCap)
        hasher.combine(lineJoin)
        hasher.combine(miterLimit)
        hasher.combine(dash)
        hasher.combine(dashPhase)
    }
}

    
