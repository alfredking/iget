//
//  UIImage+CircleImage.m
//  iget
//
//  Created by alfredking－cmcc on 2021/3/7.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "UIImage+CircleImage.h"

@implementation UIImage (CircleImage)

- (UIImage *)drawCircleImage {
   UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
   [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:50] addClip];
   [self drawInRect:rect];

   UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   return output;
}

@end
