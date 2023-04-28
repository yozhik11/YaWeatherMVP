//
//  WeatherDataUI.swift
//  AprelTest
//
//  Created by Natalia Shevaldina on 27.04.2023.
//

import UIKit

// Модель подготовленных для UI данных
struct AllWeatherDataUI {
    public var today: WeatherDataUI
    public var nexDays: [WeatherDataUI]
}

// Данные одного дня
struct WeatherDataUI {
    public var city: String = "--"
    public var date: String = "--"
    public var temp: String = "--"
    public var feelsLike: String = "--"
    public var condition: String = "--"
}


