//
//  tabViewSelect.h
//  PickerView
//
//  Created by 大碗豆 on 17/7/24.
//  Copyright © 2017年 大碗豆. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^sureBtnClick) (NSString *contentTitlet);

@interface tabViewSelect : UIView

@property (nonatomic, strong) NSString *contentTitle;           /** 省 */
//@property (nonatomic, strong) NSString *towList;               /** 市 */
@property (nonatomic, copy) sureBtnClick config;

@property (nonatomic, strong)NSString *selecTitle;

@property (nonatomic, strong)NSArray *dataArr;

@end
