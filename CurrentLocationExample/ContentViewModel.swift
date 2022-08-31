//
//  ContentViewModel.swift
//  CurrentLocationExample
//
//  Created by Hoye Lam on 31/08/2022.
//

import CoreLocation
import MapKit
import Combine

enum LocationPermissionsState {
    case available
    case unknown
}

final class ContentViewModel: ObservableObject {
    @Published var locationStatus: LocationPermissionsState = .unknown
    @Published var region: MKCoordinateRegion? = nil
    
    private var service: LocationProviding
    
    private var subscribers: [AnyCancellable] = []
    
    init(service: LocationProviding = LocationService()) {
        self.service = service
        subscribeToLocationPublishers()
    }
    
    func subscribeToLocationPublishers() {
        // Subscribe to authorization changes
        service.authorizationStatusPub
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                switch status {
                case .authorizedAlways, .authorizedWhenInUse:
                    self?.locationStatus = .available
                default:
                    self?.locationStatus = .unknown
                }
            }
            .store(in: &subscribers)
        
        // Subscribe to location updates
        service.currentLocationPub
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newLocation in
                if let location = newLocation {
                    let region = MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(
                            latitudeDelta: 0.25,
                            longitudeDelta: 0.25
                        )
                    )
                    
                    self?.region = region
                }
            }
            .store(in: &subscribers)
    }
    
    func onAppear() {
        service.requestPermissions()
    }
    
    func onTapRequestPermissions() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}
