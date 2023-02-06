//
//  RaMRequest.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 30/01/2023.
//

import Foundation

/// Represents a simple API call
final class RaMRequest {
    
    // MARK: - Private
    
    /// API Constants
    private struct Constants {
        //Base url
        static let baseURL: String = "https://rickandmortyapi.com/api"
    }
    
    //Endpoint desired
    let endpoint: RaMEndpoint
    
    //Path components, if any
    private let pathComponents: [String]
    
    //Query parameters, if any
    private let queryParameters: [URLQueryItem]
    
    //Computed url string for the request
    private var urlString: String {
        var string = Constants.baseURL
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach({
                string += "/\($0)"
            })
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else {return nil}
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            string += argumentString
        }
        
        return string
    }
    
    // MARK: - Public
    
    /// Constructor of the request
    /// - Parameters:
    ///   - endpoint: Target endpoint
    ///   - pathComponents: Request path components
    ///   - queryParameters: Request query parameters
    public init(endpoint: RaMEndpoint,
         pathComponents: [String] = [],
         queryParameters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    /// Creates request from URL
    /// - Parameter url: Source url
    convenience init? (url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseURL) {
            return nil
        }
        
        let trimmed = string.replacingOccurrences(of: Constants.baseURL+"/", with: "")
        
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0]
                var pathComponents: [String] = []
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst() //First is the endpoint
                }
                if let ramEndpoint = RaMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: ramEndpoint, pathComponents: pathComponents)
                    return
                }
            }
        } else if trimmed.contains("?") {
            //Pagination and queryItems
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemString = components[1]
                let queryItems: [URLQueryItem] = queryItemString.components(separatedBy: "&").compactMap ({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    return URLQueryItem(name: parts[0], value: parts[1])
                })
                if let ramEndpoint = RaMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: ramEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }
        
        return nil
    }
    
    /// Computed url
    public var url: URL? {
        return URL(string: urlString)
    }
    
    /// Desired HTTP method
    public let httpMethod = "GET"
}

extension RaMRequest {
    static let listOfCharacters = RaMRequest(endpoint: .character)
}
