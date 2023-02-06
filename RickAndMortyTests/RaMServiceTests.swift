//
//  RaMServiceTests.swift
//  RickAndMortyTests
//
//  Created by Gerardo Sevillano on 03/02/2023.
//

import XCTest
@testable import RickAndMorty

final class RaMServiceTests: XCTestCase {
    
    // URL session for mocking networking
    var urlSession: URLSession!
    
    override func setUpWithError() throws {
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
    }
    
    func testGetCharactersSuccesfully() throws {
        // Profile API. Injected with custom url session for mocking
        let service = makeSUT()
        
        // Mock data
        let character2 = character2
        
        let mockData = try JSONEncoder().encode(character2)
        
        // Return data in mock request handler
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        // Set expectation. Used to test async code.
        let expectation = XCTestExpectation(description: "Character returned succesfully")
        
        // Make mock network request to get character
        let request = characterRequest!
        service.executeRequest(request, expecting: RaMCharacter.self) { result in
            switch result {
            case .success(let model):
                XCTAssertEqual(model.name, "Morty Smith")
                XCTAssertEqual(model.species, "Human")
                XCTAssertNotEqual(model.image, "image")
                break
            case .failure(_):
                XCTFail("Test should not have failed because request is valid")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
        
    func testGetCharacters_Unsuccesfully() throws {
        // Profile API. Injected with custom url session for mocking
        let service = makeSUT()
        
        // Mock data
        let character2 = character2
        
        let mockData = try JSONEncoder().encode(MockError.mockError)

        
        // Return data in mock request handler
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        // Set expectation. Used to test async code.
        let expectation = XCTestExpectation(description: "Service returns error for not being able to decode data")
        
        // Make mock network request to get character
        let request = characterRequest!
        service.executeRequest(request, expecting: RaMCharacter.self) { result in
            switch result {
            case .success(_):
                XCTFail("Test should not have decoded data")
                break
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error as! RaMServiceError, RaMServiceError.failedToDecodeData)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    private func makeSUT() -> RaMService {
        let ramCacheManager = DummyAPICacheManager()
        let ramService = RaMService(urlSession: urlSession, cacheManager: ramCacheManager)
        return ramService
    }
    
}
