//
//  IDMPHttpRequestTests.m
//  IDMPCMCC
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IDMPHttpRequest.h"
@interface IDMPHttpRequestTests : XCTestCase
@property (nonatomic, strong) IDMPHttpRequest *req;
@end

@implementation IDMPHttpRequestTests

- (void)setUp {
    _req = [[IDMPHttpRequest alloc] init];
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)testgetAsynWithHeads {
    NSDictionary *heads;
    NSString *urlString;
    float aTime;
    
     XCTAssertNoThrow([_req getAsynWithHeads:heads url:urlString timeOut:aTime successBlock:^{
        
     } failBlock:^{
         
     }]);
}
- (void)testgetWapAsynWithHeads {
    NSDictionary *heads;
    NSString *urlString;
    float aTime;
    XCTAssertNoThrow([_req getWapAsynWithHeads:heads url:urlString timeOut:aTime successBlock:^{
        
    } failBlock:^{
        
    }]);
}
- (void)testURLSession {
    XCTAssert([_req respondsToSelector:@selector(URLSession:didReceiveChallenge:completionHandler:)]);
}
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _req = nil;
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
