//
//  WidgetCollectionViewCell.h
//  FirstDemo
//
//  Created by mxl on 16/12/27.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WidgetCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *weatherImageView;
@property (nonatomic, strong) UILabel *tempLabel;

- (void)alphaView;

@end
