//
//  RaMSearchPickerViewViewModel.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 03/02/2023.
//

import Foundation

final class RaMSearchPickerViewViewModel {
    
    private let type: RaMSearchInputViewViewModel.FilterOption
    
    init(type: RaMSearchInputViewViewModel.FilterOption) {
        self.type = type
    }
    
    //MARK: - Public
    public private(set) var queryParam: URLQueryItem?
    
    
    // MARK: - Public

    public var filterOptionsValues: [String] {
        switch type {
        case .status:
            return RaMCharacterStatus.allCases.compactMap({$0.filterText})
        case .gender:
            return RaMCharacterGender.allCases.compactMap({$0.filterText})
        }
    }
    
    public var filterOptionName: String {
        switch type {
        case .gender:
            return "gender"
        case .status:
            return "status"
        }
    }
    
    public func setQueryParam(item: URLQueryItem){
        queryParam = item
    }
}
