//
//  FDCurrentWeatherTableViewCell.h
//  FirstDemo
//
//  Created by mxl on 16/12/2.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDIconLabelView.h"
#import "FDTableViewCell.h"

@interface FDCurrentWeatherTableViewCell : FDTableViewCell

@property (nonatomic, strong) UILabel *briefInfoLabel;
@property (nonatomic, strong) UILabel *currentTempLabel;

@property (nonatomic, strong) FDIconLabelView *airQualityView;

@property (nonatomic, strong) FDIconLabelView *bodyTempView;
@property (nonatomic, strong) FDIconLabelView *windView;
@property (nonatomic, strong) FDIconLabelView *waterView;

@end
