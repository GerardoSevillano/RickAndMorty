//
//  File.swift
//  RickAndMortyTests
//
//  Created by Gerardo Sevillano on 03/02/2023.
//

import Foundation
import XCTest
@testable import RickAndMorty

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Received unexpected request with no handler set")
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
    }
}

class DummyService: APIService {
    
    func executeRequest<T>(_ request: RaMRequest, expecting type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
    }
}

final class DummyAPICacheManager: CacheManager {
    func cachedResponse(for endpoint: RaMEndpoint, url: URL?) -> Data? {
        return nil
    }
    
    func cacheResponse(for endpoint: RaMEndpoint, url: URL?, data: Data) {
    }
}
