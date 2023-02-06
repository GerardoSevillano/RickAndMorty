//
//  RaMCharacterInfoCollectionViewCellViewModel.swift.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 31/01/2023.
//

import Foundation

final class RaMCharacterInfoCollectionViewCellViewModel {
    public let title: String
    public let value: String
    
    // MARK: - Init

    init(title: String, value: String) {
        self.title = title
        self.value = value
    }
}
