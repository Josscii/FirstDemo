//
//  FDTodayWeatherCollectionViewCell.m
//  FirstDemo
//
//  Created by mxl on 16/12/1.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDTodayWeatherCollectionViewCell.h"
#import "FDConstants.h"
#import "UILabel+FDLabel.h"
#import "Masonry/Masonry.h"

@implementation FDTodayWeatherCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configreLayout];
        [self feedFakeData];
    }
    return self;
}

- (void)configreLayout {
    self.backgroundColor = [UIColor clearColor];
    
    _timeLabel = [UILabel commonLableWithFontName:SFDR FontSize:13 colorAlpha:1];
    _weatherIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nd1"]];
    
    [_weatherIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
    }];
    
    _tempLabel = [UILabel commonLableWithFontName:SFDR FontSize:13 colorAlpha:1];
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_timeLabel, _weatherIcon, _tempLabel]];
    
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFill;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 8.0;
    
    [self.contentView addSubview:stackView];
    
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
}

- (void)feedFakeData {
    self.timeLabel.text = @"18时";
    self.tempLabel.text = @"19°";
}

@end
