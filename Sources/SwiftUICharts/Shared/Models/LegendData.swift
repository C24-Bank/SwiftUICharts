//
//  LegendData.swift
//  LineChart
//
//  Created by Will Dale on 02/01/2021.
//

import SwiftUI

/**
 Data model to hold data for Legends
 */
@available(iOS 14.0, *)
public struct LegendData: Hashable, Identifiable {
    
    public var id: UUID
    
    /// The type of chart being used.
    public var chartType: ChartType
    
    /// Text to be displayed
    public var legend: String
    
    /// Style of the stroke
    public var strokeStyle: StrokeStyle?
    
    /// Used to make sure the charts data legend is first
    public let prioity: Int
    
    public var colour: Color
    
    /// Legend.
    /// - Parameters:
    ///   - legend: Text to be displayed.
    ///   - colour: Colour styling.
    ///   - strokeStyle: Stroke Style.
    ///   - prioity: Used to make sure the charts data legend is first.
    ///   - chartType: Type of chart being used.
    public init(
        id: UUID,
        legend: String,
        colour: Color,
        strokeStyle: StrokeStyle?,
        prioity: Int,
        chartType: ChartType
    ) {
        self.id = id
        self.legend = legend
        self.colour = colour
        self.strokeStyle = strokeStyle
        self.prioity = prioity
        self.chartType = chartType
        
    }
}
