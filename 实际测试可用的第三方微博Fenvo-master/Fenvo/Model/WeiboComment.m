//
//  WeiboComment.m
//  Fenvo
//
//  Created by Caesar on 15/8/5.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboComment.h"
#import "WeiboComment.h"
#import "WeiboMsg.h"
#import "WeiboUserInfo.h"
#import "StringFormatTool.h"


@implementation WeiboComment

@dynamic created_at;
@dynamic ids;
@dynamic mid;
@dynamic source;
@dynamic text;
@dynamic idstr;
@dynamic reply_comment;
@dynamic weiboMsg;
@dynamic user;
//
@dynamic height;

+ (WeiboComment *)createByDictionary:(NSDictionary *)dic Option:(BOOL)isSave{
    
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    WeiboComment *comment = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([WeiboComment class]) inManagedObjectContext:managedObjectContext];
    
    if ([dic allKeys].count > 0) {
        
        comment.ids = [NSNumber numberWithLongLong:[dic[@"id"] longLongValue]];
        
        comment.mid = dic[@"mid"];
        
        comment.idstr = dic[@"idstr"];
        
        comment.text = dic[@"text"];
        
        comment.source = dic[@"source"];
        
        NSDictionary *user = dic[@"user"];
        comment.user = [WeiboUserInfo createdByDictionary:user];
        
        NSDictionary *status = dic[@"status"];
        comment.weiboMsg = [WeiboMsg createByDictionary:status Option:YES];

        
        NSString *timeStr = dic[@"created_at"];
        comment.created_at = [StringFormatTool getTimeString:timeStr];
        
        NSString *wbSource = dic[@"source"];
        wbSource = [StringFormatTool getSourceString:wbSource];
        if (wbSource != nil && ![wbSource isEqualToString:@""])
            comment.source = [NSString stringWithFormat:@"来自 %@", wbSource];
        else
            comment.source = @"";
        
//        if(dic[@"reply_comment"]){
//            NSNumber *reply_comment_id = dic[@"reply_comment"];
//        };
    }
    
    NSError *error;
    if (isSave == YES)[managedObjectContext save:&error];
    
    return comment;
}

+ (WeiboComment *)createdInCoreData {
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    WeiboComment *comment = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([WeiboComment class]) inManagedObjectContext:managedObjectContext];
    
    return comment;
}

@end
