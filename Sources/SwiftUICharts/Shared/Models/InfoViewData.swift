//
//  InfoViewData.swift
//  
//
//  Created by Will Dale on 04/02/2021.
//

import SwiftUI

/**
 Data model to pass view information internally for the `InfoBox`, `FloatingInfoBox` and `HeaderBox`.
 */
@available(iOS 14.0, *)
public struct InfoViewData<DP: CTDataPointBaseProtocol> {
    
    /**
     Is there currently input (touch or click) on the chart.
     
     Set from TouchOverlay via the relevant protocol.
     
     Used by `InfoBox`, `FloatingInfoBox` and `HeaderBox`.
     */
    public var isTouchCurrent: Bool = false
    
    /**
     Closest data points to input.
     
     Set from TouchOverlay via the relevant protocol.
     
     Used by `InfoBox`, `FloatingInfoBox` and `HeaderBox`.
     */
    @available(*, deprecated, message: "Please use \"Combine\" instead.")
    var touchOverlayInfo: [DP] = []
    
    /**
     Set specifier of data point readout.
     
     Set from TouchOverlay via the relevant protocol.
     
     Used by `InfoBox`, `FloatingInfoBox` and `HeaderBox`.
     */
    var touchSpecifier: String = "%.0f"
    
    /**
     X axis posistion of the overlay box.
     
     Used to set the location of the data point readout View.
     
     Set from TouchOverlay via the relevant protocol.
     
     Used by `InfoBox`, `FloatingInfoBox` and `HeaderBox`.
     */
    var touchLocation: CGPoint = .zero
    

    /**
     Size of the chart.
     
     Used to set the location of the data point readout View.
     
     Set from TouchOverlay via the relevant protocol.
     
     Used by `InfoBox`, `FloatingInfoBox` and `HeaderBox`.
     */
    var chartSize: CGRect  = .zero
    
    /**
     Option to display units before or after values.
     */
    var touchUnit: TouchUnit = .none
}
