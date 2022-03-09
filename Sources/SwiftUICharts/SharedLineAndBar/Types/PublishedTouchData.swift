//
//  PublishedTouchData.swift
//  
//
//  Created by Will Dale on 12/09/2021.
//

import SwiftUI

@available(iOS 14.0, *)
public struct PublishedTouchData<DataPoint> {
    public let datapoint: DataPoint
    public let location: CGPoint
    internal let type: ChartType
}
