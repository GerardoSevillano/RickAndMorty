//
//  RaMSearchViewViewModelTests.swift
//  RickAndMortyTests
//
//  Created by Gerardo Sevillano on 04/02/2023.
//

import XCTest
@testable import RickAndMorty

final class RaMSearchViewViewModelTests: XCTestCase {

    var viewModel: RaMSearchViewViewModel?
    
    override func setUpWithError() throws {
        
        viewModel = makeSUT()
    }

    func testAddQueryParams() {
        
        //Given
        guard let viewModel = viewModel else {
            XCTFail("ViewModel shouldn't be nil")
            return
        }
        
        var queryParams = queryParams
        queryParams.forEach { queryItem in
            viewModel.addQueryParam(param: queryItem)
            XCTAssertTrue(viewModel.queryParameters.contains(queryItem))
        }
        
        //Add two queries for the same key only the last one should remain
        
        queryParams = [URLQueryItem(name: "name", value: "Rick"), URLQueryItem(name: "name", value: "Morty")]
        
        //When
        queryParams.forEach { queryItem in
            viewModel.addQueryParam(param: queryItem)
        }
        
        //Then
        XCTAssertTrue(viewModel.queryParameters.contains(queryParams.last!))
        XCTAssertTrue(!viewModel.queryParameters.contains(queryParams.first!))
    }
    
    
    func testClearQueryParams() {
        //Given
        guard let viewModel = viewModel else {
            XCTFail("ViewModel shouldn't be nil")
            return
        }
        
        queryParams.forEach { queryItem in
            viewModel.addQueryParam(param: queryItem)
        }
        
        //When
        viewModel.clearQueryParams()
        
        //Then
        XCTAssertTrue(viewModel.queryParameters.isEmpty)
        
    }

    private func makeSUT() -> RaMSearchViewViewModel {
        let config = RaMSearchViewController.Config(type: .character)
        let ramSearchViewModel = RaMSearchViewViewModel(config: config)
        return ramSearchViewModel
    }

}
