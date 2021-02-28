//
//  SelectLabelShowVC.m
//  testbutton
//
//  Created by 大豌豆 on 20/J/1.
//  Copyright © 2020 大碗豆. All rights reserved.
//

#import "SelectLabelShowVC.h"
#import "TopConditionCollectionView.h"
#import "YYFilterToolMacro.h"
#import "TopConditionCell.h"
#import "Masonry/Masonry.h"

///顶部筛选条件展示高度
#define ShowCondtionViewHeight 40

@interface SelectLabelShowVC ()
/* 头部的条件框collectionView */
//@property (nonatomic, strong) TopConditionCollectionView *topConditionCollectionView;

@property (nonatomic, strong) NSMutableArray *condtionArray;
//
/// 头部展示相关
@property (nonatomic, strong) UIView *showCondtionBackView;
@property (nonatomic, strong) TopConditionCollectionView *topConditionCollectionView;
//@property (nonatomic, strong) NSMutableArray *condtionShowArray;
//@property (nonatomic, strong) NSMutableArray *condtionSearchArray;
@property (nonatomic,assign) BOOL ischangeFame;

@end

@implementation SelectLabelShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topFilterDeleteBtnClick:) name:FilterViewTopCollectionDeleteBtnClick object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(20, STATUS_NAV_HEIGHT, 80, 50);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"筛选" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
}

- (void)btnAction{
    //改变页面布局
    [self.condtionArray removeAllObjects];
    self.showCondtionBackView.hidden = NO;
    self.ischangeFame = YES;
    self.condtionArray = [NSMutableArray arrayWithArray:@[@"司法案例查询",@"司法执行查询",@"司法失信查询",@"税务执法查询",@"催欠公告查询",@"网贷逾期查询"]];
    self.topConditionCollectionView.conditions = self.condtionArray;
    [self.topConditionCollectionView reloadData];
}

#pragma 筛选条件相关
-(UIView *)showCondtionBackView{
    if (!_showCondtionBackView) {
        _showCondtionBackView = [[UIView alloc] init];
        [self.view addSubview:_showCondtionBackView];
        [_showCondtionBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(150));
            make.left.right.equalTo(self.view);
            make.height.equalTo(@(ShowCondtionViewHeight));
        }];
        _showCondtionBackView.backgroundColor = [UIColor orangeColor];
        
        UIButton *clearBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_showCondtionBackView addSubview:clearBtn];
        [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_showCondtionBackView).offset(-13);
            make.centerY.equalTo(_showCondtionBackView);
            make.height.equalTo(@(22));
            make.width.equalTo(@(55));
        }];
        [clearBtn setTitle:@"清除" forState:(UIControlStateNormal)];
        [clearBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        clearBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        clearBtn.backgroundColor = [UIColor lightGrayColor];
//        XBViewBorderRadius(clearBtn, 11, 0, [UIColor colorWithHexString:@"#EFEFEF"]);
        [clearBtn addTarget:self action:@selector(clearBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_showCondtionBackView layoutIfNeeded];

        //顶部已经筛选的条件
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _topConditionCollectionView = [[TopConditionCollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMinX(clearBtn.frame) - 10, ShowCondtionViewHeight) collectionViewLayout:layout];
        _topConditionCollectionView.backgroundColor = [UIColor cyanColor];
        _topConditionCollectionView.showsHorizontalScrollIndicator = NO;
        [_showCondtionBackView addSubview:_topConditionCollectionView];
        
        
    }
    
    return _showCondtionBackView;
}


#pragma mark - Notification Func
- (void)topFilterDeleteBtnClick:(NSNotification *)notification {
    //得到当前点击的按钮的序号
    NSDictionary *userInfo = notification.userInfo;
    TopConditionCell *tmpCell = (TopConditionCell *)userInfo[@"cell"];
    NSIndexPath *indexPath = [_topConditionCollectionView indexPathForCell:tmpCell];
    [self.condtionArray removeObjectAtIndex:indexPath.row];
    _topConditionCollectionView.conditions = self.condtionArray;
    [_topConditionCollectionView reloadData];
    if (self.condtionArray.count == 0) {
        [self clearBtnAction];
    }
    NSLog(@"%zd",indexPath.row);
}

- (void)clearBtnAction{
    [self.condtionArray removeAllObjects];
    self.showCondtionBackView.hidden = YES;
    self.ischangeFame = NO;
    [_topConditionCollectionView reloadData];
}
@end
