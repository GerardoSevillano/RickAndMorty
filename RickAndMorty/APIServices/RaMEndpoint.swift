//
//  RaMEndpoint.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 30/01/2023.
//

import Foundation

///Represents unique API endpoints
enum RaMEndpoint: String, CaseIterable, Hashable {
    /// Endpoint to get characters
    case character
    /// Endpoint to get episodes
    case episode
    /// Endpoint to get locations
    case location
}
