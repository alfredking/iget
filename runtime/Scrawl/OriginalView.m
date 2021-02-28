//
//  OriginalView.m
//  testbutton
//
//  Created by 大豌豆 on 18/12/25.
//  Copyright © 2018年 大碗豆. All rights reserved.
//

#import "OriginalView.h"

@implementation OriginalView

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    NSLog(@"~~~~%zd",_imageArray.count);
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"carTop.png"];
    //     在给定的区域内按照 scaleFill 的模式画图
    [image drawInRect:rect];
    
    for (NSInteger i = 0; i < _imageArray.count; i ++) {
        
        NSDictionary *dic = _imageArray[i];
        
        CGPoint point = CGPointFromString(dic[@"Point"]);
        
        rect = CGRectMake(point.x-20, point.y-20, 40, 40);
        
        UIImage *image = [UIImage imageNamed:dic[@"imageName"]];
        //     在给定的区域内按照 scaleFill 的模式画图
        [image drawInRect:rect];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/

@end
