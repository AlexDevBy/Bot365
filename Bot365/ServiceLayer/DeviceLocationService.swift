//
//  DeviceLocationService.swift
//  Bot365
//
//  Created by Alex Misko on 16.03.23.
//

import Foundation
import CoreLocation

protocol IDeviceLocationService: AnyObject {
    var delegate: DeviceLocationServiceDelegate? { get set }
    var currentLocation: CLLocationCoordinate2D? { get }
    var error: Error? { get }
    var locationStatus: CLAuthorizationStatus? { get }
    func requestLocationUpdates()
}

protocol DeviceLocationServiceDelegate: AnyObject {
    func didChangeLocationStatus()
    func loacationDidChange(location: CLLocationCoordinate2D?)
}

class DeviceLocationService: NSObject, CLLocationManagerDelegate, IDeviceLocationService {
    
    var currentLocation: CLLocationCoordinate2D?
    var error: Error?
    var locationStatus: CLAuthorizationStatus?
    weak var delegate: DeviceLocationServiceDelegate?
    
    private override init() {
        super.init()
    }
    
    static let shared = DeviceLocationService()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
    }()
    
    func requestLocationUpdates() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied:
            locationStatus = .denied
        default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
            delegate?.didChangeLocationStatus()
        default:
            delegate?.didChangeLocationStatus()
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        delegate?.loacationDidChange(location: location.coordinate)
        currentLocation = location.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.error = error
    }
}
