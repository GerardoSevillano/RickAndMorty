//
//  RaMSearchInputViewViewModel.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 02/02/2023.
//

import Foundation

final class RaMSearchInputViewViewModel {
    
    enum FilterOption: String {
        case status = "Status"
        case gender = "Gender"
    }
    
    private let type: RaMSearchViewController.Config.`Type`
    
    init(type: RaMSearchViewController.Config.`Type`) {
        self.type = type
    }
    
    //MARK: - Public
    
    public var hasFilterOptions: Bool {
        switch type {
        case .character:
            return true
        case .episode, .location:
            return false
        }
    }
    
    public var filterOptions: [FilterOption] {
        switch type {
        case .character:
            return [.status, .gender]
        case .episode, .location:
            return []
        }
    }
    
    public var searchPlaceHolderText: String {
        switch type {
        case .character:
            return "Charater name"
        case .episode:
            return "Episode name"
        case .location:
            return "Location name"
        }
    }

}
