//
//  KeychainItemWrapperTests.m
//  IDMPCMCC
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KeychainItemWrapper.h"
@interface KeychainItemWrapperTests : XCTestCase

@end

@implementation KeychainItemWrapperTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)testinitWithIdentifier {
    NSString *identifier = @"id";
    NSString *accessGroup;
    XCTAssert([[KeychainItemWrapper alloc] initWithIdentifier:identifier accessGroup:accessGroup]);
}
- (void)testsetObject {
    id object;
    id key;
    KeychainItemWrapper *wapper = [[KeychainItemWrapper alloc] init];
    XCTAssertNoThrow([wapper setObject:object forKey:key]);
    
}
- (void)testobjectForKey {
    id key;
    KeychainItemWrapper *wapper = [[KeychainItemWrapper alloc] init];
    XCTAssertNoThrow([wapper objectForKey:key]);
}
- (void)testresetKeychainItem {
    KeychainItemWrapper *wapper = [[KeychainItemWrapper alloc] init];
    XCTAssertNoThrow([wapper resetKeychainItem]);
}
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
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
