//
//  RaMCharacter.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 30/01/2023.
//

import Foundation
import UIKit

struct RaMCharacter: Codable {
    let id: Int
    let name: String
    let status: RaMCharacterStatus
    let species: String
    let type: String
    let gender: RaMCharacterGender
    let origin: RaMOrigin
    let location: RaMCharacterLocation
    let image: String
    let episode : [String]
    let url: String
    let created: String
}
