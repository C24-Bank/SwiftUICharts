//
//  RangedBarDataSet.swift
//  
//
//  Created by Will Dale on 05/03/2021.
//

import SwiftUI

/**
 Data set for ranged bar charts.
 */
@available(iOS 14.0, *)
public struct RangedBarDataSet: CTRangedBarChartDataSet, DataFunctionsProtocol {
    
    public var id: UUID = UUID()
    public var dataPoints: [RangedBarDataPoint]
    public var legendTitle: String
    
    /// Initialises a new data set for ranged bar chart.
    /// - Parameters:
    ///   - dataPoints: Array of elements.
    ///   - legendTitle: Label for the data in legend.
    public init(
        dataPoints: [RangedBarDataPoint],
        legendTitle: String = ""
    ) {
        self.dataPoints = dataPoints
        self.legendTitle = legendTitle
    }
    
    @available(iOS 14.0, *)
    public typealias ID = UUID
    @available(iOS 14.0, *)
    public typealias DataPoint = RangedBarDataPoint
}
