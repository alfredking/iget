//
//  testlibTests.m
//  testlibTests
//
//  Created by alfredking－cmcc on 14-10-16.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "IDMPAuthLoginViewController.h"
#import "IDMPToken.h"

//生产环境
#define APPID @"00100218"
#define APPKEY @"72ECDCA973BA51C7"

//联调环境
//#define APPID @"10000020"
//#define APPKEY @"ED07CA9256280692"


/**
 *	开发
 */
//#define APPID @"10000067"
//#define APPKEY @"D706FC6D3DA745E8"

@interface getAccessTokenByConditionTest : XCTestCase

@end

@implementation getAccessTokenByConditionTest

- (void)setUp {
    [super setUp];
    NSString __block *resultCode = @"";
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expectations"];
    [[IDMPAutoLoginViewController alloc] initWithAppid:APPID Appkey:APPKEY TimeoutInterval:18.6 finishBlock:^(NSDictionary *paraments) {
        NSLog(@"成功:%@",paraments);
        resultCode = [paraments objectForKey:@"resultCode"];   //获取resultCode
        [expectation fulfill];
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"失败:%@",paraments);
        resultCode = [paraments objectForKey:@"resultCode"];   //获取resultCode
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:50.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    XCTAssert([resultCode isEqualToString:@"103000"]);
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
//正常用例
//手机号码登录
- (void)test01_PhoneNum{
    NSString __block *resultCode = @"";   //声明resultCode
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expectations"];  //信号量,当等待运行完成or等待时间50秒，才会执行其他操作
    IDMPAutoLoginViewController *controller = [[IDMPAutoLoginViewController alloc] init];
    [controller getAccessTokenByConditionWithUserName:@"18867101277" Content:@"hong123" andLoginType:1 finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *tokenStr = [paraments objectForKey:@"token"];  //获取token值
            [IDMPToken checkToken:tokenStr andAppid:@"100000"];
            resultCode = [paraments objectForKey:@"resultCode"];   //获取resultCode
            [expectation fulfill];
        });
    } failBlock:^(NSDictionary *paraments) {    //失败回调
        NSLog(@"fail");
        resultCode = [paraments objectForKey:@"resultCode"];
        NSLog(@"%@",paraments);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:50.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    XCTAssert([resultCode isEqualToString:@"102000"]);  //断言
}
//邮箱账号登录
- (void)test02_Email{
    NSString __block *resultCode = @"";
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expectations"];
    IDMPAutoLoginViewController *controller = [[IDMPAutoLoginViewController alloc] init];
    [controller getAccessTokenByConditionWithUserName:@"xidianzzhong@163.com" Content:@"hong123" andLoginType:1 finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *tokenStr = [paraments objectForKey:@"token"];
            [IDMPToken checkToken:tokenStr andAppid:@"100000"];
            resultCode = [paraments objectForKey:@"resultCode"];
            [expectation fulfill];
        });
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail");
        resultCode = [paraments objectForKey:@"resultCode"];
        NSLog(@"%@",paraments);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:50.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    XCTAssert([resultCode isEqualToString:@"102000"]);
}
//和id登录
- (void)test03_AndId{
    NSString __block *resultCode = @"";
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expectations"];
    IDMPAutoLoginViewController *controller = [[IDMPAutoLoginViewController alloc] init];
    [controller getAccessTokenByConditionWithUserName:@"420240218" Content:@"hong123" andLoginType:1 finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *tokenStr = [paraments objectForKey:@"token"];
            [IDMPToken checkToken:tokenStr andAppid:@"100000"];
            resultCode = [paraments objectForKey:@"resultCode"];
            [expectation fulfill];
        });
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail");
        resultCode = [paraments objectForKey:@"resultCode"];
        NSLog(@"%@",paraments);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:50.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    XCTAssert([resultCode isEqualToString:@"102000"]);
}

//异常用例
//用户名为空
- (void)test04_UserIsEmpty{
    NSString __block *resultCode = @"";
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expectations"];
    IDMPAutoLoginViewController *controller = [[IDMPAutoLoginViewController alloc] init];
    [controller getAccessTokenByConditionWithUserName:@"" Content:@"hong123" andLoginType:1 finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *tokenStr = [paraments objectForKey:@"token"];
            NSLog(@"token =====> %@", tokenStr);
            resultCode = [paraments objectForKey:@"resultCode"];
            [expectation fulfill];
        });
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail");
        resultCode = [paraments objectForKey:@"resultCode"];
        NSLog(@"%@",paraments);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:50.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    XCTAssert([resultCode isEqualToString:@"102303"]);
}
//用户名为null
- (void)test05_UserIsNull{
    NSString __block *resultCode = @"";
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expectations"];
    IDMPAutoLoginViewController *controller = [[IDMPAutoLoginViewController alloc] init];
    [controller getAccessTokenByConditionWithUserName:nil Content:@"hong123" andLoginType:1 finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *tokenStr = [paraments objectForKey:@"token"];
            NSLog(@"token =====> %@", tokenStr);
            resultCode = [paraments objectForKey:@"resultCode"];
            [expectation fulfill];
        });
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail");
        resultCode = [paraments objectForKey:@"resultCode"];
        NSLog(@"%@",paraments);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:50.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    XCTAssert([resultCode isEqualToString:@"102303"]);
}
//手机号码位数错误
- (void)test06_phoneIsError{
    NSString __block *resultCode = @"";
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expectations"];
    IDMPAutoLoginViewController *controller = [[IDMPAutoLoginViewController alloc] init];
    [controller getAccessTokenByConditionWithUserName:@"1886710127" Content:@"hong123" andLoginType:1 finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *tokenStr = [paraments objectForKey:@"token"];
            NSLog(@"token =====> %@", tokenStr);
            resultCode = [paraments objectForKey:@"resultCode"];
            [expectation fulfill];
        });
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail");
        resultCode = [paraments objectForKey:@"resultCode"];
        NSLog(@"%@",paraments);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:50.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    XCTAssert([resultCode isEqualToString:@"103103"]);
}
//手机号码含非数字
- (void)test07_phoneConLetter{
    NSString __block *resultCode = @"";
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expectations"];
    IDMPAutoLoginViewController *controller = [[IDMPAutoLoginViewController alloc] init];
    [controller getAccessTokenByConditionWithUserName:@"188671012ab" Content:@"hong123" andLoginType:1 finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *tokenStr = [paraments objectForKey:@"token"];
            NSLog(@"token =====> %@", tokenStr);
            resultCode = [paraments objectForKey:@"resultCode"];
            [expectation fulfill];
        });
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail");
        resultCode = [paraments objectForKey:@"resultCode"];
        NSLog(@"%@",paraments);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:50.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    XCTAssert([resultCode isEqualToString:@"103106"]);
}
//手机号码含空格
- (void)test08_phoneConBlank{
    NSString __block *resultCode = @"";
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expectations"];
    IDMPAutoLoginViewController *controller = [[IDMPAutoLoginViewController alloc] init];
    [controller getAccessTokenByConditionWithUserName:@" 18867101277 " Content:@"hong123" andLoginType:1 finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *tokenStr = [paraments objectForKey:@"token"];
            NSLog(@"token =====> %@", tokenStr);
            resultCode = [paraments objectForKey:@"resultCode"];
            [expectation fulfill];
        });
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail");
        resultCode = [paraments objectForKey:@"resultCode"];
        NSLog(@"%@",paraments);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:50.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    XCTAssert([resultCode isEqualToString:@"103106"]);
}
//密码为空
- (void)test09_PSWIsEmpty{
    NSString __block *resultCode = @"";
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expectations"];
    IDMPAutoLoginViewController *controller = [[IDMPAutoLoginViewController alloc] init];
    [controller getAccessTokenByConditionWithUserName:@"18867101277" Content:@"" andLoginType:1 finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *tokenStr = [paraments objectForKey:@"token"];
            NSLog(@"token =====> %@", tokenStr);
            resultCode = [paraments objectForKey:@"resultCode"];
            [expectation fulfill];
        });
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail");
        resultCode = [paraments objectForKey:@"resultCode"];
        NSLog(@"%@",paraments);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:50.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    XCTAssert([resultCode isEqualToString:@"102304"]);
}

//密码为null
- (void)test10_PSWIsNull{
    NSString __block *resultCode = @"";
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expectations"];
    IDMPAutoLoginViewController *controller = [[IDMPAutoLoginViewController alloc] init];
    [controller getAccessTokenByConditionWithUserName:@"18867101277" Content:NULL andLoginType:1 finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *tokenStr = [paraments objectForKey:@"token"];
            NSLog(@"token =====> %@", tokenStr);
            resultCode = [paraments objectForKey:@"resultCode"];
            [expectation fulfill];
        });
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail");
        resultCode = [paraments objectForKey:@"resultCode"];
        NSLog(@"%@",paraments);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:50.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    XCTAssert([resultCode isEqualToString:@"102304"]);
}

//密码区分大写/小写
- (void)test11_PSWIsError{
    NSString __block *resultCode = @"";
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expectations"];
    IDMPAutoLoginViewController *controller = [[IDMPAutoLoginViewController alloc] init];
    [controller getAccessTokenByConditionWithUserName:@"18867101277" Content:@"HONG123" andLoginType:1 finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *tokenStr = [paraments objectForKey:@"token"];
            NSLog(@"token =====> %@", tokenStr);
            resultCode = [paraments objectForKey:@"resultCode"];
            [expectation fulfill];
        });
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail");
        resultCode = [paraments objectForKey:@"resultCode"];
        NSLog(@"%@",paraments);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:50.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    XCTAssert([resultCode isEqualToString:@"103105"]);
}

//密码含空格
- (void)test12_PSWConBlank{
    NSString __block *resultCode = @"";
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expectations"];
    IDMPAutoLoginViewController *controller = [[IDMPAutoLoginViewController alloc] init];
    [controller getAccessTokenByConditionWithUserName:@"18867101277" Content:@"hong 123" andLoginType:1 finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *tokenStr = [paraments objectForKey:@"token"];
            NSLog(@"token =====> %@", tokenStr);
            resultCode = [paraments objectForKey:@"resultCode"];
            [expectation fulfill];
        });
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail");
        resultCode = [paraments objectForKey:@"resultCode"];
        NSLog(@"%@",paraments);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:50.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    XCTAssert([resultCode isEqualToString:@"103105"]);
}
//密码含汉字
- (void)test13_PSWConChin{
    NSString __block *resultCode = @"";
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Expectations"];
    IDMPAutoLoginViewController *controller = [[IDMPAutoLoginViewController alloc] init];
    [controller getAccessTokenByConditionWithUserName:@"18867101277" Content:@"哈哈大网和通行证测试你好哈哈哈" andLoginType:1 finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *tokenStr = [paraments objectForKey:@"token"];
            NSLog(@"token =====> %@", tokenStr);
            resultCode = [paraments objectForKey:@"resultCode"];
            [expectation fulfill];
        });
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail");
        resultCode = [paraments objectForKey:@"resultCode"];
        NSLog(@"%@",paraments);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:50.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    XCTAssert([resultCode isEqualToString:@"103105"]);
}

/*- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}*/

@end
