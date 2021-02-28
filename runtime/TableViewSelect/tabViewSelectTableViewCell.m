//
//  tabViewSelectTableViewCell.m
//  PickerView
//
//  Created by 大碗豆 on 17/7/24.
//  Copyright © 2017年 大碗豆. All rights reserved.
//

#import "tabViewSelectTableViewCell.h"

@implementation tabViewSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineView.backgroundColor = [UIColor orangeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
