//
//  RaMRequestTest.swift
//  RickAndMortyTests
//
//  Created by Gerardo Sevillano on 04/02/2023.
//

import XCTest
@testable import RickAndMorty

final class RaMRequestTest: XCTestCase {
    
    func test_createRequest_expectingSuccess() {
        //Given
        let endpoint = RaMEndpoint.character
        let queryParam = queryParams
        let pathComponents = "1"
        
        //When
        let request = RaMRequest(endpoint: endpoint)
        let request2 = RaMRequest(endpoint: endpoint, queryParameters: queryParam)
        let request3 = RaMRequest(endpoint: endpoint, pathComponents: [pathComponents])


        //Then
        XCTAssertEqual(request.url?.absoluteString, urlStrings[0])
        XCTAssertEqual(request2.url?.absoluteString, urlStrings[1])
        XCTAssertEqual(request3.url?.absoluteString, urlStrings[2])
    }

    func test_createRequestFromWrongURL_expectingNil() {
        
        //Given
        let url = URL(string: "https://fake.com")
        guard let url = url else {
            XCTFail("Should provide valid URL string")
            return
        }
        
        //When
        let request = RaMRequest(url: url)
        
        //Then
        XCTAssertNil(request)
    }
}
