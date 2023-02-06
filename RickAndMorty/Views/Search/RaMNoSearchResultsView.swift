//
//  RaMNoSearchResultsView.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 02/02/2023.
//

import UIKit

/// Showed when no results or error returned from the search
class RaMNoSearchResultsView: UIView {

    private let viewModel = RaMNoSearchResultsViewViewModel()
    
    // MARK: - Views

    @UsesAutoLayout private var noResultsView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .ramBlue
        return imageView
    }()
    
    @UsesAutoLayout private var noResultsTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .ramBlue
        return label
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .ramLightBlue
        isHidden = true
        addSubviews(noResultsView, noResultsTitle)
        addConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
    
    // MARK: - Private
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
        
            noResultsView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            noResultsView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40),
            
            noResultsTitle.topAnchor.constraint(equalTo:noResultsView.bottomAnchor, constant: 15),
            noResultsTitle.heightAnchor.constraint(equalToConstant: 40),
            noResultsTitle.centerXAnchor.constraint(equalTo: centerXAnchor)
        
        ])
    }
    
    private func configure() {
        noResultsTitle.text = viewModel.title
        noResultsView.image = viewModel.imageName?.withRenderingMode(.alwaysTemplate)
    }
}
