//
//  IDMPUPModeTests.m
//  IDMPCMCC
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IDMPUPMode.h"
@interface IDMPUPModeTests : XCTestCase
@property (nonatomic, strong) IDMPUPMode *mode;
@end

@implementation IDMPUPModeTests

- (void)setUp {
    _mode = [[IDMPUPMode alloc] init];
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)testgetUPKSByUserName {
    NSString *username = @"15868178826";
    NSString *passwd = @"123qwe";
    XCTestExpectation *expectation = [self expectationWithDescription:@"long method"];
    [_mode getUPKSByUserName:username andPassWd:passwd successBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        [expectation fulfill];
        XCTAssertNotNil(paraments);
    }];
    [self waitForExpectationsWithTimeout:20 handler:nil];
}
- (void)testcheckUpdateKSIsValid {
    NSDictionary *responseHeaders = @{@"Connection" : @"keep-alive",
                                      @"Content-Length" : @"0",
                                      @"Date" : @"Tue, 23 Aug 2016 14:22:48 GMT",
                                      @"Keep-Alive" : @"timeout=30",
                                      @"Server" : @"nginx",
                                      @"WWW-Authenticate" : @"UP Nonce=\"Idky2FLx3sZCsv45QpTshT7fhshvNxm5\",BTID=\"NUM3Q0QwNjgwQTEzRDRCRDJE@http://211.136.10.131:8080/\",lifetime=\"5184000\",sqn=\"18624383\",expiretime=\"2016-10-22 22:19:20\",idmpclientupgradeflag=\"0\",authtype=\"UPAndPassport\",spassword=\"\",email=\"\",msisdn=\"15868178826\",passid=\"1734524855\"",
                                      @"mac" : @"dc1634039d0e290ee5ebf3dd35fcd7fabec5a1463d657c0e9154b4a2e5375149",
                                      @"resultCode" : @"103000"};
    NSString *userName = @"15868178826";
    NSString *clientNonce = @"a81067c85916fbc961ef0135b0aeb8d7";
    XCTAssertFalse([IDMPUPMode checkUpdateKSIsValid:responseHeaders userName:userName clientNonce:clientNonce]);
}
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _mode = nil;
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
