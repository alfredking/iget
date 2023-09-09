//
//  TestCollectionViewCell.m
//  iget
//
//  Created by alfredking－cmcc on 2021/10/21.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "TestCollectionViewCell.h"

@interface TestCollectionViewCell()

@property (nonatomic,strong) UILabel *label;

@end

@implementation TestCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.label];
    }
    return self;
}

-(void)updateWithText:(NSString *)text
{
    self.label.text =text;
}

-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(25, 25, 100, 50)];
        _label.textColor = [UIColor greenColor];
    }
    return _label;
}
@end
