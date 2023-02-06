//
//  RaMCharacterGender.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 30/01/2023.
//

import Foundation

// MARK: - RaMCharacterGender Enum
enum RaMCharacterGender: String, Codable, CaseIterable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
    
    var filterText: String {
        switch self {
        case .female:
            return "female"
        case .male:
            return "male"
        case .genderless:
            return "genderless"
        case .unknown:
            return "unknown"
        }
    }
}
