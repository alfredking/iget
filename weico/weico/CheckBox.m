//
//  Radio.m
//  Fenvo
//
//  Created by Caesar on 15/6/4.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "CheckBox.h"
#import "UIImage+FontAwesome.h"

@implementation CheckBox

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    [self initWithStyle];
    }
    return self;
}

- (void) initWithStyle {
    [self setImage:[UIImage imageWithIcon:@"fa-check-square-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor orangeColor] andSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    
    self.isSelected = TRUE;
    [self addTarget:self action:@selector(checkBoxClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)checkBoxClick {
    self.isSelected = !self.isSelected;
    if (self.isSelected == TRUE) {
        [self setImage:[UIImage imageWithIcon:@"fa-check-square-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor orangeColor] andSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    }else{
        [self setImage:[UIImage imageWithIcon:@"fa-square-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor grayColor] andSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    }
    NSLog(@"post btn %d",self.isSelected);
}




@end
