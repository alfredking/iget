//
//  tabViewSelectTableViewCell.h
//  PickerView
//
//  Created by 大碗豆 on 17/7/24.
//  Copyright © 2017年 大碗豆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tabViewSelectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;

@end
