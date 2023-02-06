//
//  RaMCharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 30/01/2023.
//

import UIKit

/// Cell view for a character
final class RaMCharacterCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "RaMCharacterCollectionViewCell"
    
    // MARK: - Views

    @UsesAutoLayout private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    @UsesAutoLayout private var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 18, weight: .medium)
        nameLabel.textColor = .ramBlue
        return nameLabel
    }()
    
    @UsesAutoLayout private var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.font = .systemFont(ofSize: 16, weight: .regular)
        statusLabel.textColor = .label
        return statusLabel
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .ramLightBlue
        contentView.addSubviews(imageView, nameLabel, statusLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
    
    // MARK: - Private
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            statusLabel.heightAnchor.constraint(equalToConstant: 30),
            statusLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            statusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -8)
        ])
    }
    
    private func setupLayer() {
        contentView.layer.cornerRadius = 8
    }
    
    // MARK: - Override

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupLayer()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
    }
    
    // MARK: - Public

    public func configure(with viewModel: RaMCharacterCollectionViewCellViewModel) {
        nameLabel.text = viewModel.characterName
        statusLabel.text = viewModel.characterStatusText
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.imageView.image = image
                }
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
}
