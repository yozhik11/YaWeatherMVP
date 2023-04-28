//
//  Model.swift
//  AprelTest
//
//  Created by Natalia Shevaldina on 25.04.2023.
//

import Foundation

// Модель всех данных с API
public struct WeatherModel: Codable {
    public var nowDt: Double?
    public var fact: DayWeather?
    public var forecasts: [ForecastsWeather]?
    
    enum CodingKeys: String, CodingKey {
        case nowDt = "now"
        case fact = "fact"
        case forecasts = "forecasts"
    }
}

// Данные о погоде за один день
public struct DayWeather: Codable {
    public var temp: Int?
    public var feelsLike: Int?
    public var condition: String?
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case feelsLike = "feels_like"
        case condition = "condition"
    }
}

// Модель прогноза по дням
public struct ForecastsWeather: Codable {
    public var date: Double?
    public var parts: Parts?
    
    enum CodingKeys: String, CodingKey {
        case date = "date_ts"
        case parts = "parts"
    }
}

// Модель данных прогноза одного дня
public struct Parts: Codable {
    public var dayShort: DayWeather?
    
    enum CodingKeys: String, CodingKey {
        case dayShort = "day_short"
    }
}

