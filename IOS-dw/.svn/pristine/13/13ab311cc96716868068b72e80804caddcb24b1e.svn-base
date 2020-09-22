//
//  IDMPTempSmsModeTests.m
//  IDMPCMCC
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IDMPTempSmsMode.h"
@interface IDMPTempSmsModeTests : XCTestCase
@property (nonatomic, strong) IDMPTempSmsMode *mode;
@end

@implementation IDMPTempSmsModeTests

- (void)setUp {
    _mode = [[IDMPTempSmsMode alloc] init];
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)testgetSmsCodeWithUserName {
    XCTestExpectation *expectation = [self expectationWithDescription:@"long method"];
    NSString *userName = nil;
    NSString *busiType = @"1";
    [_mode getSmsCodeWithUserName:userName busiType:busiType successBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        [expectation fulfill];
        XCTAssertNotNil(paraments);
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
- (void)testgetSmsCodeWithUserName_1 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"long method"];
    NSString *userName = @"15868178826";
    NSString *busiType = @"1";
    [_mode getSmsCodeWithUserName:userName busiType:busiType successBlock:^(NSDictionary *paraments) {
       
    } failBlock:^(NSDictionary *paraments) {
        [expectation fulfill];
        XCTAssertNotNil(paraments);
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
- (void)testgetSmsCodeWithUserName_2 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"long method"];
    NSString *userName = nil;
    NSString *busiType = @"2";
    [_mode getSmsCodeWithUserName:userName busiType:busiType successBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        [expectation fulfill];
        XCTAssertNotNil(paraments);
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
- (void)testgetSmsCodeWithUserName_3 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"long method"];
    NSString *userName = @"15868178826";
    NSString *busiType = @"2";
    [_mode getSmsCodeWithUserName:userName busiType:busiType successBlock:^(NSDictionary *paraments) {
        [expectation fulfill];
        XCTAssertNotNil(paraments);
    } failBlock:^(NSDictionary *paraments) {
        
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
- (void)testgetSmsCodeWithUserName_4 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"long method"];
    NSString *userName = @"wqeqiuweyiqwyr";
    NSString *busiType ;
    [_mode getSmsCodeWithUserName:userName busiType:busiType successBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        [expectation fulfill];
        XCTAssertNotNil(paraments);
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
- (void)testgetTMKSWithUserName {
    NSString *userName = nil;
    NSString *messageCode;
    [_mode getTMKSWithUserName:userName messageCode:messageCode successBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
- (void)testgetTMKSWithUserName_1 {
    NSString *userName = @"aqwewewrewsdsadqwasa";
    NSString *messageCode;
    [_mode getTMKSWithUserName:userName messageCode:messageCode successBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
- (void)testgetTMKSWithUserName_2 {
    NSString *userName = @"15868178826";
    NSString *messageCode;
    [_mode getTMKSWithUserName:userName messageCode:messageCode successBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
- (void)testgetTMKSWithUserName_3 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"long method"];
    NSString *userName = @"15868178826";
    NSString *messageCode = @"872834";
    [_mode getTMKSWithUserName:userName messageCode:messageCode successBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        [expectation fulfill];
        XCTAssertNotNil(paraments);
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
- (void)testgetTMKSWithUserName_4 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"long method"];
    NSString *userName = @"15868178826";
    NSString *messageCode = @"bsggdadskadjk";
    [_mode getTMKSWithUserName:userName messageCode:messageCode successBlock:^(NSDictionary *paraments) {
        
    } failBlock:^(NSDictionary *paraments) {
        [expectation fulfill];
        XCTAssertNotNil(paraments);
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
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
