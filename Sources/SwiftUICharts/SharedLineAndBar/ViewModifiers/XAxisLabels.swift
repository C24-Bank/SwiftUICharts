//
//  XAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 26/12/2020.
//

import SwiftUI

/**
 Labels for the X axis.
 */
@available(iOS 14.0, *)
internal struct XAxisLabels<T>: ViewModifier where T: CTLineBarChartDataProtocol {
    
    @ObservedObject private var chartData: T
    
    private let leadingTrailingPadding: CGFloat
    
    internal init(chartData: T, leadingTrailingPadding: CGFloat) {
        self.chartData = chartData
        self.leadingTrailingPadding = leadingTrailingPadding
        self.chartData.viewData.hasXAxisLabels = true
    }
    
    internal func body(content: Content) -> some View {
        Group {
            switch chartData.chartStyle.xAxisLabelPosition {
            case .bottom:
                if chartData.isGreaterThanTwo() {
                    VStack {
                        content
                        chartData.getXAxisLabels(leadingTrailingPadding: leadingTrailingPadding).padding(.top, 2)
                        chartData.getXAxisTitle()
                    }
                } else { content }
            case .top:
                if chartData.isGreaterThanTwo() {
                    VStack {
                        chartData.getXAxisTitle()
                        chartData.getXAxisLabels(leadingTrailingPadding: leadingTrailingPadding).padding(.bottom, 2)
                        content
                    }
                } else { content }
            }
        }
    }
}

@available(iOS 14.0, *)
extension View {
    /**
     Labels for the X axis.
     
     The labels can either come from ChartData -->  xAxisLabels
     or ChartData --> DataSets --> DataPoints
     
     - Requires:
     Chart Data to conform to CTLineBarChartDataProtocol.
     
     - Requires:
     Chart Data to conform to CTLineBarChartDataProtocol.
     
     # Available for:
     - Line Chart
     - Multi Line Chart
     - Filled Line Chart
     - Ranged Line Chart
     - Bar Chart
     - Grouped Bar Chart
     - Stacked Bar Chart
     - Ranged Bar Chart
     
     # Unavailable for:
     - Pie Chart
     - Doughnut Chart
     
     - Parameter chartData: Chart data model.
     - Returns: A  new view containing the chart with labels marking the x axis.
     */
    public func xAxisLabels<T: CTLineBarChartDataProtocol>(chartData: T, leadingTrailingPadding: CGFloat = 0) -> some View {
        self.modifier(XAxisLabels(chartData: chartData, leadingTrailingPadding: leadingTrailingPadding))
    }
}
