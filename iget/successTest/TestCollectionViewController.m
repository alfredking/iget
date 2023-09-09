//
//  TestCollectionViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2021/10/21.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "TestCollectionViewController.h"
#import "TestCollectionViewCell.h"
#import "TestCollectionViewLayout.h"
#import "Masonry.h"

@interface TestCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) UIView *snapshotView;
@property(nonatomic,assign) NSInteger firstCount;
//@property(nonatomic,assign) NSInteger secondCount;
@end

@implementation TestCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init
{
    
    //line 跟滚动方向相同的间距
    
    //item 跟滚动方向垂直的间距
    
    TestCollectionViewLayout *layout = [[TestCollectionViewLayout alloc]init];
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(100, 100);
    self = [super initWithCollectionViewLayout:layout ];
    if (self) {
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
        self.firstCount = 12;
       
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    self.collectionView.backgroundColor = [UIColor blueColor];
    
    
    // Register cell classes
    [self.collectionView registerClass:[TestCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
   
    
    // Do any additional setup after loading the view.
//    NSIndexPath* cellIndexPath = [NSIndexPath indexPathForItem:0 inSection:1];
//    [self.collectionView scrollToItemAtIndexPath:cellIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    if(section == 3||section == 2)
//        return 1;
//    else
//        return 12;
    if (section == 0)
    {
        return self.firstCount;
//        return 12;
    }
    else
    {
        return 8;
    }
      
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell updateWithText:[NSString stringWithFormat:@"s%ldr%ld",(long)indexPath.section,(long)indexPath.row]];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0)
    {
        
            return UIEdgeInsetsMake(0, 12, 0, 0);
    }
    else if(section == 2)
    {
        return UIEdgeInsetsMake(0, 12, 0, 0);
    }
    else
    {
        return UIEdgeInsetsMake(0, 15, 20, 15);
    }
        
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (![kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return nil;
    }
    if(indexPath.section == 1)
    {
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor greenColor];
//        headerView.hei

        return headerView;
    }
    else
        
      return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return CGSizeMake(self.collectionView.frame.size.width, 35);
    }
    else
        return CGSizeZero;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*截图实现添加动画
    TestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    [UIView animateWithDuration:1 animations:^{
//        cell.frame=CGRectMake(cell.frame.origin.x , cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);//大小位置
//
//        } completion:^(BOOL finished) {
//            if (finished) {
//                [UIView animateWithDuration:2 animations:^{
//                    cell.frame=CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
//                }];
//            }
//        }];
    
    // 使用系统的截图功能,得到cell的截图视图
    self.snapshotView = [cell.contentView snapshotViewAfterScreenUpdates:YES];
    self.snapshotView.frame = cell.frame;
    self.snapshotView.backgroundColor = [UIColor redColor];
    [self.view addSubview: self.snapshotView];
    [self.view bringSubviewToFront:self.snapshotView];
    // 截图后隐藏当前cell
//    cell.hidden = YES;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.snapshotView.transform = CGAffineTransformMakeScale(1.05, 1.05);
        self.snapshotView.frame=CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    } completion:nil];
//    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    [UIView performWithoutAnimation:^{
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }];
     */
    self.firstCount+=1;
    [self.collectionView performBatchUpdates:^{
//        [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:self.firstCount-1 inSection:0]]];

    } completion:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static NSInteger currentIndex = 0;

    NSInteger index=scrollView.contentOffset.y;
    CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
//    NSLog(@"visibleRect  is %@",NSStringFromCGRect(visibleRect) );
    CGPoint visiblePoint = CGPointMake(30, CGRectGetMinY(visibleRect));
//    NSLog(@"visiblePoint  is %@",NSStringFromCGPoint(visiblePoint) );
    NSIndexPath *visibleIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
//    NSLog(@"visibleIndexPath  is %ld",(long)visibleIndexPath.section);
    if (currentIndex == visibleIndexPath.section || visibleIndexPath == nil) {
        return;
    }
    currentIndex = visibleIndexPath.section;

    NSLog(@"current index is %ld",(long)currentIndex);
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
//    //取出移动row数据
//    HYApplicationModel *movedModel = self.sectionInfo.myApps[sourceIndexPath.row];
//    //从数据源中移除该数据
//    [self.sectionInfo.myApps removeObject:movedModel];
//    //将数据插入到数据源中的目标位置
//    [self.sectionInfo.myApps insertObject:movedModel atIndex:destinationIndexPath.row];
}




@end
