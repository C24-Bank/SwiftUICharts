//
//  DoughnutSegmentShape.swift
//  
//
//  Created by Will Dale on 23/02/2021.
//

import SwiftUI

/**
 Draws a doughnut segment.
 */
@available(iOS 14.0, *)
internal struct DoughnutSegmentShape: InsettableShape, Identifiable {
    
    var id: UUID
    var startAngle: Double
    var amount: Double
    var insetAmount: CGFloat = 0
    
    private var animatableStart: Double
    private var animatableAmount: Double
    
    init(id: UUID, startAngle: Double, amount: Double) {
        self.id = id
        self.startAngle = startAngle
        self.amount = amount
        self.animatableStart = startAngle
        self.animatableAmount = amount
    }
    
    var animatableData: AnimatablePair<Double, Double> {
        get { return AnimatablePair(animatableStart, animatableAmount) }
        set { animatableStart = newValue.first
            animatableAmount = newValue.second
        }
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
    
    internal func path(in rect: CGRect) -> Path {
        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        var path = Path()
        path.addRelativeArc(center: center,
                            radius: radius - insetAmount,
                            startAngle: Angle(radians: animatableStart),
                            delta: Angle(radians: animatableAmount))
        return path
    }
}
