//
//  StackedBarDataPoint.swift
//  
//
//  Created by Will Dale on 19/02/2021.
//

import SwiftUI

/**
 Data for a single stacked chart data point.
 */
@available(iOS 14.0, *)
public struct StackedBarDataPoint: CTMultiBarDataPoint, DataPointDisplayable {
    
    public let id: UUID = UUID()
    public var value: Double
    public var xAxisLabel: String? = nil
    public var description: String?
    public var date: Date?
    public var group: GroupingData
    
    public var _legendTag: String = ""
    
    /// Data model for a single data point with colour info for use with a stacked bar chart.
    /// - Parameters:
    ///   - value: Value of the data point.
    ///   - description: A longer label that can be shown on touch input.
    ///   - date: Date of the data point if any data based calculations are required.
    ///   - group: Group data informs the data models how the data point are linked.
    public init(
        value: Double,
        description: String? = nil,
        date: Date? = nil,
        group: GroupingData
    ) {
        self.value = value
        self.description = description
        self.date = date
        self.group = group
    }
    
    @available(iOS 14.0, *)
    public typealias ID = UUID
}

@available(iOS 14.0, *)
extension StackedBarDataPoint {
    internal init (
        value: Double,
        description: String?
    ) {
        self.value = value
        self.description = description
        self.group = GroupingData(title: "", colour: .colour(colour: .red))
    }
}
