//
//  TestCustomTableViewCell.m
//  iget
//
//  Created by alfredking－cmcc on 2021/9/5.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "TestCustomTableViewCell.h"
#import "TestTableViewController.h"

@interface TestCustomTableViewCell()

@property(nonatomic,strong) UIButton *button;
@property(nonatomic,assign) int currentIndex;
@property (nonatomic, copy) dispatch_block_t block;
@end

@implementation TestCustomTableViewCell
//
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
////    [self.contentView addSubview:self.button];
//}

//- (instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//
//    }
//    return self;
//}
//- (void)__configBasicView{
//
//    [self.contentView addSubview:self.button];
//
//}

- (void)updateCellAtIndex:(int)index
{
    _button = [[UIButton alloc]initWithFrame:CGRectMake(80, 0, 50, 50)];
    [self.contentView addSubview:self.button];
    
    self.button.backgroundColor = [UIColor greenColor];
    self.currentIndex = index;
    [self.button addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
}
    
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)add
{
    TestTableViewController *tvc = [self findViewController:self];
    [tvc.dataList  replaceObjectAtIndex:self.currentIndex withObject:@"101"];
    
//    if(self.currentIndex == 2)
//    {
//        self.block = ^{
//            self.button.backgroundColor = [UIColor blackColor];
//             };
//        self.block();
//    }
}

- (UIViewController *)findViewController:(UIView *)sourceView
{

        id target=sourceView;

        while (target) {

           target = ((UIResponder *)target).nextResponder;

           if ([target isKindOfClass:[UIViewController class]]) {

               break;
       }
   }

   return target;
}

-(void)dealloc
{
    NSLog(@"TestCustomTableViewCell dealloc called %p",self);
}
@end
