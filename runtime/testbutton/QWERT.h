//
//  QWERT.h
//  testbutton
//
//  Created by 大碗豆 on 17/8/2.
//  Copyright © 2017年 大碗豆. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EncouragelistArray;
@interface QWERT : NSObject


@property (nonatomic, copy) NSString *head;

@property (nonatomic, assign) NSInteger encourageNum;

@property (nonatomic, copy) NSString *nick;

@property (nonatomic, assign) NSInteger crId;

@property (nonatomic, copy) NSString *cid;

@property (nonatomic, assign) NSInteger cdid;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *addTime;

@property (nonatomic, strong) NSArray<EncouragelistArray *> *encourageList;

@property (nonatomic, copy) NSString *account;

@property (nonatomic, assign) NSInteger isEncourage;

@property (nonatomic, copy) NSString *content;



@end
@interface EncouragelistArray : NSObject

@property (nonatomic, copy) NSString *account;

@property (nonatomic, assign) NSInteger fans;

@property (nonatomic, copy) NSString *nick;

@property (nonatomic, assign) NSInteger identity;

@property (nonatomic, copy) NSString *addTime;

@property (nonatomic, copy) NSString *head;

@end

