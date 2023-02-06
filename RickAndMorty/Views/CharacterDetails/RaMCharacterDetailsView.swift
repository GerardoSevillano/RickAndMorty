//
//  RaMCharacterDetailsView.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 30/01/2023.
//

import UIKit

/// Shows details of an specific character
final class RaMCharacterDetailsView: UIView {
    
    private var collectionView: UICollectionView?
    
    private var viewModel: RaMCharacterDetailsViewViewModel
    
    // MARK: - Views

    @UsesAutoLayout private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // MARK: - Init
    
    init(frame: CGRect, viewModel: RaMCharacterDetailsViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .ramLightBlue
        let collectionView = createCollectionView()
        collectionView.backgroundColor = .clear
        self.collectionView = collectionView
        addSubviews(collectionView, spinner)
        addConstraints()
        setupCollectionView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
    
    // MARK: - Private

    private func addConstraints() {
        guard let collectionView = collectionView else {
            return
        }
        
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    private func setupCollectionView() {
        guard let collectionView = collectionView else {
            return
        }
        
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            return self?.createSection(for: sectionIndex)
        }
        @UsesAutoLayout var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RaMCharacterPhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: RaMCharacterPhotoCollectionViewCell.cellIdentifier)
        collectionView.register(RaMCharacterInfoCollectionViewCell.self,
                                forCellWithReuseIdentifier: RaMCharacterInfoCollectionViewCell.cellIdentifier)
        collectionView.register(RaMCharacterEpisodesCollectionViewCell.self,
                                forCellWithReuseIdentifier: RaMCharacterEpisodesCollectionViewCell.cellIdentifier)
        return collectionView
    }
    
    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        
        let sectionTypes = viewModel.sections
        switch sectionTypes[sectionIndex] {
        case .photo:
            return viewModel.createPhotoSectionLayout()
        case .information:
            return viewModel.createInformationSectionLayout()
        case .episodes:
            return viewModel.createEpisodesSectionLayout()
        }
        
    }
}
