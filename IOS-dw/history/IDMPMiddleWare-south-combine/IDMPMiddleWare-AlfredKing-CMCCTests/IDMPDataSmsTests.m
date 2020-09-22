//
//  IDMPDataSmsTests.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 alfredking－cmcc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IDMPDataSms.h"
@interface IDMPDataSmsTests : XCTestCase

@end

@implementation IDMPDataSmsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
- (void)testsharedInstance {
    
    NSMutableArray *singletons = [NSMutableArray array];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        IDMPDataSms *sms = [[IDMPDataSms alloc] init];
//        [singletons addObject:sms];
//    });
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        IDMPDataSms *sms = [[IDMPDataSms alloc] init];
//        [singletons addObject:sms];
//    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        IDMPDataSms *sms = [IDMPDataSms sharedInstance];
        [singletons addObject:sms];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        IDMPDataSms *sms = [IDMPDataSms sharedInstance];
        [singletons addObject:sms];
    });
    
    IDMPDataSms *dataSms = [IDMPDataSms sharedInstance];
    [singletons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XCTAssertEqual(dataSms, obj, @"不是单例类");
    }];
}
- (void)testsendSMS {
    NSString *bodyOfMessage;
    NSArray *recipients;
    NSDictionary *options;
    [[IDMPDataSms sharedInstance] sendSMS:bodyOfMessage recipientList:recipients option:options SuccessBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    } failBlock:^(NSDictionary *paraments) {
        XCTAssertNotNil(paraments);
    }];
}
//- (void)testmessageComposeViewController {
//    MFMessageComposeViewController *MFVC = [[MFMessageComposeViewController alloc] init];
//    MessageComposeResult result = MessageComposeResultSent;
//    XCTAssert([[IDMPDataSms sharedInstance] respondsToSelector:@selector(messageComposeViewController:didFinishWithResult:)]);
//    XCTAssertNoThrow([[IDMPDataSms sharedInstance] messageComposeViewController:MFVC didFinishWithResult:result]);
//    
//}
//- (void)testmessageComposeViewController_1 {
//    MFMessageComposeViewController *MFVC = [[MFMessageComposeViewController alloc] init];
//    MessageComposeResult result = MessageComposeResultCancelled;
//    XCTAssert([[IDMPDataSms sharedInstance] respondsToSelector:@selector(messageComposeViewController:didFinishWithResult:)]);
//    XCTAssertNoThrow([[IDMPDataSms sharedInstance] messageComposeViewController:MFVC didFinishWithResult:result]);
//}
//- (void)testmessageComposeViewController_2 {
//    MFMessageComposeViewController *MFVC = [[MFMessageComposeViewController alloc] init];
//    MessageComposeResult result = MessageComposeResultFailed;
//    XCTAssert([[IDMPDataSms sharedInstance] respondsToSelector:@selector(messageComposeViewController:didFinishWithResult:)]);
//    XCTAssertNoThrow([[IDMPDataSms sharedInstance] messageComposeViewController:MFVC didFinishWithResult:result]);
//}
//- (void)testcheckDataSmsKSIsValid {
//    
//    XCTestExpectation *expectation = [self expectationWithDescription:@"Expectations"];
//    NSDictionary *dict = @{@"Connection" : @"keep-alive",
//                           @"Content-Length" : @"0",
//                           @"Date" : @"Tue, 23 Aug 2016 01:43:57 GMT",
//                           @"Query-Result" : @"CK esign=\"null\",isSipApp=\"1\",eappid=\"bjsG4G2BWAeJatlLS8Zwzw==\",sourceId=\"001002\",epackage=\"null\"",
//                           @"Server" : @"nginx",
//                           @"resultCode" : @"103000"};
//}
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
