//
//  PersonalWeiboViewCell.m
//  Fenvo
//
//  Created by Caesar on 15/6/5.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "PersonalWeiboViewCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "AppDelegate.h"
#import "KVNProgress.h"
#import "UIImage+FontAwesome.h"

#define WBAPIURL_DELETE @"https://api.weibo.com/2/statuses/destroy.json"

@interface PersonalWeiboViewCell() {
    UIButton *_deleteWeiboBtn;
}
@end

@implementation PersonalWeiboViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _deleteWeiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteWeiboBtn.tag = 999;
        _deleteWeiboBtn.titleLabel.font = WBStatusButtonFont;
        [_deleteWeiboBtn setImage:[UIImage imageWithIcon:@"fa-trash-o" backgroundColor:[UIColor clearColor] iconColor:RGBACOLOR(250, 143, 5, 1) andSize:CGSizeMake(20.0, 20.0)] forState:UIControlStateNormal];
        [_deleteWeiboBtn setImage:[UIImage imageWithIcon:@"fa-trash-o" backgroundColor:[UIColor clearColor] iconColor:RGBACOLOR(250, 100, 20, 1) andSize:CGSizeMake(20.0, 20.0)] forState:UIControlStateHighlighted];
        [self.containView addSubview:_deleteWeiboBtn];
        [_deleteWeiboBtn addTarget:self action:@selector(deleteWeibo) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setWeiboMsg:(WeiboMsg *)weiboMsg{
    [super setWeiboMsg:weiboMsg];
    [self.avatar removeFromSuperview];
    CGRect frame = self.userName.frame;
    frame.origin.x -= 45;
    self.userName.frame = frame;
    frame = self.mbType.frame;
    frame.origin.x -= 45;
    self.mbType.frame = frame;
    frame = self.createTime.frame;
    frame.origin.x -= 45;
    self.createTime.frame = frame;
    frame = self.source.frame;
    frame.origin.x -= 45;
    self.source.frame = frame;
    _deleteWeiboBtn.frame = CGRectMake(self.containView.frame.size.width - 35, 10, 30, 20);
}

- (void)deleteWeibo {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        //http请求头应该添加text/plain。接受类型内容无text/plain
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        NSString *deleteUrl = WBAPIURL_DELETE;
        NSDictionary *dict0 = [[NSDictionary alloc]init];
        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        NSNumber *ids = [NSNumber numberWithLongLong:self.weiboMsg.ids];
        dict0 = @{@"access_token":delegate.wbtoken,@"id":ids};
        [manager POST:deleteUrl
          parameters:dict0
             success:^(AFHTTPRequestOperation *operation, id responserObject){
                 [KVNProgress showSuccess];
                 [[NSNotificationCenter defaultCenter]postNotificationName:WEIBOEVENT_DELETE object:[NSString stringWithFormat:@"%lld",self.weiboMsg.ids]];
             }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 [KVNProgress showError];
             }];
        
        
    });

}
@end
