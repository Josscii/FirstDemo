//
//  FDCurrentWeatherTableViewCell.m
//  FirstDemo
//
//  Created by mxl on 16/12/2.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDCurrentWeatherTableViewCell.h"
#import "Masonry/Masonry.h"
#import "UILabel+FDLabel.h"
#import "FDConstants.h"
#import "FDIconLabelView.h"
#import "FDUtils.h"
#import "FDCity.h"

@implementation FDCurrentWeatherTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self configureLayout];
        [self feedFakeData];
    }
    
    return self;
}

- (void)configureLayout {
    
    self.backgroundColor = [UIColor clearColor];
    
    _briefInfoLabel = [UILabel lowShadowLabelWithFontName:PFSCR FontSize:15.0f];
    [self.contentView addSubview:_briefInfoLabel];
    [_briefInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(32.0f);
        make.centerX.equalTo(self.contentView);
    }];
    
    _currentTempLabel = [UILabel lowShadowLabelWithFontName:SFDU FontSize:100.0f];
    [self.contentView addSubview:_currentTempLabel];
    [_currentTempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_briefInfoLabel.mas_bottom).offset(-11.0f);
        make.centerX.equalTo(self.contentView);
    }];
    
    _airQualityView = [[FDIconLabelView alloc] init];
    _airQualityView.icon.image = [UIImage imageNamed:@"tq-view-kqzl-icon"];
    [self.contentView addSubview:_airQualityView];
    [_airQualityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_currentTempLabel.mas_bottom).offset(-13.0f);
        make.centerX.equalTo(self.contentView);
    }];
    
    _bodyTempView = [[FDIconLabelView alloc] init];;
    _bodyTempView.icon.image = [UIImage imageNamed:@"tq-view-tgwd-icon"];
    _windView = [[FDIconLabelView alloc] init];
    _windView.icon.image = [UIImage imageNamed:@"tq-view-flfx-icon"];
    _waterView = [[FDIconLabelView alloc] init];
    _waterView.icon.image = [UIImage imageNamed:@"tq-view-sd-icon"];
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_bodyTempView, _windView, _waterView]];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFill;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 40.0f;
    
    [self.contentView addSubview:stackView];
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_airQualityView.mas_bottom).offset(29.0f);
        make.centerX.equalTo(self.contentView);
    }];
}

- (void)feedFakeData {
    _briefInfoLabel.text = @"小雨转阵雨 11/16°";
    _currentTempLabel.text = @"12°";
    _airQualityView.label.text = @"248 | 重度污染";
    _bodyTempView.label.text = @"体感 -16°";
    _windView.label.text = @"西北风";
    _waterView.label.text = @"95%";
}

- (void)feedCellWithData:(id)data {
    FDCity *city = data;
    
    _briefInfoLabel.text = [NSString stringWithFormat:@"%@ %@/%@°", [FDUtils weatherType: city.curr.weatherType.integerValue], city.curr.tempLow, city.curr.tempHigh];
    _currentTempLabel.text = [FDUtils tempWithNumber:city.curr.currentTemp];
    
    _airQualityView.label.text = [NSString stringWithFormat:@"%@ | %@", city.aqi.pm25, city.aqi.grade];
    
    _bodyTempView.label.text = [NSString stringWithFormat:@"体感 %@", city.curr.sendibleTemp];
    _windView.label.text = city.curr.windDirection;
    _waterView.label.text = [NSString stringWithFormat:@"%@%@", city.curr.relativeHumidity, @"%"];
}

@end
