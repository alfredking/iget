//
//  TestTimeProfilerViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2022/2/25.
//  Copyright © 2022 alfredking. All rights reserved.
//

#import "TestTimeProfilerViewController.h"
#import "GYHttpMock.h"
#import <AFNetworking.h>
@interface TestTimeProfilerViewController ()

@end

@implementation TestTimeProfilerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    mockRequest(@"GET", @"http://127.0.0.1:8082/user").andReturn(200).withBody(@"{\"key\":\"value\"}");
    
    [[AFHTTPSessionManager manager]GET:@"http://127.0.0.1:8082/user" parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"af progress is %lld",downloadProgress.completedUnitCount);

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"af success object is %@",responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"af failure error is %@",error);
    }];
    
//    mockRequest(@"POST", @"http://www.google.com").
//    isUpdatePartResponseBody(YES).
//    withBody(@"{\"name\":\"abc\"}".regex);
//    andReturn(200).withBody(@"{\"key\":\"value\"}");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
