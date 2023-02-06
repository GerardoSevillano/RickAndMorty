//
//  RaMCharacterListView.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 30/01/2023.
//

import UIKit

protocol RaMCharacterListViewDelegate: AnyObject {
    func ramCharacterListView(
        _ characterListView: RaMCharacterListView,
        didSelectCharacter character: RaMCharacter
    )
}

/// Shows list of characters
final class RaMCharacterListView: UIView {
    
    public weak var delegate: RaMCharacterListViewDelegate?
    
    private let viewModel = RaMCharacterListViewViewModel(apiService: RaMService(cacheManager: RaMAPICacheManager()))
    
    // MARK: - Views

    @UsesAutoLayout private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.register(RaMCharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: RaMCharacterCollectionViewCell.cellIdentifier)
        collectionView.register(
            RaMFooterLoadingCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: RaMFooterLoadingCollectionReusableView.identifier)
        return collectionView
    }()
    
    @UsesAutoLayout private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, spinner)
        addConstraints()
        spinner.startAnimating()
        setupCollectionView()
        viewModel.fetchCharacters()
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    // MARK: - Private
    
    private func addConstraints() {
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
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
}

// MARK: - RaMCharacterListViewViewModelDelegate

extension RaMCharacterListView: RaMCharacterListViewViewModelDelegate {
    func didLoadInitialCharacters() {
        spinner.stopAnimating()
        collectionView.reloadData()
        collectionView.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
    
    func didSelectCharacter(_ character: RaMCharacter) {
        delegate?.ramCharacterListView(
            self,
            didSelectCharacter: character)
    }
    
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath]) {
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: newIndexPaths)
        }
    }
}
