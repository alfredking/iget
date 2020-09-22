//
//  CTDisplayView.m
//  RSA原理
//
//  Created by alfredking－cmcc on 2020/5/26.
//  Copyright © 2020 joyios. All rights reserved.
//

#import "CTDisplayView.h"
#import "CoreText/CoreText.h"
@implementation CTDisplayView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect: rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //坐标系上下翻转
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    
    //创建绘制的区域
    CGMutablePathRef path = CGPathCreateMutable();
    //长方形布局
    //CGPathAddRect(path, NULL, self.bounds);
    CGPathAddEllipseInRect(path, NULL, self.bounds);
    
    //ellipse是椭圆的意思
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"hello World"
        "创建绘制的区域，CoreText本身支持各种文字排版的区域，"
        " 我们这里简单地将 UIView 的整个界面作为排版的区域。"
        " 为了加深理解，建议读者将该步骤的代码替换成如下代码，"
        " 测试设置不同的绘制区域带来的界面变化。"];
    
    
    [attString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor redColor]
                             range:NSMakeRange(0, 22)];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
    
    CTFrameDraw(frame, context);
    
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
    
}


@end
