//
//  ViewController.swift
//  AprelTest
//
//  Created by Natalia Shevaldina on 25.04.2023.
//

import UIKit

/// Протокол ViewController получени данных
protocol ViewProtocol {
    func getWeatherData(data: AllWeatherDataUI)
}

// MARK: - ViewController
final class ViewController: UIViewController {
    var presenter: PresenterProtocol?
    
    // MARK: - PrivateProperties
    private let cityLabel = UILabel()
    private let tempFactLabel = UILabel()
    private let tempFeelsLikeLabel = UILabel()
    private let conditionLabel = UILabel()
    private var forerastsCollectionView = ForecastsCollectionView()
    
    /// viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        presenter = Presenter(viewController: self,
                              dataFetcher: DataFetcher(),
                              geoService: GeolocationService())
    }
}

// MARK: - ViewProtocol Impl
extension ViewController: ViewProtocol {
    /// Метод получения данных
    func getWeatherData(data: AllWeatherDataUI) {
        setupUI(data: data)
        forerastsCollectionView.set(cells: data.nexDays)
    }
}

// MARK: - PrivateMethods
private extension ViewController {
    /// Сетап контроллера
    func setupViewController() {
        addSubViews()
        setupConstraints()
        view.backgroundColor = .systemBackground
    }
    
    /// Установка параметров для лейбла
    /// - Parameters:
    ///   - label: лейбл
    ///   - fontSize: размер шрифта
    ///   - text: текст
    func setLabel(label: UILabel, fontSize: CGFloat, text: String) {
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.text = text
    }
    
    /// Настройка лейблов
    func setupUI(data: AllWeatherDataUI) {
        DispatchQueue.main.async {
            self.setLabel(label: self.cityLabel, fontSize: 20, text: data.today.city)
            self.setLabel(label: self.tempFactLabel, fontSize: 150, text: data.today.temp)
            self.setLabel(label: self.tempFeelsLikeLabel, fontSize: 16, text: data.today.feelsLike)
            self.setLabel(label: self.conditionLabel, fontSize: 16, text: data.today.condition)
        }
    }
    
    /// Добавление сабвью
    func addSubViews() {
        view.addSubviews(cityLabel,
                         tempFactLabel,
                         tempFeelsLikeLabel,
                         conditionLabel,
                         forerastsCollectionView)
    }
    
    /// Настройка отступов
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            tempFactLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 100),
            tempFactLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            tempFactLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tempFeelsLikeLabel.topAnchor.constraint(equalTo: tempFactLabel.bottomAnchor, constant: 24),
            tempFeelsLikeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            tempFeelsLikeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            conditionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            conditionLabel.topAnchor.constraint(equalTo: tempFeelsLikeLabel.bottomAnchor, constant: 8),
            
            forerastsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            forerastsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            forerastsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            forerastsCollectionView.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 24)
        ])
    }
}
