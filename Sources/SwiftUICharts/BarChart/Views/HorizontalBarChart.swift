//
//  HorizontalBarChart.swift
//  
//
//  Created by Will Dale on 26/04/2021.
//

import SwiftUI

// MARK: - Chart
@available(iOS 14.0, *)
public struct HorizontalBarChart<ChartData>: View where ChartData: HorizontalBarChartData {
    
    @ObservedObject private var chartData: ChartData
    
    /// Initialises a bar chart view.
    /// - Parameter chartData: Must be BarChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    public var body: some View {
        GeometryReader { geo in
            if chartData.isGreaterThanTwo() {
                VStack(spacing: 0) {
                    HorizontalBarChartSubView(chartData: chartData)
                        .accessibilityLabel(chartData.accessibilityTitle)
                }
                .onAppear { // Needed for axes label frames
                    self.chartData.viewData.chartSize = geo.frame(in: .local)
                }
            } else { CustomNoDataView(chartData: chartData) }
        }
    }
}

// MARK: - Sub View
@available(iOS 14.0, *)
internal struct HorizontalBarChartSubView<ChartData>: View where ChartData: HorizontalBarChartData {
    
    @ObservedObject private var chartData: ChartData
    
    internal init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    internal var body: some View {
        switch chartData.barStyle.colourFrom {
        case .barStyle:
            ForEach(chartData.dataSets.dataPoints.indices, id: \.self) { index in
                HorizontalBarElement(chartData: chartData,
                                     dataPoint: chartData.dataSets.dataPoints[index],
                                     fill: chartData.barStyle.colour,
                                     index: index)
            }
        case .dataPoints:
            ForEach(chartData.dataSets.dataPoints.indices, id: \.self) { index in
                HorizontalBarElement(chartData: chartData,
                                     dataPoint: chartData.dataSets.dataPoints[index],
                                     fill: chartData.dataSets.dataPoints[index].colour,
                                     index: index)
            }
        }
    }
}

// MARK: - Element
@available(iOS 14.0, *)
internal struct HorizontalBarElement<ChartData>: View where ChartData: CTBarChartDataProtocol & GetDataProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let dataPoint: BarChartDataPoint
    private let fill: ChartColour
    private let animations = BarElementAnimation()
    private let index: Double
    
    @State private var fillAnimation: Bool = false
    @State private var lengthAnimation: Bool = false
    
    internal init(
        chartData: ChartData,
        dataPoint: BarChartDataPoint,
        fill: ChartColour,
        index: Int
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
        self.fill = fill
        self.index = Double(index)
        
        let shouldAnimate = chartData.shouldAnimate ? false : true
        self._lengthAnimation = State<Bool>(initialValue: shouldAnimate)
        self._fillAnimation = State<Bool>(initialValue: shouldAnimate)
    }
    
    internal var body: some View {
        GeometryReader { section in
            RoundedRectangleBarShape(chartData.barStyle.cornerRadius)
                // Fill
                .fill(fillAnimation ? fill : animations.fill.startState)
                .animation(animations.fillAnimation(index),
                           value: fill)
                .animateOnAppear(using: animations.fillAnimationStart(index)) {
                    self.fillAnimation = true
                }

                // Bredth
                .frame(height: BarLayout.barWidth(section.size.height, chartData.barStyle.barWidth))
                .animation(animations.widthAnimation(index),
                           value: chartData.barStyle.barWidth)
            
                // Length
                .frame(width: lengthAnimation ?
                       BarLayout.barHeight(section.size.width, dataPoint.value, chartData.maxValue) :
                       0)
                .offset(CGSize(width: 0,
                               height: BarLayout.barXOffset(section.size.height, chartData.barStyle.barWidth)))
                .animation(animations.heightAnimation(index),
                           value: dataPoint.value)
                .animateOnAppear(using: animations.heightAnimationStart(index)) {
                    self.lengthAnimation = true
                }
        }
        .onDisappear {
            self.fillAnimation = false
            self.lengthAnimation = false
        }
        .background(Color(.gray).opacity(0.000000001))
        .accessibilityValue(dataPoint.getCellAccessibilityValue(specifier: chartData.infoView.touchSpecifier))
        .id(chartData.id)
    }
}
