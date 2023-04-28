//
//  ViewController.swift
//  AprelTest
//
//  Created by Natalia Shevaldina on 27.04.2023.
//

import UIKit

extension UIView {
    // Добавление сабвью
    func myAddSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            myAddSubview(view)
        }
    }
}
