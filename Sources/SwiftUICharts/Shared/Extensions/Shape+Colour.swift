//
//  Shape+Colour.swift
//  
//
//  Created by Will Dale on 06/11/2021.
//

import SwiftUI

@available(iOS 14.0, *)
extension Shape {
    func fill(_ color: ChartColour) -> some View {
        Group {
            switch color {
            case .colour(let colour):
                self.fill(colour)
            case .gradient(let colours, let startPoint, let endPoint):
                self.fill(LinearGradient(gradient: Gradient(colors: colours),
                                         startPoint: startPoint,
                                         endPoint: endPoint))
            case .gradientStops(let stops, let startPoint, let endPoint):
                self.fill(LinearGradient(gradient: Gradient(stops: stops),
                                         startPoint: startPoint,
                                         endPoint: endPoint))
            }
        }
    }
    
    func stroke(_ color: ChartColour, strokeStyle: StrokeStyle) -> some View {
        Group {
            switch color {
            case .colour(let colour):
                self.stroke(colour, style: strokeStyle)
            case .gradient(let colours, let startPoint, let endPoint):
                self.stroke(LinearGradient(gradient: Gradient(colors: colours),
                                           startPoint: startPoint,
                                           endPoint: endPoint),
                            style: strokeStyle)
            case .gradientStops(let stops, let startPoint, let endPoint):
                self.stroke(LinearGradient(gradient: Gradient(stops: stops),
                                           startPoint: startPoint,
                                           endPoint: endPoint),
                            style: strokeStyle)
            }
        }
    }
}
