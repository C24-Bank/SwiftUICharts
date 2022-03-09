//
//  MarkerData.swift
//  
//
//  Created by Will Dale on 12/09/2021.
//

import Foundation
import CoreGraphics.CGGeometry

@available(iOS 14.0, *)
internal struct MarkerData: Hashable {
    internal let id: UUID = UUID()
    internal let lineMarkerData: [LineMarkerData]
    internal let barMarkerData: [BarMarkerData]
    
    internal init(
        lineMarkerData: [LineMarkerData],
        barMarkerData: [BarMarkerData]
    ) {
        self.lineMarkerData = lineMarkerData
        self.barMarkerData = barMarkerData
    }
    
    internal init() {
        self.lineMarkerData = []
        self.barMarkerData = []
    }
}

@available(iOS 14.0, *)
struct LineMarkerData: Hashable {
    let id: UUID = UUID()
    let markerType: LineMarkerType
    let location: CGPoint
    let dataPoints: [LineChartDataPoint]
    let lineType: LineType
    let lineSpacing: ExtraLineStyle.SpacingType
    let minValue: Double
    let range: Double
    
    static func == (lhs: LineMarkerData, rhs: LineMarkerData) -> Bool {
        lhs.id == rhs.id &&
        lhs.location == rhs.location
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(location)
    }
}

@available(iOS 14.0, *)
struct BarMarkerData: Hashable {
    let id: UUID = UUID()
    let markerType: BarMarkerType
    let location: CGPoint
    
    static func == (lhs: BarMarkerData, rhs: BarMarkerData) -> Bool {
        lhs.id == rhs.id &&
        lhs.location == rhs.location
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(location)
    }
}

@available(iOS 14.0, *)
extension LineChartDataPoint {
    init(_ datapoint: ExtraLineDataPoint) {
        self.init(value: datapoint.value,
                  description: datapoint.description,
                  pointColour: datapoint.pointColour,
                  ignore: datapoint.ignore)
    }
}

@available(iOS 14.0, *)
extension LineChartDataPoint {
    init(_ datapoint: RangedLineChartDataPoint) {
        self.init(value: datapoint.value,
                  description: datapoint.description,
                  pointColour: datapoint.pointColour,
                  ignore: datapoint.ignore)
    }
}
