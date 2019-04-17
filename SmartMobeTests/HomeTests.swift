//
//  HomeTests.swift
//  SmartMobe
//
//  Created by MacBook on 4/17/19.
//  Copyright © 2019 MacBook. All rights reserved.
//

import XCTest
import Alamofire


@testable import SmartMobe

class HomeTestCase: XCTestCase {
    
    let imageId = "788"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCheckLatestPhotosResponse(){
        
        let expectations = expectation(description: "The Response result match the expected results")
        
        
        let URL_TESTS = Constants.baseUrl+"/latest"
        
        Alamofire.request(URL_TESTS).responseJSON(completionHandler: {
            (response) in
            
            switch response.result {
            case .success(let result):
                
                print(response.result)
                
                let jsonData1 = result as! NSDictionary
                let img = jsonData1.value(forKey: "images") as! NSArray
                let id = img.value(forKey: "id")
                let url = img.value(forKey: "url")
                
                XCTAssertNotNil(result)
                XCTAssertNotNil(img)
                XCTAssertNotNil(id)
                XCTAssertNotNil(url)
                expectations.fulfill()
                
            case .failure(let error):
                
                XCTFail("Server response failed : \(error.localizedDescription)")
                expectations.fulfill()
            }
        })
        
        waitForExpectations(timeout: 30, handler: { (error) in
            if let error = error {
                print("Failed : \(error.localizedDescription)")
            }
        })
    }
}

