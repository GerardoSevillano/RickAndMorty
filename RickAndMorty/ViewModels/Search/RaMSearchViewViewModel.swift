//
//  RaMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 02/02/2023.
//

import Foundation
import UIKit

protocol RaMSearchViewViewModelDelegate: AnyObject {
    func didFindSearchResults(notEmpty: Bool)
    func didSelectCharacter(_ character: RaMCharacter)
}

//ViewModel for search
final class RaMSearchViewViewModel: NSObject {
    let config: RaMSearchViewController.Config
    
    private let apiService: APIService
    
    public weak var delegate: RaMSearchViewViewModelDelegate?
    
    public var queryParameters: [URLQueryItem] = []
    
    private var characters: [RaMCharacter] = [] {
        didSet {
            for character in characters {
                let viewModel = RaMCharacterCollectionViewCellViewModel(characterName: character.name, characterStatus: character.status, characterImageURL: URL(string: character.image), imageManager: RaMImageLoaderManager())
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [RaMCharacterCollectionViewCellViewModel] = []
    
    // MARK: - Init

    init(config: RaMSearchViewController.Config, apiService: APIService = RaMService(cacheManager: RaMAPICacheManager())) {
        self.config = config
        self.apiService = apiService
    }
    
    // MARK: - Public

    public func addQueryParam(param: URLQueryItem) {
        let removeIndex = queryParameters.firstIndex { queryItem in
            queryItem.name == param.name
        }
        
        if let value = param.value, value.isEmpty, let index = removeIndex {
            queryParameters.remove(at: index)
            return
        } else if let index = removeIndex {
            queryParameters.remove(at: index)
        }
        
        queryParameters.append(param)
        print(queryParameters)
    }
    
    public func clearQueryParams() {
        queryParameters = []
        print(queryParameters)
    }
    
    /// Filter action
    public func executeSearch() {
        self.cellViewModels = []
        let request = RaMRequest(endpoint: config.filterEndpoint, queryParameters: queryParameters)
        apiService.executeRequest(
            request,
            expecting: GetAllCharactersResponse.self)
        { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results

                self?.characters = results
                DispatchQueue.main.async {
                    self?.delegate?.didFindSearchResults(notEmpty: !results.isEmpty)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.delegate?.didFindSearchResults(notEmpty: false)
                }
            }
        }
    }
    
}


// MARK: - CollectionView

extension RaMSearchViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RaMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RaMCharacterCollectionViewCell else {
            fatalError("RaMCharacterCollectionViewCell not supported")
        }
        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(width: width,
                      height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
    
    
}
