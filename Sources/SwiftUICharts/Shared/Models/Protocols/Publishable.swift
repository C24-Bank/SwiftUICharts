//
//  PublishableProtocol.swift
//  
//
//  Created by Will Dale on 05/06/2021.
//

import Foundation
import Combine

/**
 Protocol to enable publishing data streams over the Combine framework
 */
@available(iOS 14.0, *)
public protocol Publishable {
    
    associatedtype DataPoint: CTDataPointBaseProtocol
    
    /**
     Streams the data points from touch overlay.
     
     Uses Combine
     */
    var touchedDataPointPublisher: PassthroughSubject<[PublishedTouchData<Self.DataPoint>], Never> { get }
    
    var touchPointData: [DataPoint] { get set }
}
