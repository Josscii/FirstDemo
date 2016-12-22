//
//  FDEditCityFlowLayout.m
//  FirstDemo
//
//  Created by mxl on 16/12/6.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDEditCityFlowLayout.h"
#import "FDConstants.h"

@interface FDEditCityFlowLayout ()

@property (nonatomic, strong) NSIndexPath *indexPathForReordering;
@property (nonatomic, strong) UIView *snapshotView;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, weak) id<FDEditCityDelegate> editCityDelegate;

@end

@implementation FDEditCityFlowLayout

- (id<FDEditCityDelegate>)editCityDelegate {
    return (id<FDEditCityDelegate>)self.collectionView.dataSource;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongGesture:)];
        [self.collectionView addGestureRecognizer:_longPressGesture];
    }
}

- (void)handleLongGesture:(UILongPressGestureRecognizer *)gesture {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:EDITINGCITY]) {
        return;
    }
    
    CGPoint location = [gesture locationInView:gesture.view];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    if ([self.editCityDelegate respondsToSelector:@selector(fd_collectionView:canMoveItemAtIndexPath:)]) {
        if (![self.editCityDelegate fd_collectionView:self.collectionView canMoveItemAtIndexPath:indexPath]) {
            return;
        }
    }
    
    switch(gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            _indexPathForReordering = indexPath;
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath: _indexPathForReordering];
            _snapshotView = [cell snapshotViewAfterScreenUpdates:NO];
            _snapshotView.center = cell.center;
            [self.collectionView addSubview:_snapshotView];
            cell.alpha = 0;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            _snapshotView.center = location;
            if (indexPath) {
                
                if ([self.editCityDelegate respondsToSelector:@selector(fd_collectionView:moveItemAtIndexPath:toIndexPath:)]) {
                    [self.editCityDelegate fd_collectionView:self.collectionView moveItemAtIndexPath:_indexPathForReordering toIndexPath:indexPath];
                }
                
                [self.collectionView moveItemAtIndexPath:_indexPathForReordering toIndexPath:indexPath];
                
                _indexPathForReordering = indexPath;
                [self.collectionView cellForItemAtIndexPath: _indexPathForReordering].alpha = 0;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath: _indexPathForReordering];
            
            [UIView animateWithDuration:0.25f animations:^{
                _snapshotView.center = cell.center;
            } completion:^(BOOL finished) {
                [self.collectionView cellForItemAtIndexPath: _indexPathForReordering].alpha = 1;
                [_snapshotView removeFromSuperview];
            }];
        }
            break;
        default:
            break;
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray<UICollectionViewLayoutAttributes *> *layoutAttributes = [super layoutAttributesForElementsInRect:rect];
    
    NSInteger currentCityCount = [[NSUserDefaults standardUserDefaults] integerForKey:CURRENTCITYCOUNT];
    BOOL editingCity = [[NSUserDefaults standardUserDefaults] boolForKey:EDITINGCITY];
    
    // 只要 = 9 + 号就 hidden
    for (UICollectionViewLayoutAttributes *attr in layoutAttributes) {
        if (currentCityCount >= 9) {
            if (attr.indexPath.item == 9) {
                attr.hidden = YES;
                break;
            }
        } else {
            if (editingCity) {
                if (attr.indexPath.item == currentCityCount) {
                    attr.hidden = YES;
                }
            } else {
                if (attr.indexPath.item == currentCityCount) {
                    attr.hidden = NO;
                }
            }
        }
    }
    
    return layoutAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
