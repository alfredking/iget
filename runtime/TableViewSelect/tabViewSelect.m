//
//  tabViewSelect.m
//  PickerView
//
//  Created by 大碗豆 on 17/7/24.
//  Copyright © 2017年 大碗豆. All rights reserved.
//

#import "tabViewSelect.h"

#import "tabViewSelectTableViewCell.h"

#define kScreenBounds [[UIScreen mainScreen] bounds]
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height

//static CGFloat bgViewHeith = 250;
//static CGFloat cityPickViewHeigh = 200;
static CGFloat toolsViewHeith = 50;
static CGFloat animationTime = 0.25;

@interface tabViewSelect ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat bgViewHeith;
    CGFloat cityPickViewHeigh;
    
}

@property (nonatomic, strong) UIPickerView *PickerView;/** 城市选择器 */

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *sureButton;        /** 确认按钮 */
@property (nonatomic, strong) UIButton *canselButton;      /** 取消按钮 */
@property (nonatomic, strong) UIView *toolsView;           /** 自定义标签栏 */
@property (nonatomic, strong) UIView *toolsViewBottom;     /** 自定义下部标签栏 */
@property (nonatomic, strong) UIView *bgView;              /** 背景view */

@property (nonatomic,assign)NSInteger courrentCell;


@end

@implementation tabViewSelect

// init 会调用 initWithFrame
- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIApplication sharedApplication].keyWindow.bounds;
        
//        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        //        [self initSubViews];
        //        [self initBaseData];
        
    }
    return self;
}


//- (void)setHeight:(CGFloat)height{
//    _height = height;
//
//    [self initSubViews];
//}

- (void)setSelecTitle:(NSString *)selecTitle{
    _selecTitle = selecTitle;
}
//- (void)setOnedataArr:(NSArray *)onedataArr{
//    _onedataArr = onedataArr;
//}
//
//
//- (void)setTowdataArr:(NSArray *)towdataArr{
//    _towdataArr = towdataArr;
//    [self initSubViews];
//}

- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    
    bgViewHeith = _dataArr.count * toolsViewHeith + toolsViewHeith;
    cityPickViewHeigh = _dataArr.count * toolsViewHeith;
    
    if (cityPickViewHeigh > kScreenHeight / 2) {
        cityPickViewHeigh = kScreenHeight/2 - toolsViewHeith;
        bgViewHeith = kScreenHeight / 2;
    }
    
    self.courrentCell = 0;
    [self initSubViews];
    self.contentTitle = self.dataArr[0];
}


- (void)initSubViews{
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.toolsView];
    //    [self.bgView addSubview:self.toolsViewBottom];
    
    
    [self.toolsView addSubview:self.canselButton];
    [self.toolsView addSubview:self.sureButton];
    [self.toolsView addSubview:[self selectTitle]];
    
    //    [self.toolsViewBottom addSubview:[self pctView]];
    [self.bgView addSubview:self.tableView];
    
    [self showPickView];
    
}

//- (void)initBaseData{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
//    self.allCityInfo = [NSDictionary dictionaryWithContentsOfFile:path];
//    NSMutableArray *tempArr = [NSMutableArray array];
//    for (int i=0; i<self.allCityInfo.count; i++) {
//        NSDictionary *dic = [self.allCityInfo valueForKey:[@(i) stringValue]];
//        [tempArr addObject:dic.allKeys[0]];
//    }
//    self.provinceArr    = [tempArr copy];
//    self.provinceDic    = [[self.allCityInfo valueForKey:[@(0) stringValue]] valueForKey:self.provinceArr[0]];
//    self.cityArr        = [self getNameforProvince:0];
//    self.townArr        = [[self.provinceDic valueForKey:[@(0) stringValue]] valueForKey:self.cityArr[0]];
//
//    self.province   = self.provinceArr[0];
//    self.city       = self.cityArr[0];
//    self.town       = self.townArr[0];
//
//}

#pragma event menthods
- (void)canselButtonClick{
    [self hidePickView];
    if (self.config) {
        self.config(self.contentTitle);
    }
}

- (void)sureButtonClick{
    [self hidePickView];
    if (self.config) {
        self.config(self.contentTitle);
    }
}

#pragma mark private methods
- (void)showPickView{
    [UIView animateWithDuration:animationTime animations:^{
        self.bgView.frame = CGRectMake(0, self.frame.size.height - self->bgViewHeith - toolsViewHeith  + 49, self.frame.size.width, self->bgViewHeith);
    } completion:^(BOOL finished) {
        
    }];
}


- (void)hidePickView{
    
    [UIView animateWithDuration:animationTime animations:^{
        
        self.bgView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self->bgViewHeith);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

//- (NSArray *)getNameforProvince:(NSInteger)row{
//    self.provinceDic = [[self.allCityInfo valueForKey:[@(row) stringValue]] objectForKey:self.provinceArr[row]];
//    NSMutableArray *temp2 = [[NSMutableArray alloc] init];
//    for (int i=0; i<self.provinceDic.allKeys.count; i++) {
//        NSDictionary *dic = [self.provinceDic valueForKey:[@(i) stringValue]];
//        [temp2 addObject:dic.allKeys[0]];
//    }
//    return temp2;
//}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *str = @"tabViewSelect";
    tabViewSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"tabViewSelectTableViewCell" owner:nil options:nil] firstObject];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == self.courrentCell) {
        cell.selectImage.image = [UIImage imageNamed:@"selectCar"];
    }
    
    cell.labTitle.text = self.dataArr[indexPath.row];
    return cell;
    
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
    
    tabViewSelectTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == self.courrentCell) {
        
    }else{
        cell.selectImage.image = [UIImage imageNamed:@"scXuanZhong"];
//        cell.labTitle.textColor = [UIColor orangeColor];
        self.courrentCell = indexPath.row;
        [self.tableView reloadData];
    }
    
    self.contentTitle = self.dataArr[indexPath.row];
    
    if (self.config) {
        self.config(self.contentTitle);
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if ([touches.anyObject.view isKindOfClass:[self class]]) {
        [self hidePickView];
    }
}

#pragma mark - lazy

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, bgViewHeith)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = ({
            UITableView *tab = [[UITableView alloc] initWithFrame:CGRectMake(0, toolsViewHeith, self.frame.size.width, cityPickViewHeigh) style:(UITableViewStylePlain)];
            tab.rowHeight = toolsViewHeith;
            tab.dataSource = self;
            tab.delegate = self;
            tab.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
            tab.backgroundColor = [UIColor whiteColor];
            tab.separatorStyle = UITableViewCellSeparatorStyleNone;
            tab;
        });
    }
    return _tableView;
}


- (UIView *)toolsView{
    
    if (!_toolsView) {
        _toolsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, toolsViewHeith)];
        //        _toolsView.layer.borderWidth = 0.5;
        //        _toolsView.layer.borderColor = [UIColor redColor].CGColor;
        _toolsView.backgroundColor = [UIColor purpleColor];
    }
    return _toolsView;
}

- (UIButton *)canselButton{
    if (!_canselButton) {
        _canselButton = ({
            UIButton *canselButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, toolsViewHeith, toolsViewHeith)];
            [canselButton setTitle:@"取消" forState:UIControlStateNormal];
            canselButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [canselButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [canselButton addTarget:self action:@selector(canselButtonClick) forControlEvents:UIControlEventTouchUpInside];
            canselButton;
        });
    }
    return _canselButton;
}

- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = ({
            UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 20 - toolsViewHeith, 0, toolsViewHeith, toolsViewHeith)];
            [sureButton setTitle:@"确定" forState:UIControlStateNormal];
            sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [sureButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
            sureButton;
        });
    }
    return _sureButton;
}

- (UILabel *)selectTitle{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width/2 - toolsViewHeith), 0, toolsViewHeith * 2, toolsViewHeith)];
    
    lab.textColor = [UIColor blackColor];
    lab.font = [UIFont systemFontOfSize:14];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = self.selecTitle;
    return lab;
}


- (UIView *)toolsViewBottom{
    
    if (!_toolsViewBottom) {
        _toolsViewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, toolsViewHeith, self.frame.size.width, toolsViewHeith)];
        //        _toolsViewBottom.layer.borderWidth = 0.5;
        //        _toolsViewBottom.layer.borderColor = [UIColor redColor].CGColor;
        _toolsViewBottom.backgroundColor = [UIColor lightGrayColor];
    }
    return _toolsViewBottom;
}


- (UIView *)pctView{
    
    UIView *pctView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, toolsViewHeith/2)];
    NSArray *arrTitle = @[@"省",@"市",@"区"];
    
    for (NSInteger i = 0; i<arrTitle.count; i ++) {
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width/3) * i, 0, self.frame.size.width/3, toolsViewHeith/2)];
        lab.text = [NSString stringWithFormat:@"%@",arrTitle[i]];
        lab.textColor = [UIColor blackColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:14.f];
        [pctView addSubview:lab];
    }
    
    return pctView;
}

@end
