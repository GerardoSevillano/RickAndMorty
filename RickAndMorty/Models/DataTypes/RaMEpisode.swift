//
//  RaMEpisode.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 30/01/2023.
//

import Foundation

struct RaMEpisode: Codable, RaMEpisodeDataRender {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}
