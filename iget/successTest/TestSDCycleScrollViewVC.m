//
//  TestSDCycleScrollViewVC.m
//  iget
//
//  Created by alfredking－cmcc on 2023/11/22.
//  Copyright © 2023 alfredking. All rights reserved.
//

#import "TestSDCycleScrollViewVC.h"
#import "SDCollectionViewCell.h"
#import "SDCycleScrollView.h"
#import "TAPageControl.h"


@interface TestSDCycleScrollViewVC ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSArray *redirectUrlArray;

@end

@implementation TestSDCycleScrollViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self __configBasic];
    id pageControl = [_cycleScrollView valueForKey:@"_pageControl"];
    if ([pageControl isKindOfClass:[TAPageControl class]]) {
        ((TAPageControl *)pageControl).spacingBetweenDots = 3;
    }
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i=0; i<3;i++) {
        [array addObject:@(i)];
    }
    self.cycleScrollView.localizationImageNamesGroup = array;
    self.cycleScrollView.delegate = self;
}

-(void)refreshDataRequestWithImgUrlArray:(NSArray *)imgUrlArray redirectUrlArray:(nonnull NSArray *)redirectUrlArray{
    [self fixCycleViewFlowLayoutSizeBug];
    if (imgUrlArray.count > 0) {
        _cycleScrollView.imageURLStringsGroup = imgUrlArray;
        if (imgUrlArray.count == 1) {
            self.cycleScrollView.autoScroll = NO;
            self.cycleScrollView.infiniteLoop = NO;
        }else{
            self.cycleScrollView.autoScroll = YES;
            self.cycleScrollView.infiniteLoop = YES;
            id pageControl = [_cycleScrollView valueForKey:@"_pageControl"];
            if ([pageControl isKindOfClass:[TAPageControl class]]) {
                ((TAPageControl *)pageControl).spacingBetweenDots = 1.0;
            }
        }
    }
    _redirectUrlArray = redirectUrlArray;
}
- (void)fixCycleViewFlowLayoutSizeBug{
    UICollectionViewFlowLayout *flowLayout = [self valueForKey:@"_flowLayout"];
    if (!flowLayout) {
        UICollectionView *mainView = [self valueForKey:@"_mainView"];
        if (mainView && mainView.collectionViewLayout && [mainView.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
            flowLayout = (UICollectionViewFlowLayout *)mainView.collectionViewLayout;
        }
    }
    
    if (flowLayout && !CGSizeEqualToSize(flowLayout.itemSize, self.view.frame.size)) {
        flowLayout.itemSize = self.view.frame.size;
    }
}
-(void)setAutoScroll:(BOOL)autoScroll{

    _cycleScrollView.autoScroll = autoScroll;
}
-(BOOL)autoScroll{
    return _cycleScrollView.autoScroll;
}
-(void) __configBasic {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.cycleScrollView];
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"%d clicked",index );
}
- (Class)customCollectionViewCellClassForCycleScrollView:(SDCollectionViewCell *)view{
    return [SDCollectionViewCell class];
}

/** 如果你自定义了cell样式，请在实现此代理方法为你的cell填充数据以及其它一系列设置 */
//- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view{
//    SDCollectionViewCell *viewCell = (SDCollectionViewCell *)cell;
//    NSArray *imagePathsGroup = [view valueForKey:@"imagePathsGroup"];
//    if (imagePathsGroup == nil || [imagePathsGroup count] <= index) {
//        return;
//    }
//
//
//}

#pragma mark - getter
-(SDCycleScrollView *)cycleScrollView {
    if (_cycleScrollView  == nil) {
        _cycleScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(10, 100, 300, 400)];
        _cycleScrollView.delegate = self;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        _cycleScrollView.showPageControl = YES;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.pageDotImage = [UIImage imageNamed:@"img_轮播锚点-normal"];
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"img_轮播锚点-select"];
        _cycleScrollView.autoScrollTimeInterval = 6;
        _cycleScrollView.pageControlDotSize = CGSizeMake(9, 4);
        _cycleScrollView.layer.cornerRadius = 8.0;
        _cycleScrollView.layer.masksToBounds = YES;
    }
    return _cycleScrollView;
}

@end
