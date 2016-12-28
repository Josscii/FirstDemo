//
//  WidgetTableViewCell2.m
//  FirstDemo
//
//  Created by mxl on 16/12/27.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "WidgetTableViewCell2.h"
#import "FDConstants.h"
#import "Masonry.h"

@interface WidgetTableViewCell2 ()

@end

@implementation WidgetTableViewCell2

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
        [self feedFakeData];
    }
    return self;
}

- (void)setupView {
    _tempLabel = [[UILabel alloc] init];
    _tempLabel.textColor = [UIColor colorWithRed:51/255.0 green:52/255.0 blue:51/255.0 alpha:1];
    _tempLabel.font = [UIFont fontWithName:PFSCR size:36];
    _tempLabel.numberOfLines = 0;
    [self.contentView addSubview:_tempLabel];
    
    [_tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.centerY.equalTo(self.contentView);
    }];
    
    _weatherTypeLabel = [[UILabel alloc] init];
    _weatherTypeLabel.textColor = [UIColor colorWithRed:51/255.0 green:52/255.0 blue:51/255.0 alpha:1];
    _weatherTypeLabel.font = [UIFont fontWithName:PFSCR size:13];
    [self.contentView addSubview:_weatherTypeLabel];
    
    [_weatherTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tempLabel.mas_right).offset(5);
        make.bottom.equalTo(_tempLabel.mas_baseline);
    }];
    
    _aqiView = [[UIView alloc] init];
    _aqiView.layer.cornerRadius = 3;
    [self.contentView addSubview:_aqiView];
    
    [_aqiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(_tempLabel.mas_baseline);
    }];
    
    _aqiLabel = [[UILabel alloc] init];
    _aqiLabel.textColor = [UIColor whiteColor];
    _aqiLabel.font = [UIFont fontWithName:PFSCR size:12];
    [_aqiView addSubview:_aqiLabel];
    
    [_aqiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_aqiView).mas_offset(UIEdgeInsetsMake(2, 5, 2, 5));
    }];
}

- (void)feedFakeData {
    _tempLabel.text = @"18°";
    _weatherTypeLabel.text = @"阴  15/19°";
    _aqiView.backgroundColor = [UIColor colorWithRed:128.0/255.0 green:225.0/255.0 blue:74.0/255.0 alpha:1.0];
    _aqiLabel.text = @"优 30";
}

@end
