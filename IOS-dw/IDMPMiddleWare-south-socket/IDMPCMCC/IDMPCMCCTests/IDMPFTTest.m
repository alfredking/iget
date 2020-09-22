////
////  IDMPFTTest.m
////  IDMPCMCCTests
////
////  Created by wj on 2017/8/30.
////  Copyright © 2017年 zwk. All rights reserved.
////
//
//#import <XCTest/XCTest.h>
//#import "IDMPFormatTransform.h"
//
//@interface IDMPFTTest : XCTestCase
//
//@end
//
//@implementation IDMPFTTest
//
//- (void)setUp {
//    [super setUp];
//    // Put setup code here. This method is called before the invocation of each test method in the class.
//}
//
//- (void)tearDown {
//    // Put teardown code here. This method is called after the invocation of each test method in the class.
//    [super tearDown];
//}
//
//- (void)testCheckIsip0 {
//    BOOL isip = [IDMPFormatTransform checkIsIp:@"192.168.2.3"];
//    XCTAssertTrue(isip);
//}
//
//- (void)testCheckIsip1 {
//    BOOL isip = [IDMPFormatTransform checkIsIp:@"www.baidu.com"];
//    XCTAssertFalse(isip);
//}
//
//
//- (void)testStringisNull0 {
//    BOOL isip = [IDMPFormatTransform checkNSStringisNULL:@"213"];
//    XCTAssertFalse(isip);
//}
//
//- (void)testStringisNull1 {
//    BOOL isip = [IDMPFormatTransform checkNSStringisNULL:nil];
//    XCTAssertTrue(isip);
//}
//
//- (void)testStringisNull2 {
//    BOOL isip = [IDMPFormatTransform checkNSStringisNULL:@""];
//    XCTAssertTrue(isip);
//}
//
//- (void)testStringisNull3 {
//    BOOL isip = [IDMPFormatTransform checkNSStringisNULL:@"(null)"];
//    XCTAssertTrue(isip);
//}
//
//- (void)testStringisNull4 {
//    BOOL isip = [IDMPFormatTransform checkNSStringisNULL:@"<null>"];
//    XCTAssertTrue(isip);
//}
//
//- (void)testStringisNull5 {
//    BOOL isip = [IDMPFormatTransform checkNSStringisNULL:NULL];
//    XCTAssertTrue(isip);
//}
//- (void)testHexToStr {
//    unsigned char *str = [IDMPFormatTransform hexStringToChar:@"3132336466393233343433323473646673"];
//    int len = strlen(str);
//    NSString *result = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];;
//    XCTAssertTrue([result isEqualToString:@"123df92344324sdfs"]);
//}
//
//- (void)testHexToNSData {
//    NSData *data = [IDMPFormatTransform hexStringToNSData:@"3132336466393233343433323473646673"];
//    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    XCTAssertTrue([result isEqualToString:@"123df92344324sdfs"]);
//}
//
//- (void)testCharToNSHex {
//    unsigned char *str = [@"123df92344324sdfs" UTF8String];
//    int len = strlen(str);
//    NSString *hexStr = [IDMPFormatTransform charToNSHex:str length:len];
//    XCTAssertTrue([hexStr isEqualToString:@"3132336466393233343433323473646673"]);
//}
//
//- (void)testHexStrToByte {
//    unsigned char *hexChar = [@"3132336466393233343433323473646673" UTF8String];
//    int hexlen = strlen(hexChar);
//    unsigned char *hexByte = HexStrToByte(hexChar, hexlen);
//    NSString *result = [NSString stringWithCString:hexByte encoding:NSUTF8StringEncoding];
//    XCTAssertTrue([result isEqualToString:@"123df92344324sdfs"]);
//}



//@end

