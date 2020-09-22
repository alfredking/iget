//
//  IDMPKDFTests.m
//  IDMPCMCC
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IDMPKDF.h"
@interface IDMPKDFTests : XCTestCase

@end

@implementation IDMPKDFTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)testkdf_pw {
    unsigned char key = key;
    char pscene;
    char pnonce;
    char pconce;
    XCTAssert(kdf_pw(&key, &pscene, &pnonce, &pconce));
    
}
- (void)testkdf_sms {
    unsigned char key;
    char pscene;
    char pnonce;
    XCTAssert(kdf_sms(&key, &pscene, &pnonce));
}
- (void)testIDMPKDF {
    unsigned char ks = 1;
    NSString *data = @"data";
    XCTAssert(ks);
    XCTAssert(data);
    XCTAssert([IDMPKDF getNativeMac:&ks data:data]);
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
