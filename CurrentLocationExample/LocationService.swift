//
//  LocationService.swift
//  CurrentLocationExample
//
//  Created by Hoye Lam on 28/08/2022.
//

import CoreLocation

protocol LocationProviding {
    func requestPermissions()
    func startUpdatingLocation()
    var currentLocation: CLLocation? { get }
    var currentLocationPub: Published<CLLocation?>.Publisher { get }
    
    var authorizationStatus: CLAuthorizationStatus? { get }
    var authorizationStatusPub: Published<CLAuthorizationStatus?>.Publisher { get }
}

final class LocationService: NSObject, LocationProviding {
    
    @Published var currentLocation: CLLocation? = nil
    var currentLocationPub: Published<CLLocation?>.Publisher { $currentLocation }
    
    @Published var authorizationStatus: CLAuthorizationStatus? = nil
    var authorizationStatusPub: Published<CLAuthorizationStatus?>.Publisher { $authorizationStatus }
    
    private var locationManager: CLLocationManager?
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        self.authorizationStatus = locationManager?.authorizationStatus
    }
    
    func startUpdatingLocation() {
        locationManager?.startUpdatingLocation()
    }
    
    func requestPermissions() {
        locationManager?.requestWhenInUseAuthorization()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currentLocation = location
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
        
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            self.startUpdatingLocation()
        default:
            self.requestPermissions()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Your amazing error handling when failing to get user's location
    }
}
