//
//  RaMCharacterStatus.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 30/01/2023.
//

import Foundation

// MARK: - RaMCharacterStatus Enum
enum RaMCharacterStatus: String, Codable, CaseIterable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    
    var text: String {
        switch self {
        case .alive, .dead:
            return rawValue
        case .unknown:
            return "Unkown"
        }
    }
    
    var filterText: String {
        switch self {
        case .alive:
            return "alive"
        case .dead:
            return "dead"
        case .unknown:
            return "unknown"
            
        }
    }
}
