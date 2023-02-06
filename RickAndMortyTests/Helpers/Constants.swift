//
//  Constants.swift
//  RickAndMortyTests
//
//  Created by Gerardo Sevillano on 04/02/2023.
//

import Foundation
@testable import RickAndMorty

let urlStrings: [String] = [
    "https://rickandmortyapi.com/api/character",
    "https://rickandmortyapi.com/api/character?name=Rick&gender=male",
    "https://rickandmortyapi.com/api/character/1"
]

let queryParams = [URLQueryItem(name: "name", value: "Rick"), URLQueryItem(name: "gender", value: "male")]

let getCharacter2URL = URL(string: "https://rickandmortyapi.com/api/character/2")!

let getCharacterFalseURL = URL(string: "https://rickandmortyapi.com/api/character/false")!

let characterRequest = RaMRequest(url: getCharacter2URL)
let falseCharacterRequest = RaMRequest(url: getCharacterFalseURL)

let character2 = RaMCharacter(id: 2, name: "Morty Smith", status: RaMCharacterStatus(rawValue: "Alive")!, species: "Human", type: "", gender: RaMCharacterGender(rawValue: "Male")!, origin: RaMOrigin(name: "Earth", url: "https://rickandmortyapi.com/api/location/1"), location: RaMCharacterLocation(name: "Earth", url: "https://rickandmortyapi.com/api/location/20"), image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg", episode: [""], url: "https://rickandmortyapi.com/api/character/2", created: "2017-11-04T18:50:21.651Z")

enum MockError: Error, Codable {
    case mockError
}
