//
//  TextVHeigthCustomVC.m
//  testbutton
//
//  Created by lmcqc on 2020/10/26.
//  Copyright © 2020 大碗豆. All rights reserved.
//

#import "TextVHeigthCustomVC.h"

@interface TextVHeigthCustomVC ()<UITextViewDelegate>
@property(nonatomic,strong)UITextView *textView;
@end

@implementation TextVHeigthCustomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.textView];
}

/**
 UITextView
 
 @return UITextView
 */
-(UITextView *)textView{
    if (!_textView) {
        //http://www.cnblogs.com/xiaofeixiang/
        _textView=[[UITextView alloc]initWithFrame:CGRectMake(30, 200, CGRectGetWidth([[UIScreen mainScreen] bounds])-60, 30)];
        [_textView setTextColor:[UIColor redColor]];
        [_textView.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [_textView setFont:[UIFont systemFontOfSize:15]];
        [_textView.layer setBorderWidth:1.0f];
        [_textView setDelegate:self];
    }
    return _textView;
}

-(void)textViewDidChange:(UITextView *)textView{
    //博客园-FlyElephant
    static CGFloat maxHeight =60.0f;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<=frame.size.height) {
        size.height=frame.size.height;
    }else{
        if (size.height >= maxHeight)
        {
            size.height = maxHeight;
            textView.scrollEnabled = YES;   // 允许滚动
        }
        else
        {
            textView.scrollEnabled = NO;    // 不允许滚动
        }
    }
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
}

@end
