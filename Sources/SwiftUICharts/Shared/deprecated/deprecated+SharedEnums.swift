//
//  deprecated+SharedEnums.swift
//  
//
//  Created by Will Dale on 10/01/2021.
//

import Foundation

// MARK: - Style
/**
 Type of colour styling.
 ```
 case colour // Single Colour
 case gradientColour // Colour Gradient
 case gradientStops // Colour Gradient with stop control
 ```
 */
@available(*, deprecated, message: "Please use \"ChartColour\" instead.")
@available(iOS 14.0, *)
public enum ColourType {
    /// Single Colour
    case colour
    /// Colour Gradient
    case gradientColour
    /// Colour Gradient with stop control
    case gradientStops
}

// MARK: - TouchOverlay
/**
 Placement of the data point information panel when touch overlay modifier is applied.
 ```
 case floating // Follows input across the chart.
 case infoBox(isStatic: Bool)  // Display in the InfoBox. Must have .infoBox()
 case header // Fix in the Header box. Must have .headerBox().
 ```
 */
@available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
@available(iOS 14.0, *)
public enum InfoBoxPlacement {
    /// Follows input across the chart.
    case floating
    /// Display in the InfoBox. Must have .infoBox()
    case infoBox(isStatic: Bool = false)
    /// Display in the Header box. Must have .headerBox().
    case header
}


// MARK: - TouchOverlay
/**
 Alignment of the content inside of the information box
 ```
 case vertical // Puts the legend, value and description verticaly
 case horizontal // Puts the legend, value and description horizontaly
 ```
 */
@available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
@available(iOS 14.0, *)
public enum InfoBoxAlignment {
    /// Puts the legend, value and description verticaly
    case vertical
    /// Puts the legend, value and description horizontaly
    case horizontal
}


/**
 Option to display units before or after values.
 
 ```
 case none // No unit
 case prefix(of: String) // Before value
 case suffix(of: String) // After value
 ```
 */
@available(*, deprecated, message: "Now done using Number Formatter")
@available(iOS 14.0, *)
public enum TouchUnit {
    /// No units
    case none
    /// Before value
    case prefix(of: String)
    /// After value
    case suffix(of: String)
}
