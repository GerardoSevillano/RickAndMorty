//
//  RaMService.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 30/01/2023.
//

import Foundation

/// Protocol for any API Service to be used in the app
protocol APIService {
    func executeRequest<T: Codable>(_ request: RaMRequest, expecting type: T.Type, completion: @escaping (Result<T, Error>) -> Void)
}

/// Main service to get Rick and Morty data
final class RaMService: APIService {
    
    private let cacheManager: CacheManager
    private let session: URLSession
    
    /// Constructor
    /// - Parameters:
    ///   - urlSession: URL session to be used
    ///   - cacheManager: Manager responsible for the caching
    init(urlSession: URLSession = .shared , cacheManager: CacheManager) {
        self.cacheManager = cacheManager
        self.session = urlSession
    }
    
    //MARK: - Public
    
    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - type: Type expected to return from the request
    ///   - completion: Complition callback
    public func executeRequest<T: Codable>(_ request: RaMRequest, expecting type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        if let cachedData = cacheManager.cachedResponse(for: request.endpoint, url: request.url) {
            //Decode response
            do {
                let results = try JSONDecoder().decode(type.self, from: cachedData)
                completion(.success(results))
            }
            catch {
                completion(.failure(RaMServiceError.failedToDecodeData))
            }
            return
        }
        
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(RaMServiceError.failedToCreateRequest))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? RaMServiceError.failedToGetData))
                return
            }
            
            //Decode response
            do {
                let results = try JSONDecoder().decode(type.self, from: data)
                self?.cacheManager.cacheResponse(for: request.endpoint, url: request.url, data: data)
                completion(.success(results))
            }
            catch {
                completion(.failure(RaMServiceError.failedToDecodeData))
            }
        }
        task.resume()
    }
    
    //MARK: - Private
    
    /// GET Request from RaM Request
    /// - Parameter ramRequest: base request
    /// - Returns: request with GET http method
    private func request(from ramRequest: RaMRequest) -> URLRequest? {
        guard let url = ramRequest.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = ramRequest.httpMethod
        
        return request
    }
}
