//
//  RaMFooterLoadingCollectionReusableView.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 31/01/2023.
//

import UIKit

final class RaMFooterLoadingCollectionReusableView: UICollectionReusableView {
    static let identifier = "RaMFooterLoadingCollectionReusableView"
    
    // MARK: - Views

    @UsesAutoLayout private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(spinner)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
    
    // MARK: - Private

    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Public

    public func startAnimating() {
        spinner.startAnimating()
    }
}
