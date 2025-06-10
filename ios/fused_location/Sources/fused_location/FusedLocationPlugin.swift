//
//  FusedLocationPlugin.swift
//  fused_location
//
//  Created by Samuel Kubinský on 09/06/2025.
//

import Flutter
import CoreLocation

public class FusedLocationPlugin: NSObject, FlutterPlugin, FlutterStreamHandler, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var eventSink: FlutterEventSink?
    
    // MARK: - FlutterPlugin
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "fused_location", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "fused_location/stream", binaryMessenger: registrar.messenger())
        
        let instance = FusedLocationPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        eventChannel.setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "startLocationUpdates":
                let distanceFilter = call.argument("distanceFilter") ?? kCLDistanceFilterNone
                startLocationUpdates(with: distanceFilter)
                result(nil)
            case "stopLocationUpdates":
                stopLocationUpdates()
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - FlutterStreamHandler
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
    // MARK: - CLLocationManagerDelegate
    
    private func startLocationUpdates(with distanceFilter: Double) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = distanceFilter
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    private func stopLocationUpdates() {
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        notifySubscribers()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        notifySubscribers()
    }
    
    private func notifySubscribers() {
        guard
            let eventSink,
            let location = locationManager.location,
            let heading = locationManager.heading
        else {
            return
        }
        
        // position
        let positionLatitude = location.coordinate.latitude
        let positionLongitude = location.coordinate.longitude
        let positionAccuracy = location.horizontalAccuracy
        
        // elevation
        let elevationMeanSeaLevel = location.altitude
        let elevationMeanSeaLevelAccuracy = location.verticalAccuracy
        var elevationEllipsoidal = -1.0
        var elevationEllipsoidalAccuracy = -1.0
        if #available(iOS 15.0, *) {
            elevationEllipsoidal = location.ellipsoidalAltitude
            elevationEllipsoidalAccuracy = location.verticalAccuracy
        }
        
        // course
        var courseDirection = -1.0
        var courseAccuracy = -1.0
        if #available(iOS 13.4, *) {
            courseDirection = location.course
            courseAccuracy = location.courseAccuracy
        }
        
        // speed
        let speedMagnitude = location.speed
        let speedAccuracy = location.speedAccuracy
        
        // heading
        let headingDirection = heading.trueHeading
        let headingAccuracy = heading.headingAccuracy
        
        
        let dict: [String: Double] = [
            "positionLatitude": positionLatitude,
            "positionLongitude": positionLongitude,
            "positionAccuracy": positionAccuracy,
            "elevationMeanSeaLevel": elevationMeanSeaLevel,
            "elevationMeanSeaLevelAccuracy": elevationMeanSeaLevelAccuracy,
            "elevationEllipsoidal": elevationEllipsoidal,
            "elevationEllipsoidalAccuracy": elevationEllipsoidalAccuracy,
            "courseDirection": courseDirection,
            "courseAccuracy": courseAccuracy,
            "speedMagnitude": speedMagnitude,
            "speedAccuracy": speedAccuracy,
            "headingDirection": headingDirection,
            "headingAccuracy": headingAccuracy
        ]
        
        eventSink(dict)
    }
}

extension FlutterMethodCall {
    func argument<T>(_ key: String) -> T? {
        guard let dictionary = arguments as? [String: Any] else {
            return nil
        }
        return dictionary[key] as? T
    }
}
