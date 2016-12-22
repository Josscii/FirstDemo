//
//  FDEditCityFlowLayout.h
//  FirstDemo
//
//  Created by mxl on 16/12/6.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FDEditCityDelegate <NSObject>

@optional
- (BOOL)fd_collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)fd_collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;

@end

@interface FDEditCityFlowLayout : UICollectionViewFlowLayout

@end
