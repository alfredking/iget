//
//  WeiboPrivacySetting.h
//  Fenvo
//
//  Created by Caesar on 15/7/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WeiboPrivacySetting : NSManagedObject

@property (nonatomic, retain) NSNumber * isBadge;
@property (nonatomic, retain) NSNumber * isComment;
@property (nonatomic, retain) NSNumber * isGeo;
@property (nonatomic, retain) NSNumber * isMessage;
@property (nonatomic, retain) NSNumber * isMobile;
@property (nonatomic, retain) NSNumber * isRealname;
@property (nonatomic, retain) NSNumber * isWebim;

@end
