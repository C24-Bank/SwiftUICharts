//
//  LineAndBarEnums.swift
//  
//
//  Created by Will Dale on 08/02/2021.
//

import SwiftUI

// MARK: - XAxisLabels
/**
 Location of the X axis labels
 ```
 case top
 case bottom
 ```
 */
@available(iOS 14.0, *)
public enum XAxisLabelPosistion {
    case top
    case bottom
}

/**
 Where the label data come from.
 
 xAxisLabel comes from  ChartData --> DataPoint model.
 
 xAxisLabels comes from ChartData --> xAxisLabels
 ```
 case dataPoint // ChartData --> DataPoint --> xAxisLabel
 case chartData // ChartData --> xAxisLabels
 ```
 */
@available(iOS 14.0, *)
public enum LabelsFrom {
    /// ChartData --> DataPoint --> xAxisLabel
    case dataPoint(rotation: Angle = Angle.degrees(0))
    /// ChartData --> xAxisLabels
    case chartData(rotation: Angle = Angle.degrees(0))
}

// MARK: - YAxisLabels
/**
 Location of the Y axis labels
 ```
 case leading
 case trailing
 ```
 */
@available(iOS 14.0, *)
public enum YAxisLabelPosistion {
    case leading
    case trailing
}

/**
 Option to display the markers' value inline with the marker..
 
 ```
 case none // No label.
 case yAxis(specifier: String) // Places the label in the yAxis labels.
 case center(specifier: String) // Places the label in the center of chart.
 ```
 */
@available(iOS 14.0, *)
public enum DisplayValue {
    /// No label.
    case none
    /// Places the label in the yAxis labels.
    case yAxis(specifier: String)
    /// Places the label in the center of chart.
    case center(specifier: String)
}

/**
 Where to start drawing the line chart from.
 ```
 case minimumValue // Lowest value in the data set(s)
 case minimumWithMaximum(of: Double) // Set a custom baseline
 case zero // Set 0 as the lowest value
 ```
 */
@available(iOS 14.0, *)
public enum Baseline: Hashable {
    /// Lowest value in the data set(s)
    case minimumValue
    /// Set a custom baseline
    case minimumWithMaximum(of: Double)
    /// Set 0 as the lowest value
    case zero
}

/**
 Where to end drawing the chart.
 ```
 case maximumValue // Highest value in the data set(s)
 case maximum(of: Double) // Set a custom topline
 ```
 */
@available(iOS 14.0, *)
public enum Topline: Hashable {
    /// Highest value in the data set(s)
    case maximumValue
    /// Set a custom topline
    case maximum(of: Double)
}

/**
 Option to choose between auto generated, numeric labels
 or custum array of strings.
 
 Custom is set from `ChartData -> yAxisLabels`
 
 ```
 case numeric // Auto generated, numeric labels.
 case custom // Custom labels array -- `ChartData -> yAxisLabels`
 ```
 */
@available(iOS 14.0, *)
public enum YAxisLabelType {
    /// Auto generated, numeric labels.
    case numeric
    /// Custom labels array
    case custom
}

// MARK: - Extra Y Axis
/**
 Controls how second Y Axis will be styled.
 
 ```
 case none // No colour marker.
 case style(size: CGFloat) // Get style from data model.
 case custom(colour: ChartColour, size: CGFloat) // Set custom style.
 ```
 */
@available(iOS 14.0, *)
public enum AxisColour {
    /// No colour marker.
    case none
    /// Get style from data model.
    case style(size: CGFloat)
    /// Set custom style.
    case custom(colour: ChartColour, size: CGFloat)
}
