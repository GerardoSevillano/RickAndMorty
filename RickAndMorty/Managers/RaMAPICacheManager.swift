//
//  RaMAPICacheManager.swift
//  RickAndMorty
//
//  Created by Gerardo Sevillano on 01/02/2023.
//

import Foundation

protocol CacheManager {
    func cachedResponse(for endpoint: RaMEndpoint, url: URL?) -> Data?
    func cacheResponse(for endpoint: RaMEndpoint, url: URL?, data: Data)
}

/// Manage in memory cache for APIs
final class RaMAPICacheManager: CacheManager {
    
    private var cacheDictionary: [RaMEndpoint: NSCache<NSString, NSData>] = [:]
    private var cache = NSCache<NSString, NSData>()
    
    // MARK: - Init

    init() {
        setupCache()
    }
    
    // MARK: - Public
    
    public func cachedResponse(for endpoint: RaMEndpoint, url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return nil
        }
        
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }
    
    public func cacheResponse(for endpoint: RaMEndpoint, url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return
        }
        
        let key = url.absoluteString as NSString
        let data = data as NSData
        targetCache.setObject(data, forKey: key)
    }

    // MARK: - Private
    
    private func setupCache() {
        RaMEndpoint.allCases.forEach { endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        }
    }
}

