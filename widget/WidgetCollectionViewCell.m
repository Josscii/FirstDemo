//
//  WidgetCollectionViewCell.m
//  FirstDemo
//
//  Created by mxl on 16/12/27.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "WidgetCollectionViewCell.h"
#import "FDConstants.h"
#import "Masonry.h"
#import "FDForecastItemDate.h"

@interface WidgetCollectionViewCell ()

@end

@implementation WidgetCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self feedFakeData];
    }
    return self;
}

- (void)setupView {
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    _dateLabel.font = [UIFont fontWithName:PFSCR size:13];
    [self.contentView addSubview:_dateLabel];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(9.5);
    }];
    
    _weatherImageView = [[UIImageView alloc] init];
    _weatherImageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:_weatherImageView];
    
    [_weatherImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.equalTo(_dateLabel.mas_bottom);
        make.centerX.equalTo(self.contentView);
    }];
    
    _tempLabel = [[UILabel alloc] init];
    _tempLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    _tempLabel.font = [UIFont fontWithName:PFSCR size:13];
    [self.contentView addSubview:_tempLabel];
    
    [_tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.weatherImageView.mas_bottom);
    }];
}

- (void)feedFakeData {
    _dateLabel.text = @"明天";
    _weatherImageView.image = [UIImage imageNamed:@"nd1"];
    _tempLabel.text = @"15/19°";
}

- (void)alphaView {
    _dateLabel.alpha = 0.6;
    _tempLabel.alpha = 0.6;
}

- (void)prepareForReuse {
    _dateLabel.alpha = 1;
    _tempLabel.alpha = 1;
}

@end
