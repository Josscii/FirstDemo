//
//  FDForecastWeatherCollectionViewCell.m
//  FirstDemo
//
//  Created by mxl on 16/12/1.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDForecastWeatherCollectionViewCell.h"
#import "Masonry/Masonry.h"
#import "UILabel+FDLabel.h"
#import "FDConstants.h"

@implementation FDForecastWeatherCollectionViewCell

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
    
    _weakdayLabel = [UILabel commonLableWithFontName:SFDR FontSize:15 colorAlpha:1];
    _dateLabel = [UILabel commonLableWithFontName:SFDR FontSize:15 colorAlpha:1];
    _weatherIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nd1"]];
    
    [_weatherIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
    }];
    
    _tempLabel = [UILabel commonLableWithFontName:SFDR FontSize:13 colorAlpha:1];
    
    UIStackView *stackView1 = [[UIStackView alloc] initWithArrangedSubviews:@[_dateLabel, _weatherIcon, _tempLabel]];
    
    stackView1.axis = UILayoutConstraintAxisVertical;
    stackView1.distribution = UIStackViewDistributionFill;
    stackView1.alignment = UIStackViewAlignmentCenter;
    stackView1.spacing = 8.0f;
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_weakdayLabel, stackView1]];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFill;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 0.0f;
    
    [self.contentView addSubview:stackView];
    
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void)feedFakeData {
    _weakdayLabel.text = @"周一";
    _dateLabel.text = @"05/07";
    _tempLabel.text = @"多云";
}

@end
