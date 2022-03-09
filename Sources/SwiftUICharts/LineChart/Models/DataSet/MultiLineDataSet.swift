//
//  MultiLineDataSet.swift
//  
//
//  Created by Will Dale on 04/02/2021.
//

import SwiftUI

/**
 Data set containing multiple data sets for multiple lines
 
 Contains information about each of lines within the chart.
 */
@available(iOS 14.0, *)
public struct MultiLineDataSet: CTMultiLineChartDataSet, DataFunctionsProtocol {
    
    public let id: UUID = UUID()
    public var dataSets: [LineDataSet]
    
    /// Initialises a new data set for multi-line Line Charts.
    public init(dataSets: [LineDataSet]) {
        self.dataSets = dataSets
    }
}
