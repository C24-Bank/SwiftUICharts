//
//  PieChartData.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI
import Combine

/**
 Data for drawing and styling a pie chart.
 
 This model contains the data and styling information for a pie chart.
 */
@available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
@available(iOS 14.0, *)
public final class PieChartData: CTPieChartDataProtocol, Publishable, Touchable, TouchInfoDisplayable {
   
    // MARK: Properties
    public var id: UUID = UUID()
    
    public var accessibilityTitle: LocalizedStringKey = ""
    
    @Published public var dataSets: PieDataSet
    
    @available(*, deprecated, message: "Please set the data in \".titleBox\" instead.")
    @Published public var metadata = ChartMetadata()
    
    @Published public var chartStyle: PieChartStyle
    @Published public var legends: [LegendData] = []
    @Published public var infoView: InfoViewData<PieChartDataPoint> = InfoViewData()
    
    @Published public var shouldAnimate: Bool
    
    public var noDataText: Text

    internal let chartType: (chartType: ChartType, dataSetType: DataSetType) = (chartType: .pie, dataSetType: .single)
    
    private var internalDataSubscription: AnyCancellable?
    public let touchedDataPointPublisher = PassthroughSubject<[PublishedTouchData<PieChartDataPoint>],Never>()
    @Published public var touchPointData: [DataPoint] = []
    
    // MARK: Initializer
    /// Initialises Pie Chart data.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the chart.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - shouldAnimate: Whether the chart should be animated.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    public init(
        dataSets: PieDataSet,
        chartStyle: PieChartStyle = PieChartStyle(),
        shouldAnimate: Bool = true,
        noDataText: Text = Text("No Data")
    ) {
        self.dataSets = dataSets
        self.chartStyle = chartStyle
        self.shouldAnimate = shouldAnimate
        self.shouldAnimate = true
        self.noDataText = noDataText
        
        self.setupLegends()
        self.makeDataPoints()
        
        internalDataSubscription = touchedDataPointPublisher
            .sink { self.touchPointData = $0.map(\.datapoint) }
    }
    
    // MARK: - Touch
    public func setTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        self.infoView.isTouchCurrent = true
        self.infoView.touchLocation = touchLocation
        self.infoView.chartSize = chartSize
        self.processTouchInteraction(touchLocation: touchLocation, chartSize: chartSize)
    }
    
    private func processTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        let touchDegree = degree(from: touchLocation, in: chartSize)
        let index = self.dataSets.dataPoints.firstIndex(where:) {
            let start = $0.startAngle * Double(180 / Double.pi) <= Double(touchDegree)
            let end = ($0.startAngle * Double(180 / Double.pi)) + ($0.amount * Double(180 / Double.pi)) >= Double(touchDegree)
            return start && end
        }
        guard let wrappedIndex = index else { return }
        let datapoint = self.dataSets.dataPoints[wrappedIndex]
        self.touchedDataPointPublisher.send([PublishedTouchData(datapoint: datapoint, location: .zero, type: .pie)])
    }
    
    public func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View { EmptyView() }
    
    public func touchDidFinish() {
        touchPointData = []
        infoView.isTouchCurrent = false
    }
    
    @available(iOS 14.0, *)
    public typealias SetType = PieDataSet
    @available(iOS 14.0, *)
    public typealias DataPoint = PieChartDataPoint
    @available(iOS 14.0, *)
    public typealias CTStyle = PieChartStyle
    
    // MARK: Deprecated
    /// Initialises Pie Chart data.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the chart.
    ///   - metadata: Data model containing the charts Title, Subtitle and the Title for Legend.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    @available(*, deprecated, message: "Please set use other init instead.")
    public init(
        dataSets: PieDataSet,
        metadata: ChartMetadata,
        chartStyle: PieChartStyle = PieChartStyle(),
        noDataText: Text = Text("No Data")
    ) {
        self.dataSets = dataSets
        self.metadata = metadata
        self.chartStyle = chartStyle
        self.shouldAnimate = true
        self.noDataText = noDataText
        
        self.setupLegends()
        self.makeDataPoints()
        
        internalDataSubscription = touchedDataPointPublisher
            .sink { self.touchPointData = $0.map(\.datapoint) }
    }
}

