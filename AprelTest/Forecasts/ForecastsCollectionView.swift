//
//  ForerastsCollectionView.swift
//  AprelTest
//
//  Created by Natalia Shevaldina on 28.04.2023.
//

import UIKit

/// Класс недельного прогноза погоды CollectionView
class ForecastsCollectionView: UICollectionView {
    var cells: [WeatherDataUI]?
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        delegate = self
        dataSource = self
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        contentInset.top = 2
        contentInset.bottom = 12
        register(ForecastsCollectionViewCell.self,
                 forCellWithReuseIdentifier: ForecastsCollectionViewCell.reuseId)
    }
        
    /// Инициализация и обновление данных
    func set(cells: [WeatherDataUI]){
        self.cells = cells
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ForecastsCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let cells = cells else { return 0 }
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: ForecastsCollectionViewCell.reuseId,
                                       for: indexPath) as? ForecastsCollectionViewCell
        guard let cell = cell else { return ForecastsCollectionViewCell()}
        guard let cells = cells else { return cell}
        cell.configure(data: cells[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = bounds.size.width
        let height: CGFloat = 50
        return CGSize(width: width, height: height)
    }
}
