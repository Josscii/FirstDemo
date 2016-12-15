//
//  FDForecastWeatherCollectionViewCell.h
//  FirstDemo
//
//  Created by mxl on 16/12/1.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDForecastWeatherCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *weakdayLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *weatherIcon;
@property (nonatomic, strong) UILabel *tempLabel;

@end
