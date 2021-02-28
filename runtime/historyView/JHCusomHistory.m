//
//  JHCusomHistory.m
//  CJPubllicLessons
//
//  Created by cjatech-简豪 on 15/12/2.
//  Copyright (c) 2015年 cjatech-简豪. All rights reserved.
//

#import "JHCusomHistory.h"
#import "JHCustomFlow.h"

#import "HistorySearchModel.h"
#import "NSString+add.h"
#import "UIView+CLExtension.h"

#define  IitmHeight 30

@interface JHCusomHistory ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView    *_collectionView;   //流布局视图
    NSMutableArray      *_dataArr;          //流布局数据源
}
@property (assign, nonatomic) NSInteger maxSaveNum;  //最多保存记录数量

@property (assign, nonatomic) NSString *fileName;
//一个用来归档，一个用来显示
@property (strong,nonatomic) NSMutableArray <HistorySearchModel *>* historySearchArr;
//@property (strong,nonatomic) NSMutableArray <HistorySearchModel *>* historyShowSearchArr;
@end

@implementation JHCusomHistory


/**
 *  初始化方法
 *
 *  @param frame 流布局frame
 *  @param click item点击响应回调block
 *
 *  @return 自定义流布局对象
 */
-(id)initWithFrame:(CGRect)frame maxSaveNum:(NSInteger)maxSaveNum fileName:(NSString *)fileName andItemClickBlock:(itemClickBlock)click{
    if (self == [super initWithFrame:frame]) {
        _dataArr                    = [[NSMutableArray alloc] init];
        _itemClick                  = click;
        _maxSaveNum = maxSaveNum;
        _fileName = fileName;
        self.userInteractionEnabled = YES;
        [self configBaseView];
        [self readHistorySearch];
    }
    return self;
}


/**
 *  搭建基本视图
 */
- (void)configBaseView{
    self.backgroundColor            = [UIColor whiteColor];
    
    /* 自定义布局格式 */
    JHCustomFlow *flow              = [[JHCustomFlow alloc] init];
    flow.minimumLineSpacing         = 5;
    flow.minimumInteritemSpacing    = 5;
    
    /* 初始化流布局视图 */
    _collectionView                 = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flow];
    _collectionView.dataSource      = self;
    _collectionView.delegate        = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectionView];
    
    /* 提前注册流布局item */
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
}


#pragma mark -------------> UICollectionView协议方法
/**
 *  自定义流布局item个数 要比数据源的个数多1 需要一个作为清除历史记录的行
 *
 *  @param collectionView 当前流布局视图
 *  @param section        nil
 *
 *  @return 自定义流布局item的个数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count + 1;
}


/**
 *  第index项的item的size大小
 *
 *  @param collectionView       当前流布局视图
 *  @param collectionViewLayout nil
 *  @param indexPath            item索引
 *
 *  @return size大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == _dataArr.count) {
        return CGSizeMake(self.frame.size.width, IitmHeight);
    }
    
    NSString *str      = _dataArr[indexPath.row];    
    /* 根据每一项的字符串确定每一项的size */
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:18]};
    CGSize size        = [str boundingRectWithSize:CGSizeMake(self.frame.size.width, 1000) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil].size;
    size.height        = IitmHeight;
    size.width         += 10;
    return size;
}

/**
 *  流布局的边界距离 上下左右
 *
 *
 *
 *  @return 边界距离值
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(3, 5, 3, 3);
}


/**
 *  第index项的item视图
 *
 *  @param collectionView 当前流布局
 *  @param indexPath      索引
 *
 *  @return               item视图
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    for (UIView *vie in cell.contentView.subviews) {
        [vie removeFromSuperview];
    }
    if (indexPath.row == _dataArr.count) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, IitmHeight)];
        /* 判断最后一个item的内容 如果没有历史记录 内容就为暂无历史记录  否则为清除历史记录 */
        label.text = (_dataArr.count==0?(@"暂无历史记录"):(@"清除历史记录"));
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        return cell;
    }
    NSString *str = _dataArr[indexPath.row];
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:18]};
    CGSize size = [str boundingRectWithSize:CGSizeMake(self.frame.size.width, 1000) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil].size;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, IitmHeight)];
    label.text = str;
    label.font = [UIFont systemFontOfSize:18];
    cell.contentView.layer.cornerRadius = 5;
    cell.contentView.clipsToBounds = YES;
    cell.contentView.backgroundColor = [UIColor colorWithRed:arc4random()%250/256.0 + 0.3 green:arc4random()%255/256.0+0.2  blue:arc4random()%250/255.0 + 0.1 alpha:0.7];
    label.layer.borderColor = [UIColor whiteColor].CGColor;
    [cell.contentView addSubview:label];
    label.center = cell.contentView.center;
    return cell;
}



/**
 *  当前点击的item的响应方法
 *
 *  @param collectionView 当前流布局
 *  @param indexPath      索引
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    /* 响应回调block */
    
    if (indexPath.row == _dataArr.count) {
        [self clearHistory];
    }else{
        NSString *strKey = _dataArr[indexPath.row];
        _itemClick(strKey);
    }
}



//- (void)setDataArr:(NSMutableArray *)dataArr{
//    _dataArr = dataArr;
//
//    [_collectionView reloadData];
//}

- (void)setSearchKey:(NSString *)searchKey{
    _searchKey = searchKey;
    [self search:searchKey];
}

#pragma 数据处理相关
///处理数据
- (void)dealWithData{
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    for (HistorySearchModel *model in self.historySearchArr ) {
        [tmpArray addObject:model.title];
    }
    _dataArr = tmpArray;
    
    [_collectionView removeFromSuperview];
    _collectionView = nil;
    [self configBaseView];
    [_collectionView reloadData];
}

-(void)search:(NSString *)searchKey{
    if ([searchKey isValid]) {
        [self addHistoryModelWithText:searchKey andType:HistorySearchSuplly];
        [self saveHistorySearch];
        [self dealWithData];
    }
}

//历史搜索归档
-(void)saveHistorySearch{
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [Path stringByAppendingPathComponent:_fileName]; //注：保存文件的扩展名可以任意取，不影响。
//    //    NSLog(@"%@", filePath);
//    //归档
//    //    [NSKeyedArchiver archiveRootObject:self.historySearchArr toFile:filePath];
//
//    NSError *error = nil;
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.historySearchArr requiringSecureCoding:NO error:&error];
//    [data writeToFile:filePath atomically:YES];
//
//    if (error) {
//        NSLog(@"归档失败:%@", error);
//        return;
//    }
    
    NSArray *arr = @[@"1",@"2",@"3"];
    
    NSError *error;
    NSData *archiverData = [NSKeyedArchiver archivedDataWithRootObject:arr requiringSecureCoding:NO error:&error];
    if (error) {
        NSLog(@"Archiver Failed, errorInfo:%@", error);
    }
    BOOL isSuccess = [archiverData writeToFile:filePath atomically:YES];
    if (isSuccess) {
        NSLog(@"archiver success");
    }
    
}

//历史搜索解档
-(void)readHistorySearch{
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [Path stringByAppendingPathComponent:_fileName];
    
    //读文件
    NSData *data=[NSData dataWithContentsOfFile:filePath options:0 error:NULL];
    
    //解档
//        NSMutableArray<HistorySearchModel *> *personArr = [NSKeyedUnarchiver unarchivedObjectOfClass:[FLPersion class] fromData:self.archivedData error:&error];
    
    
    
//    NSError *error = nil;
////    NSMutableArray<HistorySearchModel *> *personArr = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSMutableArray class] fromData:data error:&error];
//    NSArray *personArr = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSMutableArray class] fromData:data error:&error];
//
//    if (personArr == nil || error) {
//        NSLog(@"解档失败:%@", error);
//        return;
//    }
    
    NSError *error;
    NSArray *personArr = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class] fromData:data error:&error];
    if (personArr == nil || error) {
        NSLog(@"解档失败:%@", error);
    } else {
        NSLog(@"解档成功:%@",[personArr description]);
    }
    
    
    
//    NSLog(@"%@ %ld",personArr,personArr.count);
    
//    self.historySearchArr = [NSMutableArray arrayWithArray:personArr];
    //    self.historyShowSearchArr =[NSMutableArray arrayWithArray:(NSMutableArray *) [[self.historySearchArr reverseObjectEnumerator]allObjects]];
//    [self dealWithData];
}

////历史搜索归档
//-(void)saveHistorySearch{
//    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *filePath = [Path stringByAppendingPathComponent:_fileName]; //注：保存文件的扩展名可以任意取，不影响。
//    //    NSLog(@"%@", filePath);
//    //归档
//    [NSKeyedArchiver archiveRootObject:self.historySearchArr toFile:filePath];
//}
//
////历史搜索解档
//-(void)readHistorySearch{
//    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *filePath = [Path stringByAppendingPathComponent:_fileName];
//    //解档
//    NSMutableArray<HistorySearchModel *> *personArr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
//
//    self.historySearchArr = [NSMutableArray arrayWithArray:personArr];
////    self.historyShowSearchArr =[NSMutableArray arrayWithArray:(NSMutableArray *) [[self.historySearchArr reverseObjectEnumerator]allObjects]];
//    [self dealWithData];
//}

//判断搜索记录是否重复后添加
-(void)addHistoryModelWithText:(NSString *)text andType:(HistorySearchType)type{
    
    //    重复的标志
    NSArray * array = [NSArray arrayWithArray: self.historySearchArr];
    BOOL isRepet = NO;
    for (HistorySearchModel *model in array) {
        if (model.type == HistorySearchSuplly &&  [model.title isEqualToString:text]) {
            [self.historySearchArr removeObject:model];
//            [self.historySearchArr addObject:[HistorySearchModel initWithTitle:text andType:type]];
            [self.historySearchArr insertObject:[HistorySearchModel initWithTitle:text andType:type] atIndex:0];
            isRepet = YES;
        }
    }
    if (!isRepet) {
        //控制保存记录的最大数
        if (self.historySearchArr.count == _maxSaveNum) {
            [self.historySearchArr removeLastObject];
        }
        [self.historySearchArr insertObject:[HistorySearchModel initWithTitle:text andType:type] atIndex:0];
    }
}
///清除历史记录
- (void)clearHistory{
    
    if (_dataArr.count == 0) {
        return;
    }
//    __weak typeof(self) weakSelf = self;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定清空历史记录吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //响应事件
        [self.historySearchArr removeAllObjects];
//        [self.historyShowSearchArr removeAllObjects];
        [self saveHistorySearch];
        [self dealWithData];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //响应事件
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [[self getCurrentViewController] presentViewController:alert animated:YES completion:nil];
    
}

-(NSMutableArray<HistorySearchModel *> *)historySearchArr
{
    if (!_historySearchArr) {
        _historySearchArr = [NSMutableArray array];
        
    }
    return _historySearchArr;
}
//-(NSMutableArray<HistorySearchModel *> *)historyShowSearchArr
//{
//    if (!_historyShowSearchArr) {
//        _historyShowSearchArr = [NSMutableArray array];
//
//    }
//    return _historyShowSearchArr;
//}







@end
