//
//  RaMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 30/01/2023.
//

import Foundation

final class RaMCharacterCollectionViewCellViewModel {
    
    public let characterName: String
    private let characterStatus: RaMCharacterStatus
    private let characterImageURL: URL?
    private let imageManager: ImageLoader
        
    //MARK: - Init
    
    init(characterName: String, characterStatus: RaMCharacterStatus, characterImageURL: URL?, imageManager: ImageLoader) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageURL = characterImageURL
        self.imageManager = imageManager
    }
    
    // MARK: - Public

    public var characterStatusText: String {
        return "Status: \(characterStatus.text)"
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = characterImageURL else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        imageManager.downloadImage(url, completion: completion)
    }
}


extension RaMCharacterCollectionViewCellViewModel: Hashable, Equatable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageURL)
    }
    
    static func == (lhs: RaMCharacterCollectionViewCellViewModel, rhs: RaMCharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
