//
//  IDMPDeviceTests.m
//  IDMPCMCC
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IDMPDevice.h"
@interface IDMPDeviceTests : XCTestCase

@end

@implementation IDMPDeviceTests
//+(BOOL)checkChinaMobile;
//+(BOOL)simExist;
//+(NSString *)getDeviceID;
//+(NSString *)getAppVersion;
//+(NSString*)GetCurrntNet;
//+ (NSString *)ntnu_deviceDescription;
//+ (NTNUDeviceType)ntnu_deviceType;
//
///**
// *	获取运营商标识
// */
//+ (NSString *)getOperatorCode;
//
///**
// *  接口用于收集手机设备信息
// */
//+ (void)collectUserDeviceData;
//
///**
// *	读取设备信息
// */
//+ (NSString *)getLocalUserDeviceData;
//

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)testcheckChinaMobile {
    XCTAssertFalse([IDMPDevice checkChinaMobile]);
}
- (void)testsimExist {
    XCTAssertFalse([IDMPDevice simExist]);
}
- (void)testgetDeviceID {
    XCTAssertNotNil([IDMPDevice getDeviceID]);
}
- (void)testgetAppVersion {
    XCTAssertNotNil([IDMPDevice getAppVersion]);
}
- (void)testgetGetCurrntNet {
    XCTAssertNotNil([IDMPDevice GetCurrntNet]);
}
- (void)testntnu_deviceDescription {
    XCTAssertNotNil([IDMPDevice ntnu_deviceDescription]);
}
- (void)testntnu_deviceType {
    XCTAssertTrue([IDMPDevice ntnu_deviceType]);
}
- (void)testgetOperatorCode {
    XCTAssertNil([IDMPDevice getOperatorCode]);
}
- (void)testcollectUserDeviceData {
    XCTAssertNoThrow([IDMPDevice collectUserDeviceData]);
}
- (void)testgetLocalUserDeviceData {
    XCTAssertNotNil([IDMPDevice getLocalUserDeviceData]);
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
