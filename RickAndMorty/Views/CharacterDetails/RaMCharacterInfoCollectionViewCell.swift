//
//  RaMCharacterInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 31/01/2023.
//

import UIKit

final class RaMCharacterInfoCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "RaMCharacterInfoCollectionViewCell"

    // MARK: - Views

    @UsesAutoLayout private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .ramBlue
        return titleLabel
    }()
    
    @UsesAutoLayout private var valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.font = .systemFont(ofSize: 16, weight: .regular)
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.textColor = .label
        valueLabel.numberOfLines = 0
        return valueLabel
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(titleLabel, valueLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
    
    // MARK: - Private

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            valueLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 5),
            valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Override

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        valueLabel.text = ""
    }
    
    // MARK: - Public

    public func configure(with viewModel: RaMCharacterInfoCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.value.isEmpty ? "-" : viewModel.value
    }
}
