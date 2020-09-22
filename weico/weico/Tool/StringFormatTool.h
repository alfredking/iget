//
//  StringFormatTool.h
//  Fenvo
//
//  Created by Caesar on 15/8/5.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringFormatTool : NSObject

+ (NSString *) getTimeString : (NSString *)timeStr;
+ (NSString *) getSourceString:(NSString *)src;
+ (NSArray *)getPicUrls:(NSString *)url;
+ (NSString *)getBimmdlePicUrl:(NSString *)url;
+ (NSString *) getOriginalPicUrl:(NSString *)url;

@end
