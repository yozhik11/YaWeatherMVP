//
//  Presenter.swift
//  AprelTest
//
//  Created by Natalia Shevaldina on 25.04.2023.
//

import UIKit

/// Протокол запроса получения данных
protocol PresenterProtocol: AnyObject {
    func getWeatherData(location: Geolocation)
}

/// Протокол получения локации
protocol GeolocationServiceDelegate {
    func didFetchCurrentLocation(_ location: Geolocation)
    func fetchCurrentLocationFailed(error: Error)
}

/// Презентер ViewController
final class Presenter {
    var viewController: ViewProtocol?
    private let dataFetcher: DataFetcherProtocol?
    private var weatherData: WeatherModel?
    private var geoService: GetGeolocationProtocol?
    
    init(viewController: ViewProtocol,
         dataFetcher: DataFetcherProtocol,
         geoService: GetGeolocationProtocol) {
        self.viewController = viewController
        self.dataFetcher = dataFetcher
        self.geoService = geoService
        self.geoService?.makeRequest()
        self.geoService?.delegate = self
    }
}

// MARK: - Protocol Impl
extension Presenter: GeolocationServiceDelegate {
    /// Получение координат по геолокации
    func didFetchCurrentLocation(_ location: Geolocation) {
        getWeatherData(location: location)
    }
    
    /// Получение ошибки запроса координат
    func fetchCurrentLocationFailed(error: Error) {
        let mskGeolocation = Geolocation(latitude: MskCoordinates.lat,
                                         longitude: MskCoordinates.lon)
        getWeatherData(location: mskGeolocation)
    }
}

// MARK: - PrivateMethods
extension Presenter: PresenterProtocol {
    /// Запрос данных
    func getWeatherData(location: Geolocation) {
        self.geoService?.getCityName(location: location) { city in
            self.dataFetcher?.getWeather(lat: location.latitude,
                                         lon: location.longitude) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    guard let data = data else { return }
                    self.transformData(data: data, city: city) { days in
                        self.viewController?.getWeatherData(data: days)
                    }
                case .failure(let error): print("Error: ", error)
                }
            }
        }
    }
    
    /// Преобразование данных
    private func transformData(data: WeatherModel,
                               city: String,
                               completion: @escaping ((AllWeatherDataUI) -> Void)) {
        var today = WeatherDataUI()
        var forecasts: [WeatherDataUI] = []
        today = WeatherDataUI(city: city,
                              temp: tempWithSign(temp: data.fact?.temp),
                              feelsLike: "По ощущениям: \(tempWithSign(temp: data.fact?.feelsLike))",
                              condition: self.factCondition(with: data.fact?.condition ?? ""))
        data.forecasts?.forEach({ day in
            var oneDay = WeatherDataUI()
            guard let date = day.date else { return }
            oneDay = WeatherDataUI(city: city,
                                   date: date.dateStringFromUnixtime(format: .short),
                                   temp: tempWithSign(temp: day.parts?.dayShort?.temp),
                                   feelsLike: tempWithSign(temp: day.parts?.dayShort?.feelsLike),
                                   condition: self.factCondition(with: day.parts?.dayShort?.condition ?? ""))
            forecasts.append(oneDay)
        })
        completion(AllWeatherDataUI(today: today,
                                    nexDays: forecasts))
    }
    
    /// Преобразование температуры
    private func tempWithSign(temp: Int?) -> String {
        guard let temp = temp else { return "--" }
        var tempString = ""
        temp > 0 ? (tempString = "+\(temp)°") : (tempString = "\(temp)°")
        return tempString
    }
    
    /// Погодные условия
    private func factCondition(with condition: String) -> String {
        switch condition {
        case "clear": return("Ясно")
        case "partlyCloudy": return("Малооблачно")
        case "cloudy": return("Облачно с прояснениями")
        case "overcast": return("Пасмурно")
        case "drizzle": return("Морось")
        case "lightRain": return("Небольшой дождь")
        case "rain": return("Дождь")
        case "moderateRain": return("Умеренно сильный дождь")
        case "heavyRain": return("Сильный дождь")
        case "continuousHeavyRain": return("Длительный сильный дождь")
        case "showers": return("Ливень")
        case "wetSnow": return("Дождь со снегом")
        case "lightSnow": return("Небольшой снег")
        case "snow": return("Снег")
        case "snowShowers": return("Снегопад")
        case "hail": return("Град")
        case "thunderstorm": return("Гроза")
        case "thunderstormWithRain": return("Дождь с грозой")
        case "thunderstormWithHail": return("Гроза с градом")
        default: return("Неопределено")
        }
    }
}


