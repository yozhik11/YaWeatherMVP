//
//  DiskDataFetcher.swift
//  AprelTest
//
//  Created by Natalia Shevaldina on 25.04.2023.
//

import Foundation

// Протокол класса DataFetcher
protocol DataFetcherProtocol {
    func getWeather(lat: String,
                    lon: String,
                    completion: @escaping (Result<WeatherModel?, Error>) -> Void)
}

// Класс получения удаленных данных
class DataFetcher: DataFetcherProtocol {
    let network = NetworkService()
    
    // Метод получения данных о погоде
    func getWeather(lat: String,
                    lon: String,
                    completion: @escaping (Result<WeatherModel?, Error>) -> Void) {
        network.request(FilesGateway.weatherData(lat: lat, lon: lon),
                        responseType: WeatherModel.self) { result in
            switch result {
            case .success(let list):
                completion(.success(list))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
