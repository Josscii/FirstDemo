//
//  FDShareCollectionViewCell.h
//  FirstDemo
//
//  Created by mxl on 16/12/23.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>

@class FDShareCollectionViewCell;

@protocol FDShareDelegate <NSObject>

- (void)shareWithCell:(FDShareCollectionViewCell *)cell;

@end

@interface FDShareCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<FDShareDelegate> delegate;
@property (nonatomic, strong) UIImageView *shareImageView;
@property (nonatomic, strong) UILabel *shareLabel;
@property (nonatomic, strong) UIButton *shareCircleView;
@property (nonatomic, assign) UMSocialPlatformType platformType;

@end
