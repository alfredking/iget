//
//  IDMPNetWorkDetectViewController.m
//  IDMPCMCCDemo
//
//  Created by wj on 2018/5/14.
//  Copyright © 2018年 alfredking－cmcc. All rights reserved.
//

#import "IDMPNetWorkDetectViewController.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
@interface IDMPNetWorkDetectViewController ()
@property (weak, nonatomic) IBOutlet UILabel *netLbl;
@property (weak, nonatomic) IBOutlet UILabel *simLbl;

@end

@implementation IDMPNetWorkDetectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.netLbl.text = [NSString stringWithFormat:@"%@",[self networkType]];
    self.netLbl.text = [self serviceCompany];
    self.simLbl.text = [self getChinaOperatorName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)networkType
{
    Class cls = NSClassFromString(@"UIStatusBarServer");
    SEL selector = NSSelectorFromString(@"getStatusBarData");
    NSMethodSignature *signature = [cls methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = cls;
    invocation.selector = selector;
    [invocation invoke];
    struct {
        bool x1[35];
        BOOL x2[64];
        BOOL x3[64];
        int x4;
        int x5;
        char x6[100];
        BOOL x7[100];
        BOOL x8[2][100];
        BOOL x9[1024];
        unsigned int x10;
        int x11;
        int x12;
        unsigned int x13;
        int x14;
        unsigned int x15;
        BOOL x16[150];
        int x17;
        int x18;
        unsigned int x19 : 1;
        unsigned int x20 : 1;
        unsigned int x21 : 1;
        BOOL x22[256];
        unsigned int x23 : 1;
        unsigned int x24 : 1;
        unsigned int x25 : 1;
        unsigned int x26 : 1;
        unsigned int x27 : 1;
        unsigned int x28;
        unsigned int x29 : 1;
        unsigned int x30 : 1;
        unsigned int x31 : 1;
        BOOL x32[256];
        BOOL x33[256];
        BOOL x34[100];
        unsigned int x35 : 1;
        unsigned int x36 : 1;
        unsigned int x37 : 1;
        double x38;
    } * data;
    [invocation getReturnValue:&data];
    NSString *networkType = [NSString stringWithCString:data->x6 encoding:NSUTF8StringEncoding];
    return networkType;
}

-(NSString *)serviceCompany{
    NSArray *infoArray = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    for (id info in infoArray)
    {
        if ([info isKindOfClass:NSClassFromString(@"UIStatusBarServiceItemView")])
        {
            NSString *serviceString = [info valueForKeyPath:@"serviceString"];
            NSLog(@"公司为：%@",serviceString);
            return serviceString;
        }
    }
    return @"";
}

- (NSString *)getOperatorNetworkCode {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *networkCode = [carrier mobileNetworkCode];
    NSLog(@"current network code is %@", networkCode);
    return networkCode;
}

- (NSString *)getOperatorCountryCode {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *countryCode = [carrier mobileCountryCode];
    NSLog(@"current country code is %@", countryCode);
    return countryCode;
}


- (NSString *)getChinaOperatorName {
    NSString *countryCode = [self getOperatorCountryCode];
    if ([countryCode isEqualToString:@"460"]) {
        NSString *code = [self getOperatorNetworkCode];
        if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"]) {
            return @"中国移动";
        }
        if ([code isEqualToString:@"01"] || [code isEqualToString:@"06"]) {
            return @"中国联通";
        }
        if ([code isEqualToString:@"03"] || [code isEqualToString:@"05"] || [code isEqualToString:@"11"]) {
            return @"中国电信";
        }
    }
    
    return @"unkown";
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
