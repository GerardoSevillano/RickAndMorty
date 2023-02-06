//
//  RaMImageLoaderManager.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 31/01/2023.
//

import Foundation

/// Image loader abstraction
protocol ImageLoader {
    func downloadImage(_ imageURL: URL, completion: @escaping (Result<Data,Error>) -> Void)
}

/// Image loader used in RaM
final class RaMImageLoaderManager: ImageLoader {
    
    private var imageDataCache = NSCache<NSString, NSData>()
    
    private let session: URLSession
    
    // MARK: - Init
    
    init(urlSession: URLSession = .shared) {
        session = urlSession
    }
    
    //MARK: - Public
    
    /// Get image from url
    /// - Parameters:
    ///   - imageURL: URL for desired image
    ///   - completion: Callback
    public func downloadImage(_ imageURL: URL, completion: @escaping (Result<Data,Error>) -> Void) {
        
        let key = imageURL.absoluteString as NSString
        
        //Check if url is cached
        if let data = imageDataCache.object(forKey: key) {
            completion(.success(data as Data))
            return
        }
        
        let request = URLRequest(url: imageURL)
        let task = session.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
}
