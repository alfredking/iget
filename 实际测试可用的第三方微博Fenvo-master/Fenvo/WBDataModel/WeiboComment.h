//
//  WeiboComment.h
//  Fenvo
//
//  Created by Caesar on 15/3/28.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboUserInfo.h"
#import "WeiboMsg.h"

@interface WeiboComment : NSObject
//created_at	string	评论创建时间
@property (nonatomic, copy)NSString *created_at;
//id	int64	评论的ID
@property (nonatomic, assign)NSUInteger ids;
//text	string	评论的内容
@property (nonatomic, copy)NSString *text;
//source	string	评论的来源
@property (nonatomic, copy)NSString *source;
//user	object	评论作者的用户信息字段 详细
@property (nonatomic, strong)WeiboUserInfo *user;
//mid	string	评论的MID
@property (nonatomic, copy)NSString *mid;
//idstr	string	字符串型的评论ID
@property (nonatomic, copy)NSString *idstr;
//status	object	评论的微博信息字段 详细
@property (nonatomic, strong)WeiboMsg *weiboMsg;
//reply_comment	object	评论来源评论，当本评论属于对另一评论的回复时返回此字段
@property (nonatomic, strong)WeiboComment *reply_comment;
@end

