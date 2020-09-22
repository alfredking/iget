//
//  UserInfoView.m
//  Fenvo
//
//  Created by Caesar on 15/6/17.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "UserInfoView.h"

@interface UserInfoView ()

@end

@implementation UserInfoView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)setUserInfo:(WeiboUserInfo *)userInfo {
    _user_description.text = userInfo.descriptions;
    _hometown.text = userInfo.location;
    _blogUrl.text = userInfo.blogUrl;
    _habits.text = @"无";
    _remark.text = userInfo.remark;
    _register_time.text = userInfo.created_at;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
