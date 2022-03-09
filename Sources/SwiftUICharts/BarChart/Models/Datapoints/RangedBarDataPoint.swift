//
//  RangedBarDataPoint.swift
//  
//
//  Created by Will Dale on 05/03/2021.
//

import SwiftUI

/**
 Data for a single ranged bar chart data point.
 */
@available(iOS 14.0, *)
public struct RangedBarDataPoint: CTRangedBarDataPoint, DataPointDisplayable {
    
    public let id: UUID = UUID()
    public var upperValue: Double
    public var lowerValue: Double
    public var xAxisLabel: String?
    public var description: String?
    public var date: Date?
    public var colour: ChartColour
    
    public var _legendTag: String = ""
    
    internal var _value: Double = 0
    internal var _valueOnly: Bool = false
    
    /// Data model for a single data point with colour for use with a ranged bar chart.
    /// - Parameters:
    ///   - lowerValue: Value of the lower range of the data point.
    ///   - upperValue: Value of the upper range of the data point.
    ///   - xAxisLabel: Label that can be shown on the X axis.
    ///   - description: A longer label that can be shown on touch input.
    ///   - date: Date of the data point if any data based calculations are required.
    ///   - colour: Colour styling for the fill.
    public init(
        lowerValue: Double,
        upperValue: Double,
        xAxisLabel: String? = nil,
        description: String? = nil,
        date: Date? = nil,
        colour: ChartColour = .colour(colour: .red)
    ) {
        self.upperValue = upperValue
        self.lowerValue = lowerValue
        self.xAxisLabel = xAxisLabel
        self.description = description
        self.date = date
        self.colour = colour
    }
    
    public var value: Double {
        return upperValue - lowerValue
    }
    
    @available(iOS 14.0, *)
    public typealias ID = UUID
}

@available(iOS 14.0, *)
extension RangedBarDataPoint {
    internal init(
        value: Double,
        description: String?
    ) {
        self._value = value
        self.description = description
        
        self.upperValue = 0
        self.lowerValue = 0
        self.colour = .colour(colour: .red)
    }
}
