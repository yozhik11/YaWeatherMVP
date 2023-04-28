//
//  CoreLocationManager.swift
//  AprelTest
//
//  Created by Natalia Shevaldina on 25.04.2023.
//

import UIKit
import CoreLocation

/// Протокол класса GeolocationService
protocol GetGeolocationProtocol {
    var delegate: GeolocationServiceDelegate? {get set}
    func makeRequest()
    func getCityName(location: Geolocation, _ completion: @escaping (String)->Void)
}

/// Класс GeolocationService
class GeolocationService: NSObject, GetGeolocationProtocol, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var delegate: GeolocationServiceDelegate?
    
    /// makeRequest
    func makeRequest() {
        getLocation()
    }
    
    /// Получение названия города по координатам
    /// - Parameters:
    ///   - location: координаты Geolocation
    func getCityName(location: Geolocation, _ completion: @escaping (String)->Void) {
        let geocoder = CLGeocoder()
        let lat = CLLocationDegrees(integerLiteral: Double(location.latitude)!)
        let lan = CLLocationDegrees(integerLiteral: Double(location.longitude)!)
        let location = CLLocation(latitude: lat, longitude: lan)
        geocoder.reverseGeocodeLocation(location,
                                        preferredLocale: Locale.init(identifier: "ru_RU"),
                                        completionHandler: { placemarks, error in
            if error == nil {
                let locality = placemarks?[0].locality ?? (placemarks?[0].name ?? "Неопределено")
                completion(locality)
            } else {
                completion("Неопределено")
            }
        })
    }
    
    /// Запрос за разрешение доступа к геолокации
    private func getLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    /// Получение координат, прокидывание в Presenter
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.locationManager.stopUpdatingLocation()
        let loc = Geolocation(latitude: String(location.coordinate.latitude),
                              longitude: String(location.coordinate.longitude))
        self.delegate?.didFetchCurrentLocation(loc)
    }
    
    /// В случае невозможности получения координат прокинет ошибку
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.fetchCurrentLocationFailed(error: error)
    }
}
