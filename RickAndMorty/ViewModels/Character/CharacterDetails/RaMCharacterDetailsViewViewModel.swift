//
//  RaMCharacterDetailsViewViewModel.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 30/01/2023.
//

import Foundation
import UIKit

final class RaMCharacterDetailsViewViewModel: NSObject {
    
    private let character: RaMCharacter
        
    enum SectionType {
        case photo(viewModel: RaMCharacterPhotoCollectionViewCellViewModel)
        
        case information(viewModels: [RaMCharacterInfoCollectionViewCellViewModel])
        
        case episodes(viewModels: [RaMCharacterEpisodesCollectionViewCellViewModel])
    }
    
    public var sections: [SectionType] = []
    
    // MARK: - Init
    
    init(character: RaMCharacter) {
        self.character = character
        super.init()
        setupSections()
    }
    
    // MARK: - Public

    public var title: String {
        character.name
    }
    
    public var requestURL: URL? {
        URL(string: character.url)
    }
    
    // MARK: - Private

    private func setupSections() {
        sections = [
            .photo(viewModel: .init(imageURL: URL(string: character.image), imageManager: RaMImageLoaderManager())),
            .information(viewModels: [
                .init(title: "Status: ", value: character.status.rawValue),
                .init(title: "Species: ", value: character.species),
                .init(title: "Type: ", value: character.type),
                .init(title: "Gender: ", value: character.gender.rawValue),
                .init(title: "Origin: ", value: character.origin.name),
                .init(title: "Total episodes: ", value: String(character.episode.count)),
            ]),
            .episodes(viewModels: character.episode.compactMap {
                .init(episodeURL: URL(string: $0), apiService: RaMService(cacheManager: RaMAPICacheManager()))
            })
        ]
    }
}

// MARK: - CollectionView

extension RaMCharacterDetailsViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = sections[section]
        switch sectionType {
        case .photo(_):
            return 1
        case .information(let viewModels):
            return viewModels.count
        case .episodes(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let sectionType = sections[indexPath.section]
        
        switch sectionType {
        case .photo(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RaMCharacterPhotoCollectionViewCell.cellIdentifier, for: indexPath) as? RaMCharacterPhotoCollectionViewCell else {
                fatalError("RaMCharacterPhotoCollectionViewCell not supported")
            }
            cell.configure(with: viewModel)
            return cell
            
        case .information(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RaMCharacterInfoCollectionViewCell.cellIdentifier, for: indexPath) as? RaMCharacterInfoCollectionViewCell else {
                fatalError("RaMCharacterInfoCollectionViewCell not supported")
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
        case .episodes(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RaMCharacterEpisodesCollectionViewCell.cellIdentifier, for: indexPath) as? RaMCharacterEpisodesCollectionViewCell else {
                fatalError("RaMCharacterEpisodesCollectionViewCell not supported")
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        }
    }
}

// MARK: - Layout functions
extension RaMCharacterDetailsViewViewModel {
    
    public func createPhotoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.55)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    public func createInformationSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0)

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(40)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    public func createEpisodesSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 10)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.8),
                heightDimension: .absolute(150)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
}
