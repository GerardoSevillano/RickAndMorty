//
//  RaMCharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 31/01/2023.
//

import Foundation

final class RaMCharacterPhotoCollectionViewCellViewModel {
    
    private let imageURL: URL?
    
    private let imageManager: ImageLoader

    // MARK: - Init

    init(imageURL: URL?, imageManager: ImageLoader) {
        self.imageURL = imageURL
        self.imageManager = imageManager
    }
    
    // MARK: - Public

    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = imageURL else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        imageManager.downloadImage(url, completion: completion)
    }
}
