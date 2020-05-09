//
//  NetworkClientTest.swift
//  NetworkClientTest
//
//  Created by Thet Htun on 5/9/20.
//  Copyright © 2020 padc. All rights reserved.
//

import XCTest
@testable import movie_core_data

class NetworkClientTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_movie_search_success() throws {
        let data = try Data.fromJSON(fileName: "search_movie_result")
        XCTAssertNotNil(data)
        
        let response = HTTPURLResponse(url: URL(string: "https://google.com/")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        
        let mockSession = MockURLSession(data: data, response: response, error: nil)
        let client = NetworkClient(mockSession)
        client.searchMoviesByName(movieName: "game") { (data) in
            XCTAssertEqual(data.count, 20)
        }
        
    }
    
    func test_movie_search_failure() throws {
        let response = HTTPURLResponse(url: URL(string: "https://google.com/")!,
                                       statusCode: 403,
                                       httpVersion: nil,
                                       headerFields: nil)
        let error = NSError(domain: "test_movie_search_failure", code: 403, userInfo: nil)
        let mockSession = MockURLSession(data: nil, response: response, error: error)
        let client = NetworkClient(mockSession)
        client.searchMoviesByName(movieName: "game") { (data) in
            XCTAssertEqual(data.count, 0)
        }
        
    }
    
    func test_movie_search_no_mock_success() {
        
        let session = URLSession.shared
        let client = NetworkClient(session)
        
        let searchMovieExpectation = expectation(description: "search movies")
        
        client.searchMoviesByName(movieName: "How to train your dragon") { (data) in
            
            XCTAssertEqual(data.count, 9)
            searchMovieExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class MockURLSession: URLSession {
    
    private let dataTaskMock: MockSessionDataTask
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.dataTaskMock = MockSessionDataTask()
        self.dataTaskMock.taskResponse = (data, response, error)
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.dataTaskMock.completionHandler = completionHandler
        return dataTaskMock
    }
}

class MockSessionDataTask: URLSessionDataTask {
    var completionHandler : ((Data?, URLResponse?, Error?) -> Void)?
    var taskResponse: (Data?, URLResponse?, Error?)?
    
    override func resume() {
        completionHandler?(taskResponse?.0, taskResponse?.1, taskResponse?.2)
    }
}
