//
//  File.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

/**
 Data set for a bar chart.
 */
@available(iOS 14.0, *)
public struct BarDataSet: CTStandardBarChartDataSet, DataFunctionsProtocol {
    
    public let id: UUID = UUID()
    public var dataPoints: [BarChartDataPoint]
    public var legendTitle: String
    
    /// Initialises a new data set for standard Bar Charts.
    /// - Parameters:
    ///   - dataPoints: Array of elements.
    ///   - legendTitle: label for the data in legend.
    public init(
        dataPoints: [BarChartDataPoint],
        legendTitle: String = ""
    ) {
        self.dataPoints = dataPoints
        self.legendTitle = legendTitle
    }
    
    @available(iOS 14.0, *)
    public typealias ID = UUID
    @available(iOS 14.0, *)
    public typealias DataPoint = BarChartDataPoint
}
