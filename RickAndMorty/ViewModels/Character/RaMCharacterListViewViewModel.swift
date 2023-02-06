//
//  RaMCharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 30/01/2023.
//

import UIKit

protocol RaMCharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
    func didSelectCharacter(_ character: RaMCharacter)
}

final class RaMCharacterListViewViewModel: NSObject {
    
    public weak var delegate: RaMCharacterListViewViewModelDelegate?
    
    private let apiService: APIService
    
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
    
    private var apiInfo: GetAllCharactersResponse.Info? = nil
    
    private var isLoadingMoreCharacters = false
    
    // MARK: - Init

    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    // MARK: - Public

    /// Fetch initial characters
    public func fetchCharacters() {
        apiService.executeRequest(
            .listOfCharacters,
            expecting: GetAllCharactersResponse.self)
        { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                
                self?.characters = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(error)
            
            }
        }
    }
    
    public var shouldShowMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    /// Pagination to fetch additional characters
    public func fetchAdditionalCharacters(url: URL) {
        guard !isLoadingMoreCharacters else {
            return
        }
        isLoadingMoreCharacters = true
        guard let request = RaMRequest(url: url) else {
            isLoadingMoreCharacters = false
            print("Failed to create request")
            return
        }
        apiService.executeRequest(request,
                                         expecting: GetAllCharactersResponse.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                
                let originalCount = strongSelf.characters.count
                let newCount = moreResults.count
                let total = originalCount + newCount
                let startingIndex = total - newCount
                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap {
                    return IndexPath(row: $0, section: 0)
                }
                
                strongSelf.characters.append(contentsOf: moreResults)
                strongSelf.apiInfo = info
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreCharacters(with: indexPathsToAdd)
                    strongSelf.isLoadingMoreCharacters = false
                }
            case .failure(let error):
                print(String(describing: error))
                strongSelf.isLoadingMoreCharacters = false
            }
            
        }

    }
}

// MARK: - CollectionView

extension RaMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
        let frame = collectionView.frame
        let width = (frame.width - 30) / 2
        return CGSize(width: width,
                      height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(
                  ofKind: kind,
                  withReuseIdentifier: RaMFooterLoadingCollectionReusableView.identifier,
                  for: indexPath
              ) as? RaMFooterLoadingCollectionReusableView
        else {
            fatalError("Not supported")
        }
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowMoreIndicator else {
            return .zero
        }
        return CGSize(
            width: collectionView.frame.width,
            height: 100
        )
    }
    
}

// MARK: - ScrollView

extension RaMCharacterListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowMoreIndicator,
              !isLoadingMoreCharacters,
              !cellViewModels.isEmpty,
              let nextURLString = apiInfo?.next,
              let url = URL(string: nextURLString) else {
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewHeight = scrollView.frame.height
            
            if offset >= (totalContentHeight - totalScrollViewHeight - /* Load indicator view height plus buffer */ 120) {
                //start fetching more
                self?.fetchAdditionalCharacters(url: url)
            }
            t.invalidate()
        }
        
    }
}
