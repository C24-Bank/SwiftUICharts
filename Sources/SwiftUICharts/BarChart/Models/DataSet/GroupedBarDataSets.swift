//
//  GroupedBarDataSet.swift
//  
//
//  Created by Will Dale on 04/02/2021.
//

import SwiftUI

/**
 Main data set for a grouped bar charts.
 */
@available(iOS 14.0, *)
public struct GroupedBarDataSets: CTMultiDataSetProtocol, DataFunctionsProtocol {
    
    public let id: UUID = UUID()
    public var dataSets: [GroupedBarDataSet]
    
    /// Initialises a new data set for Grouped Bar Chart.
    public init(dataSets: [GroupedBarDataSet]) {
        self.dataSets = dataSets
    }
}

/**
 Individual data sets for grouped bars charts.
 */
@available(iOS 14.0, *)
public struct GroupedBarDataSet: CTMultiBarChartDataSet {
    
    public let id: UUID = UUID()
    public var dataPoints: [GroupedBarDataPoint]
    public var setTitle: String
    
    /// Initialises a new data set for a Bar Chart.
    public init(
        dataPoints: [GroupedBarDataPoint],
        setTitle: String = ""
    ) {
        self.dataPoints = dataPoints
        self.setTitle = setTitle
    }
    
    @available(iOS 14.0, *)
    public typealias ID = UUID
    @available(iOS 14.0, *)
    public typealias DataPoint = GroupedBarDataPoint
}
