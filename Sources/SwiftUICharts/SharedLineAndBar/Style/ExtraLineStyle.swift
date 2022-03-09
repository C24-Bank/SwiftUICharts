//
//  ExtraLineStyle.swift
//  
//
//  Created by Will Dale on 05/06/2021.
//

import SwiftUI

/**
  Control of the styling of the Extra Line.
 */
@available(iOS 14.0, *)
public struct ExtraLineStyle {
    
    public var lineColour: ChartColour
    public var lineType: LineType
    public var lineSpacing: SpacingType
    
    public var markerType: LineMarkerType
    
    public var strokeStyle: StrokeStyle
    
    public var pointStyle: PointStyle
    
    public var yAxisTitle: String?
    public var yAxisNumberOfLabels: Int
    
    public var animationType: AnimationType
    
    public var baseline: Baseline
    public var topLine: Topline

    public init(
        lineColour: ChartColour = .colour(colour: .red),
        lineType: LineType = .curvedLine,
        lineSpacing: SpacingType = .line,
        markerType: LineMarkerType = .indicator(style: DotStyle()),
        
        strokeStyle: StrokeStyle = StrokeStyle(),
        pointStyle: PointStyle = PointStyle(pointSize: 0, borderColour: .clear, fillColour: .clear),
        
        yAxisTitle: String? = nil,
        yAxisNumberOfLabels: Int = 7,
        
        animationType: AnimationType = .draw,
        
        baseline: Baseline = .minimumValue,
        topLine: Topline = .maximumValue
    ) {
        self.lineColour = lineColour
        self.lineType = lineType
        self.lineSpacing = lineSpacing
        
        self.markerType = markerType
        
        self.strokeStyle = strokeStyle
        self.pointStyle = pointStyle
        
        self.yAxisTitle = yAxisTitle
        self.yAxisNumberOfLabels = yAxisNumberOfLabels
        
        self.animationType = animationType
        
        self.baseline = baseline
        self.topLine = topLine
    }
    
    /**
     Controls which animations will be used.
     
     When using a line chart `.draw` is probably the
     right one to choose.
     
     When using on a filled line chart or on bar charts
     `.raise` is probably the right one to choose.
     
     ```
     case draw // Draws the line using `.trim`.
     case raise // Animates using `.scale`.
     ```
     */
    @available(iOS 14.0, *)
    public enum AnimationType: Hashable {
        /// Draws the line using `.trim`.
        case draw
        /// Animates using `.scale`.
        case raise
    }
    
    /**
     Sets what type of chart is being used.
     
     There is different spacing for line charts and bar charts,
     this sets that up.
     */
    @available(iOS 14.0, *)
    public enum SpacingType: Hashable {
        case line
        case bar
    }
}
