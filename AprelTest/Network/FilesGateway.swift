//
//  FilesGateway.swift
//  AprelTest
//
//  Created by Natalia Shevaldina on 25.04.2023.
//

import Foundation

// Протокол создания реквеста
protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

// Метод запроса
enum HTTPMethod: String {
    case get = "GET"
}

enum FilesGateway: URLRequestConvertible {
    
    static let baseURLString = "https://api.weather.yandex.ru/v2/forecast"
    
    case weatherData(lat: String, lon: String)
    
    var method: HTTPMethod {
        switch self {
        case .weatherData:
            return .get
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case .weatherData(let lat, let lon):
            return ["lat": lat, "lon": lon, "limit": "7"]
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .weatherData:
            return ["X-Yandex-API-Key": Constants.apiKey]
        }
    }
    
    // Метод создания реквеста
    func asURLRequest() throws -> URLRequest {
        let urlString = Self.baseURLString
        var components = URLComponents(string: urlString)
        components?.queryItems = []
        
        self.parameters.forEach { (key, value) in
            components?.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        guard let url = components?.url else {
            throw NSError(domain: "Error", code: 5)
        }
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        request.timeoutInterval = 5
        self.headers.forEach { (key, value) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        //        print("Request CURL: ", request.cURL())
        return request
    }
}
