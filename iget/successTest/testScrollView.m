//
//  testScrollView.m
//  iget
//
//  Created by alfredking－cmcc on 2021/7/2.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "testScrollView.h"
@interface testScrollView ()

@end

@implementation testScrollView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(20, 150, 300, 200)];
    scrollView.contentSize = CGSizeMake(600, 200);
    scrollView.backgroundColor = [UIColor greenColor];
    scrollView.scrollEnabled = YES;
    
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 0, 200);
    label.text = @"1. 免费通话时长领取后立即生效，有效期至xxxx.xx.xx，不可重复领取；2. 免费通话时长支持全网用户领取并使用；3. 免费通话时长使用优先级最高。若用户同时订购了套餐，优先使用免费通话时长；4. 免费通话时长仅支持国内，且不包含港澳台；5. 免费通话时长领取成功后，绑定的智能设备作为主叫拨打电话时，平台会随机分配一个固话号码作为主叫呼出，不支持回呼；6.用户不可利用该业务从事任何违反法律规定或者公序良俗之行为，包括但不限于危害电信网络安全和信息安全的行为及制作、复制、发布、传播任何法律、行政法规禁止的内容等。一经发现，平台将停止对该用户的所有服务。1. 免费通话时长领取后立即生效，有效期至xxxx.xx.xx，不可重复领取；2. 免费通话时长支持全网用户领取并使用；3. 免费通话时长使用优先级最高。若用户同时订购了套餐，优先使用免费通话时长；4. 免费通话时长仅支持国内，且不包含港澳台；5. 免费通话时长领取成功后，绑定的智能设备作为主叫拨打电话时，平台会随机分配一个固话号码作为主叫呼出，不支持回呼；6.用户不可利用该业务从事任何违反法律规定或者公序良俗之行为，包括但不限于危害电信网络安全和信息安全的行为及制作、复制、发布、传播任何法律、行政法规禁止的内容等。一经发现，平台将停止对该用户的所有服务。";
    label.font = [UIFont fontWithName:@"PingFang SC" size:15];
    label.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:128/255.0];
    label.numberOfLines = 0;
    [label sizeToFit];
    [scrollView addSubview:label];
    
    [self.view addSubview:scrollView];
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
