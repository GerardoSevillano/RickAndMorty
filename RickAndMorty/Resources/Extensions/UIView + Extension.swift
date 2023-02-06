//
//  UIView + Extension.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 30/01/2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            addSubview(view)
        }
    }
}
