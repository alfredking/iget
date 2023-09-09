//
//  TestCollectionViewLayout.m
//  iget
//
//  Created by alfredking－cmcc on 2022/4/18.
//  Copyright © 2022 alfredking. All rights reserved.
//

#import "TestCollectionViewLayout.h"
#import "Masonry.h"
@interface TestDecorationView : UICollectionReusableView

@end

@implementation TestDecorationView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 8.0;
        bgView.layer.masksToBounds = YES;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

@end

@interface TestCollectionViewLayout()

@property (nonatomic, strong) NSMutableArray *insertIndexPaths;

@end

@implementation TestCollectionViewLayout

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self registerClass:[TestDecorationView class] forDecorationViewOfKind:NSStringFromClass([TestDecorationView class])];
        //注册Decoration View
    }
    return self;
}

- (void)prepareLayout{
    [super prepareLayout];
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path

{
 UICollectionViewLayoutAttributes* attributes =   [super layoutAttributesForItemAtIndexPath:path];
    CGRect currentRect = attributes.frame;
    currentRect.origin.y = currentRect.origin.y+100;
    
    if(!(path.item<=5&&path.section == 0))
    {
        attributes.frame = currentRect;
    }

// attributes.size = CGSizeMake(215/3.0, 303/3.0);
// attributes.center=CGPointMake(80*(path.item+1), 62.5+125*path.section);
 return attributes;

}

//Decoration View的布局。

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)decorationViewKind atIndexPath:(NSIndexPath *)indexPath{



UICollectionViewLayoutAttributes* att = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];



   att.frame=CGRectMake(0, 0, 320, 125);

   att.zIndex=-1;



return att;



}

//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//
//
//
//    NSMutableArray* attributes = [NSMutableArray array];
//
////    NSArray *attributesArray = [super layoutAttributesForElementsInRect:rect];
////    NSMutableArray *mutArray = [attributesArray mutableCopy];
//
//    //把Decoration View的布局加入可见区域布局。
//
//    for (int y=0; y<3; y++)
//    {
//
//          NSIndexPath* indexPath = [NSIndexPath indexPathForItem:3 inSection:y];
//
//          [attributes addObject:[self layoutAttributesForDecorationViewOfKind:NSStringFromClass([TestDecorationView class]) atIndexPath:indexPath]];
//
//       }
//
//
//
//    for (NSInteger i=0 ; i < 12; i++)
//    {
//
//        for (NSInteger t=0; t<8; t++)
//        {
//
//           NSIndexPath* indexPath = [NSIndexPath indexPathForItem:t inSection:i];
//
//           [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
//
//        }
//
//
//
//      }
//
//
//
//    return attributes;
//
//}


- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    // Keep track of insert and delete index paths
    [super prepareForCollectionViewUpdates:updateItems];

    self.insertIndexPaths = [NSMutableArray array];

    for (UICollectionViewUpdateItem *update in updateItems)
    {
         if (update.updateAction == UICollectionUpdateActionInsert)
        {
            [self.insertIndexPaths addObject:update.indexPathAfterUpdate];
        }
    }
}

- (void)finalizeCollectionViewUpdates
{
    [super finalizeCollectionViewUpdates];
    // release the insert and delete index paths
    self.insertIndexPaths = nil;
}

// Note: name of method changed
// Also this gets called for all visible cells (not just the inserted ones) and
// even gets called when deleting cells!
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    // Must call super
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];

    if ([self.insertIndexPaths containsObject:itemIndexPath])
    {
        // only change attributes on inserted cells
        if (!attributes)
            attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];

        // Configure attributes ...
        attributes.alpha = 0.0;
        attributes.center = CGPointMake(self.collectionView.frame.size.width/2 , self.collectionView.frame.size.height/2);
        attributes.zIndex = 100;
    }

    return attributes;
}



@end
