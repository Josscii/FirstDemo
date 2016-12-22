//
//  FDMainCollectionViewCell.h
//  FirstDemo
//
//  Created by mxl on 16/12/8.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDMainCollectionViewCell : UICollectionViewCell

- (void)feedCellWithData:(id)data;

// use this when need force refresh
- (void)refreshCellWithData:(id)data;

- (void)startLoading;
- (void)endLoading;

@end
