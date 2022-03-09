//
//  BarChartDataPoint.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI

/**
 Data for a single bar chart data point.
 
 Colour can be solid or gradient.
 */
@available(iOS 14.0, *)
public struct BarChartDataPoint: CTStandardBarDataPoint, DataPointDisplayable {
    
    public let id = UUID()
    public var value: Double
    public var xAxisLabel: String?
    public var description: String?
    public var date: Date?
    public var colour: ChartColour
    
    public var _legendTag: String = ""
    
    // MARK: - Single colour
    /// Data model for a single data point with colour for use with a bar chart.
    /// - Parameters:
    ///   - value: Value of the data point.
    ///   - xAxisLabel: Label that can be shown on the X axis.
    ///   - description: A longer label that can be shown on touch input.
    ///   - date: Date of the data point if any data based calculations are required.
    ///   - colour: Colour styling for the fill.
    public init(
        value: Double,
        xAxisLabel: String? = nil,
        description: String? = nil,
        date: Date? = nil,
        colour: ChartColour = .colour(colour: .red)
    ) {
        self.value = value
        self.xAxisLabel = xAxisLabel
        self.description = description
        self.date = date
        self.colour = colour
    }
    
    @available(iOS 14.0, *)
    public typealias ID = UUID
}
