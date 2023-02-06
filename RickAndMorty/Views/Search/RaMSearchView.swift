//
//  RaMSearchView.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 02/02/2023.
//

import UIKit

protocol RaMSearchViewDelegate: AnyObject {
    func ramSearchView(_ searchView: RaMSearchView, didSelectFilterOption option: RaMSearchInputViewViewModel.FilterOption)
    func ramSearchView(_ searchView: RaMSearchView, didEnterValueInSearchBar value: String )
    func ramSearchViewDidPressClear(_ inputView: RaMSearchView)
    func ramSearchView(
        _ searchView: RaMSearchView,
        didSelectCharacter character: RaMCharacter
    )
}

final class RaMSearchView: UIView {
    
    weak var delegate: RaMSearchViewDelegate?
    
    private let viewModel: RaMSearchViewViewModel
    
    // MARK: - Views

    @UsesAutoLayout private var noResultsView = RaMNoSearchResultsView()
    @UsesAutoLayout private var searchInputView = RaMSearchInputView()
    
    @UsesAutoLayout private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.register(RaMCharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: RaMCharacterCollectionViewCell.cellIdentifier)
        return collectionView
    }()
    
    // MARK: - Init

    init(frame: CGRect, viewModel: RaMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(noResultsView, searchInputView, collectionView)
        addConstraints()
        setupCollectionView()
        searchInputView.configure(with: .init(type: viewModel.config.type))
        searchInputView.delegate = self
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
    
    // MARK: - Private
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            //Search input view contstraints
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 50 : 110),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            
            //No results view constraints
            noResultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            noResultsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            noResultsView.leftAnchor.constraint(equalTo: leftAnchor),
            noResultsView.rightAnchor.constraint(equalTo: rightAnchor),
            
            //Results collectionView
            collectionView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor, constant: 2),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor)
            
        ])
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
        collectionView.isHidden = true
    }
    
}


//MARK: - RaMSearchViewViewModelDelegate

extension RaMSearchView: RaMSearchViewViewModelDelegate {
    func didFindSearchResults(notEmpty: Bool) {
        if notEmpty {
            collectionView.reloadData()
            collectionView.isHidden = false
            noResultsView.isHidden = true
            UIView.animate(withDuration: 0.4) {
                self.collectionView.alpha = 1
            }
        } else {
            collectionView.reloadData()
            noResultsView.isHidden = false
            collectionView.isHidden = true
            UIView.animate(withDuration: 0.4) {
                self.collectionView.alpha = 0
            }
        }
    }
    
    func didSelectCharacter(_ character: RaMCharacter) {
        delegate?.ramSearchView(self, didSelectCharacter: character)
        return
    }
}

// MARK: - RaMSearchInputViewDelegate

extension RaMSearchView: RaMSearchInputViewDelegate {
    func ramSearchInputViewDidPressClear(_ inputView: RaMSearchInputView) {
        delegate?.ramSearchViewDidPressClear(self)
    }
    
    func ramSearchInputView(_ inputView: RaMSearchInputView, didEnterValueInSearchBar value: String) {
        delegate?.ramSearchView(self, didEnterValueInSearchBar: value)
    }
    
    func ramSearchInputView(_ inputView: RaMSearchInputView, didSelectOption option: RaMSearchInputViewViewModel.FilterOption) {
        delegate?.ramSearchView(self, didSelectFilterOption: option)
    }
}
