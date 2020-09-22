//
//  IDMPAlterHelper.m
//  IDMPCMCCDemo
//
//  Created by wj on 2018/9/5.
//  Copyright © 2018年 alfredking－cmcc. All rights reserved.
//

#import "IDMPAlterHelper.h"
#import <UIKit/UIKit.h>

@implementation IDMPAlterHelper

+ (void)alertWithMessage:(id)message superVC:(UIViewController *)superVC {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *msgStr = nil;
        if ([message isKindOfClass:[NSDictionary class]]) {
            msgStr = [self dictionaryToJson:message];
        } else if ([message isKindOfClass:[NSString class]]) {
            msgStr = message;
        }
        NSLog(@"message is: %@",message);
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"执行结果" message:msgStr preferredStyle:UIAlertControllerStyleAlert];
        [superVC presentViewController:controller animated:YES completion:^{
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [controller dismissViewControllerAnimated:YES completion:^{}];
            });
        }];
    });
    
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
