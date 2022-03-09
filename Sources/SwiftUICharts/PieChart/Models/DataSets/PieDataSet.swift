//
//  PieDataSet.swift
//  
//
//  Created by Will Dale on 01/02/2021.
//

import SwiftUI

/**
 Data set for a pie chart.
 */
@available(iOS 14.0, *)
public struct PieDataSet: CTSingleDataSetProtocol {
    
    public var id: UUID = UUID()
    public var dataPoints: [PieChartDataPoint]
    public var legendTitle: String
    
    /// Initialises a new data set for a standard pie chart.
    /// - Parameters:
    ///   - dataPoints: Array of elements.
    ///   - legendTitle: Label for the data in legend.
    public init(
        dataPoints: [PieChartDataPoint],
        legendTitle: String
    ) {
        self.dataPoints = dataPoints
        self.legendTitle = legendTitle
    }
    
    @available(iOS 14.0, *)
    public typealias ID = UUID
    @available(iOS 14.0, *)
    public typealias DataPoint = PieChartDataPoint
}
