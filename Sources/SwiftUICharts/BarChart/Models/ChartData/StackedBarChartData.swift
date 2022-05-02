//
//  StackedBarChartData.swift
//  
//
//  Created by Will Dale on 12/02/2021.
//

import SwiftUI
import Combine

/**
 Data model for drawing and styling a Stacked Bar Chart.
 
 The grouping data informs the model as to how the datapoints are linked.
 */
@available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
@available(iOS 14.0, *)
public final class StackedBarChartData: CTMultiBarChartDataProtocol, ChartConformance {
    
    // MARK: Properties
    public let id: UUID = UUID()
    
    public var accessibilityTitle: LocalizedStringKey = ""
    
    @Published public var dataSets: StackedBarDataSets
    
    @available(*, deprecated, message: "Please set the data in \".titleBox\" instead.")
    @Published public var metadata = ChartMetadata()
    
    @Published public var xAxisLabels: [String]?
    @Published public var yAxisLabels: [String]?
    @Published public var barStyle: BarStyle
    @Published public var chartStyle: BarChartStyle
    
    @Published public var legends: [LegendData] = []
    @Published public var viewData: ChartViewData = ChartViewData()
    @Published public var infoView: InfoViewData<StackedBarDataPoint> = InfoViewData()
    @Published public var extraLineData: ExtraLineData!
    
    @Published public var shouldAnimate: Bool
    @Published public private(set) var animations: BarElementAnimation = BarElementAnimation()
    
    @Published public var groups: [GroupingData]
    
    public var noDataText: Text

    internal let chartType: (chartType: ChartType, dataSetType: DataSetType) = (chartType: .bar, dataSetType: .multi)
    
    public let touchedDataPointPublisher = PassthroughSubject<[PublishedTouchData<DataPoint>], Never>()

    private var internalSubscription: AnyCancellable?
    private var markerData: MarkerData = MarkerData()
    private var internalDataSubscription: AnyCancellable?
    @Published public var touchPointData: [DataPoint] = []
    
    // MARK: Initializer
    /// Initialises a Stacked Bar Chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the bars.
    ///   - groups: Information for how to group the data points.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - yAxisLabels: Labels for the Y axis instead of the labels generated from data point values.   
    ///   - barStyle: Control for the aesthetic of the bar chart.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - shouldAnimate: Whether the chart should be animated.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    public init(
        dataSets: StackedBarDataSets,
        groups: [GroupingData],
        xAxisLabels: [String]? = nil,
        yAxisLabels: [String]? = nil,
        barStyle: BarStyle = BarStyle(),
        chartStyle: BarChartStyle = BarChartStyle(),
        shouldAnimate: Bool = true,
        noDataText: Text = Text("No Data")
    ) {
        self.dataSets = dataSets
        self.groups = groups
        self.xAxisLabels = xAxisLabels
        self.yAxisLabels = yAxisLabels
        self.barStyle = barStyle
        self.chartStyle = chartStyle
        self.shouldAnimate = shouldAnimate
        self.noDataText = noDataText
        
        self.setupLegends()
        self.setupInternalCombine()
    }
    
    private func setupInternalCombine() {
        internalSubscription = touchedDataPointPublisher
            .sink {
                let lineMarkerData: [LineMarkerData] = $0.compactMap { data in
                    if data.type == .extraLine,
                       let extraData = self.extraLineData {
                        return LineMarkerData(markerType: extraData.style.markerType,
                                              location: data.location,
                                              dataPoints: extraData.dataPoints.map { LineChartDataPoint($0) },
                                              lineType: extraData.style.lineType,
                                              lineSpacing: .bar,
                                              minValue: extraData.minValue,
                                              range: extraData.range)
                    }
                    return nil
                }
                let barMarkerData: [BarMarkerData] = $0.compactMap { data in
                    if data.type == .bar {
                        return BarMarkerData(markerType: self.chartStyle.markerType,
                                              location: data.location)
                    }
                    return nil
                }
                self.markerData =  MarkerData(lineMarkerData: lineMarkerData,
                                              barMarkerData: barMarkerData)
            }
        
        internalDataSubscription = touchedDataPointPublisher
            .sink { self.touchPointData = $0.map(\.datapoint) }
    }
    
    // MARK: Labels
    public func getXAxisLabels() -> some View {
        Group {
            switch self.chartStyle.xAxisLabelsFrom {
            case .dataPoint(let angle):
                HStack(spacing: 0) {
                    ForEach(dataSets.dataSets, id: \.id) { dataSet in
                        Spacer()
                            .frame(minWidth: 0, maxWidth: 500)
                        VStack {
                            if self.chartStyle.xAxisLabelPosition == .bottom {
                                RotatedText(chartData: self, label: dataSet.setTitle, rotation: angle)
                                Spacer()
                            } else {
                                Spacer()
                                RotatedText(chartData: self, label: dataSet.setTitle, rotation: angle)
                            }
                        }
                        .frame(width: self.viewData.xAxislabelWidths.max(),
                               height: self.viewData.xAxisLabelHeights.max())
                        Spacer()
                            .frame(minWidth: 0, maxWidth: 500)
                    }
                }
            case .chartData(let angle):
                if let labelArray = self.xAxisLabels {
                    HStack(spacing: 0) {
                        ForEach(labelArray.indices, id: \.self) { i in
                            if i > 0 {
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: 500)
                            }
                            VStack {
                                if self.chartStyle.xAxisLabelPosition == .bottom {
                                    RotatedText(chartData: self, label: labelArray[i], rotation: angle)
                                    Spacer()
                                } else {
                                    Spacer()
                                    RotatedText(chartData: self, label: labelArray[i], rotation: angle)
                                }
                            }
                            .frame(width: self.viewData.xAxislabelWidths.max(),
                                   height: self.viewData.xAxisLabelHeights.max())
                            if i < labelArray.count - 1 {
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: 500)
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Touch
    public func setTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        self.infoView.isTouchCurrent = true
        self.infoView.touchLocation = touchLocation
        self.infoView.chartSize = chartSize
        self.processTouchInteraction(touchLocation: touchLocation, chartSize: chartSize)
    }
    
    private func processTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        // Filter to get the right dataset based on the x axis.
        let superXSection: CGFloat = chartSize.width / CGFloat(dataSets.dataSets.count)
        let superIndex: Int = Int((touchLocation.x) / superXSection)
        if superIndex >= 0 && superIndex < dataSets.dataSets.count {
            // Filter to get the right dataset based on the y axis.
            let subDataSet = dataSets.dataSets[superIndex]
            let calculatedIndex = calculateIndex(dataSet: subDataSet, touchLocation: touchLocation, chartSize: chartSize)
            if let index = calculatedIndex.yIndex?.offset {
                if index >= 0 && index < subDataSet.dataPoints.count {
                    let datapoint = dataSets.dataSets[superIndex].dataPoints[index]
                    let location = CGPoint(x: (CGFloat(superIndex) * superXSection) + (superXSection / 2),
                                           y: (chartSize.height - calculatedIndex.endPointOfElements[index]))
                    var values: [PublishedTouchData<DataPoint>] = []
                    values.append(PublishedTouchData(datapoint: datapoint, location: location, type: chartType.chartType))
                    
                    if let extraLine = extraLineData?.pointAndLocation(touchLocation: touchLocation, chartSize: chartSize),
                       let location = extraLine.location,
                       let value = extraLine.value,
                       let description = extraLine.description,
                       let _legendTag = extraLine._legendTag
                    {
                        var datapoint = DataPoint(value: value, description: description)
                        datapoint._legendTag = _legendTag
                        values.append(PublishedTouchData(datapoint: datapoint, location: location, type: .extraLine))
                    }
                    
                    touchedDataPointPublisher.send(values)                }
            }
        }
    }
    
    public func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View {
        markerSubView(markerData: markerData, touchLocation: touchLocation, chartSize: chartSize)
    }
    
    private func calculateIndex(
        dataSet: StackedBarDataSet,
        touchLocation: CGPoint,
        chartSize: CGRect
    ) -> (yIndex: EnumeratedSequence<[CGFloat]>.Element?, endPointOfElements: [CGFloat]) {
        
        // Get the max value of the dataset relative to max value of all datasets.
        // This is used to set the height of the y axis filtering.
        let setMaxValue = dataSet.maxValue()
        let allMaxValue = self.maxValue
        let fraction: CGFloat = CGFloat(setMaxValue / allMaxValue)
        
        // Gets the height of each datapoint
        let sum: Double = dataSet.dataPoints
            .map(\.value)
            .reduce(0, +)
        let heightOfElements: [CGFloat] = dataSet.dataPoints
            .map(\.value)
            .map { (chartSize.height * fraction) * CGFloat($0 / sum) }
        
        // Gets the highest point of each element.
        let endPointOfElements: [CGFloat] = heightOfElements
            .enumerated()
            .map {
                (0...$0.offset)
                    .map { heightOfElements[$0] }
                    .reduce(0, +)
            }
        
        let yIndex = endPointOfElements
            .enumerated()
            .first(where:) { $0.element > abs(touchLocation.y - chartSize.height) }
        
        return (yIndex, endPointOfElements)
    }
    
    public func touchDidFinish() {
        touchPointData = []
        infoView.isTouchCurrent = false
    }
    
    @available(iOS 14.0, *)
    public typealias SetType = StackedBarDataSets
    @available(iOS 14.0, *)
    public typealias DataPoint = StackedBarDataPoint
    @available(iOS 14.0, *)
    public typealias CTStyle = BarChartStyle
    
    // MARK: Deprecated
    /// Initialises a Stacked Bar Chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the bars.
    ///   - groups: Information for how to group the data points.
    ///   - metadata: Data model containing the charts Title, Subtitle and the Title for Legend.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - yAxisLabels: Labels for the Y axis instead of the labels generated from data point values.
    ///   - barStyle: Control for the aesthetic of the bar chart.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    @available(*, deprecated, message: "Please set use other init instead.")
    public init(
        dataSets: StackedBarDataSets,
        groups: [GroupingData],
        metadata: ChartMetadata,
        xAxisLabels: [String]? = nil,
        yAxisLabels: [String]? = nil,
        barStyle: BarStyle = BarStyle(),
        chartStyle: BarChartStyle = BarChartStyle(),
        noDataText: Text = Text("No Data")
    ) {
        self.dataSets = dataSets
        self.groups = groups
        self.metadata = metadata
        self.xAxisLabels = xAxisLabels
        self.yAxisLabels = yAxisLabels
        self.barStyle = barStyle
        self.chartStyle = chartStyle
        self.shouldAnimate = true
        self.noDataText = noDataText
        
        self.setupLegends()
        self.setupInternalCombine()
    }
}
