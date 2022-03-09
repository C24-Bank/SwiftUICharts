//
//  BarChartProtocolsExtensions.swift
//  
//
//  Created by Will Dale on 03/03/2021.
//

import SwiftUI

// MARK: - Markers
@available(iOS 14.0, *)
extension CTBarChartDataProtocol where Self.CTStyle.Mark == BarMarkerType,
                                       Self: Publishable {
    internal func markerSubView(
        markerData: MarkerData,
        touchLocation: CGPoint,
        chartSize: CGRect
    ) -> some View {
        ZStack {
            ForEach(markerData.barMarkerData, id: \.self) { marker in
                MarkerView.bar(barMarker: marker.markerType, markerData: marker)
            }
            
            ForEach(markerData.lineMarkerData, id: \.self) { marker in
                MarkerView.line(lineMarker: marker.markerType,
                                markerData: marker,
                                chartSize: chartSize,
                                touchLocation: touchLocation,
                                dataPoints: marker.dataPoints,
                                lineType: marker.lineType,
                                lineSpacing: marker.lineSpacing,
                                minValue: marker.minValue,
                                range: marker.range)
            }
        }
    }
}

// MARK: - Legends
//
//
//
// MARK: Standard / Ranged
@available(iOS 14.0, *)
extension CTBarChartDataProtocol where Self.SetType.ID == UUID,
                                       Self.SetType.DataPoint.ID == UUID,
                                       Self.SetType: CTStandardBarChartDataSet,
                                       Self.SetType.DataPoint: CTBarColourProtocol {
    internal func setupLegends() {
//        switch self.barStyle.colourFrom {
//        case .barStyle:
//            if self.barStyle.colour.colourType == .colour,
//               let colour = self.barStyle.colour.colour
//            {
//                self.legends.append(LegendData(id: dataSets.id,
//                                               legend: dataSets.legendTitle,
//                                               colour: ColourStyle(colour: colour),
//                                               strokeStyle: nil,
//                                               prioity: 1,
//                                               chartType: .bar))
//            } else if self.barStyle.colour.colourType == .gradientColour,
//                      let colours = self.barStyle.colour.colours
//            {
//                self.legends.append(LegendData(id: dataSets.id,
//                                               legend: dataSets.legendTitle,
//                                               colour: ColourStyle(colours: colours,
//                                                                   startPoint: .leading,
//                                                                   endPoint: .trailing),
//                                               strokeStyle: nil,
//                                               prioity: 1,
//                                               chartType: .bar))
//            } else if self.barStyle.colour.colourType == .gradientStops,
//                      let stops = self.barStyle.colour.stops
//            {
//                self.legends.append(LegendData(id: dataSets.id,
//                                               legend: dataSets.legendTitle,
//                                               colour: ColourStyle(stops: stops,
//                                                                   startPoint: .leading,
//                                                                   endPoint: .trailing),
//                                               strokeStyle: nil,
//                                               prioity: 1,
//                                               chartType: .bar))
//            }
//        case .dataPoints:
//            for data in dataSets.dataPoints {
//                if data.colour.colourType == .colour,
//                   let colour = data.colour.colour,
//                   let legend = data.description
//                {
//                    self.legends.append(LegendData(id: data.id,
//                                                   legend: legend,
//                                                   colour: ColourStyle(colour: colour),
//                                                   strokeStyle: nil,
//                                                   prioity: 1,
//                                                   chartType: .bar))
//                } else if data.colour.colourType == .gradientColour,
//                          let colours = data.colour.colours,
//                          let legend = data.description
//                {
//                    self.legends.append(LegendData(id: data.id,
//                                                   legend: legend,
//                                                   colour: ColourStyle(colours: colours,
//                                                                       startPoint: .leading,
//                                                                       endPoint: .trailing),
//                                                   strokeStyle: nil,
//                                                   prioity: 1,
//                                                   chartType: .bar))
//                } else if data.colour.colourType == .gradientStops,
//                          let stops = data.colour.stops,
//                          let legend = data.description
//                {
//                    self.legends.append(LegendData(id: data.id,
//                                                   legend: legend,
//                                                   colour: ColourStyle(stops: stops,
//                                                                       startPoint: .leading,
//                                                                       endPoint: .trailing),
//                                                   strokeStyle: nil,
//                                                   prioity: 1,
//                                                   chartType: .bar))
//                }
//            }
//        }
    }
}

// MARK: Multi Bar
@available(iOS 14.0, *)
extension CTMultiBarChartDataProtocol {
    internal func setupLegends() {
//        for group in self.groups {
//            if group.colour.colourType == .colour,
//               let colour = group.colour.colour
//            {
//                self.legends.append(LegendData(id: group.id,
//                                               legend: group.title,
//                                               colour: ColourStyle(colour: colour),
//                                               strokeStyle: nil,
//                                               prioity: 1,
//                                               chartType: .bar))
//            } else if group.colour.colourType == .gradientColour,
//                      let colours = group.colour.colours
//            {
//                self.legends.append(LegendData(id: group.id,
//                                               legend: group.title,
//                                               colour: ColourStyle(colours: colours,
//                                                                   startPoint: .leading,
//                                                                   endPoint: .trailing),
//                                               strokeStyle: nil,
//                                               prioity: 1,
//                                               chartType: .bar))
//            } else if group.colour.colourType == .gradientStops,
//                      let stops  = group.colour.stops
//            {
//                self.legends.append(LegendData(id: group.id,
//                                               legend: group.title,
//                                               colour: ColourStyle(stops: stops,
//                                                                   startPoint: .leading,
//                                                                   endPoint: .trailing),
//                                               strokeStyle: nil,
//                                               prioity: 1,
//                                               chartType: .bar))
//            }
//        }
    }
}
