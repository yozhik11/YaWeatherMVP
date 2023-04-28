//
//  ForerastsCollectionViewCell.swift
//  AprelTest
//
//  Created by Natalia Shevaldina on 28.04.2023.
//

import UIKit

/// Ячейка CollectionView с данными погоды на один день
class ForecastsCollectionViewCell: UICollectionViewCell {
    static let reuseId = "ForecastsCollectionViewCell"
    
    private let dateLabel = UILabel()
    private let tempFactLabel = UILabel()
    private let conditionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubViews()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - PrivateMethods
extension ForecastsCollectionViewCell {
    /// Добавление сабвью
    func addSubViews() {
        contentView.addSubviews(dateLabel,
                                tempFactLabel,
                                conditionLabel)
    }
    
    /// Установка параметров для лейбла
    /// - Parameters:
    ///   - label: лейбл
    ///   - alignment: расположение
    func setLabel(label: UILabel, alignment: NSTextAlignment) {
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.textColor = .black
        label.textAlignment = alignment
        label.font = UIFont.systemFont(ofSize: 14)
    }
    /// Настройка лейблов
    func setupUI() {
        DispatchQueue.main.async {
            self.setLabel(label: self.dateLabel, alignment: .left)
            self.setLabel(label: self.tempFactLabel, alignment: .left)
            self.setLabel(label: self.conditionLabel, alignment: .right)
        }
    }
    /// Конфигурация ячейки
    func configure (data: WeatherDataUI){
        setupUI()
        dateLabel.text = data.date
        tempFactLabel.text = data.temp
        conditionLabel.text = data.condition
    }
    /// Настройка отступов
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            tempFactLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            tempFactLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            conditionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            conditionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
            
        ])
    }
}
