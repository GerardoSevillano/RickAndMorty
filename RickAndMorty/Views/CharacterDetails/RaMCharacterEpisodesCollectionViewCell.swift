//
//  RaMCharacterEpisodesCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 31/01/2023.
//

import UIKit

final class RaMCharacterEpisodesCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RaMCharacterEpisodesCollectionViewCell"

    // MARK: - Views

    @UsesAutoLayout private var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 16, weight: .regular)
        nameLabel.textColor = .label
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        return nameLabel
    }()
    
    @UsesAutoLayout private var episodeLabel: UILabel = {
        let episodeLabel = UILabel()
        episodeLabel.font = .systemFont(ofSize: 20, weight: .medium)
        episodeLabel.adjustsFontSizeToFitWidth = true
        episodeLabel.textColor = .label
        episodeLabel.textAlignment = .center
        return episodeLabel
    }()
    
    @UsesAutoLayout private var airDateLabel: UILabel = {
        let airDateLabel = UILabel()
        airDateLabel.font = .systemFont(ofSize: 14, weight: .light)
        airDateLabel.adjustsFontSizeToFitWidth = true
        airDateLabel.textColor = .label
        airDateLabel.numberOfLines = 0
        airDateLabel.textAlignment = .center
        return airDateLabel
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .ramBlue
        contentView.layer.cornerRadius = 8
        contentView.addSubviews(episodeLabel, nameLabel, airDateLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
    
    // MARK: - Private

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            episodeLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            episodeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 2),
            episodeLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            episodeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -2),
            
            nameLabel.topAnchor.constraint(equalTo: episodeLabel.bottomAnchor),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 2),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -2),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.25),
            
            airDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            airDateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 2),
            airDateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -2),
            airDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

    }
    
    // MARK: - Override

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        episodeLabel.text = nil
        airDateLabel.text = nil
    }
    
    // MARK: - Public

    public func configure(with viewModel: RaMCharacterEpisodesCollectionViewCellViewModel) {
        viewModel.registerForData { [weak self] data in
            self?.nameLabel.text = data.name
            self?.episodeLabel.text = data.episode
            self?.airDateLabel.text = data.air_date
        }
        viewModel.fetchEpisode()
    }
}
