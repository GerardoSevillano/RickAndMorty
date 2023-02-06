//
//  RaMServiceError.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 05/02/2023.
//

import Foundation

public enum RaMServiceError: Error {
    case failedToCreateRequest
    case failedToGetData
    case failedToDecodeData
}
