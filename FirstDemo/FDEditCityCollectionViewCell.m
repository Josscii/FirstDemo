//
//  FDEditCityCollectionViewCell.m
//  FirstDemo
//
//  Created by mxl on 16/12/6.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDEditCityCollectionViewCell.h"
#import "UILabel+FDLabel.h"
#import "FDConstants.h"
#import "UIColor+FDColor.h"
#import "FDDefaultView.h"
#import "FDUtils.h"
#import "FDCity.h"

#import "Masonry/Masonry.h"

#define UNCHECKEDICON @"weather-select-DC-normal-icon"
#define CHECKEDICON @"weather-select-DC-active-icon"

@interface FDEditCityCollectionViewCell ()

@property (nonatomic, strong) UIImageView *checkIcon;
@property (nonatomic, strong) UILabel *checkLabel;
@property (nonatomic, strong) UIImageView *positionImageView;
@property (nonatomic, strong) UIImageView *weatherIcon;
@property (nonatomic, strong) UILabel *tempLabel;
@property (nonatomic, strong) UILabel *weatherLabel;

@property (nonatomic, strong) FDDefaultView *defaultImageView;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIStackView *checkView;

@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@implementation FDEditCityCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)dealloc {
    [_task cancel];
}

- (void)prepareForReuse {
    _deleteButton.alpha = 0;
    _defaultImageView.alpha = 0;
    _checkView.alpha = 0;
    _weatherIcon.image = nil;
    _tempLabel.text = @"";
    _weatherLabel.text = @"";
    _loadingLabel.alpha = 1;
}

- (void)setupView {
    // container
    UIView *container = [[UIView alloc] init];
    
    container.layer.cornerRadius = 5;
    container.layer.shadowRadius = 2;
    container.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    container.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    
    [self.contentView addSubview:container];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    // cityLabel
    _cityLabel = [UILabel commonLableWithFontName:PFSCR FontSize:15 colorAlpha:1];
    [container addSubview:_cityLabel];
    
    [_cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(container).offset(8);
        make.centerX.equalTo(container);
    }];
    
    _positionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tq-view-local-icon"]];
    _positionImageView.alpha = 0;
    [container addSubview:_positionImageView];
    
    [_positionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_cityLabel);
        make.right.equalTo(_cityLabel.mas_left).offset(-3);
    }];
    
    UIView *separatorView = [[UIView alloc] init];
    [container addSubview:separatorView];
    
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cityLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(1);
        make.left.equalTo(container).offset(5);
        make.right.equalTo(container).offset(-5);
    }];
    
    separatorView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    
    _weatherIcon = [[UIImageView alloc] init];
    [container addSubview:_weatherIcon];
    
    [_weatherIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.centerX.equalTo(container);
        make.top.equalTo(separatorView.mas_bottom).offset(10);
    }];
    
    _tempLabel = [UILabel commonLableWithFontName:SFDR FontSize:13 colorAlpha:1];
    [container addSubview:_tempLabel];
    
    [_tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weatherIcon.mas_bottom).offset(8);
        make.centerX.equalTo(container);
    }];
    
    _weatherLabel = [UILabel commonLableWithFontName:PFSCR FontSize:13 colorAlpha:1];
    [container addSubview:_weatherLabel];
    
    [_weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tempLabel.mas_bottom).offset(3);
        make.centerX.equalTo(container);
    }];
    
    // defaultImageView
    _defaultImageView = [[FDDefaultView alloc] init];
    _defaultImageView.alpha = 0;
    [container addSubview:_defaultImageView];
    
    [_defaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(container);
    }];
    
    _checkIcon = [[UIImageView alloc] init];
    _checkIcon.image = [UIImage imageNamed:UNCHECKEDICON];
    _checkIcon.userInteractionEnabled = YES;
    _checkLabel = [UILabel commonLableWithFontName:PFSCR FontSize:12 colorAlpha:1];
    _checkLabel.text = @"设为默认";
    
    _checkView = [[UIStackView alloc] initWithArrangedSubviews:@[_checkIcon, _checkLabel]];
    _checkView.alpha = 0;
    
    _checkView.axis = UILayoutConstraintAxisHorizontal;
    _checkView.distribution = UIStackViewDistributionFill;
    _checkView.alignment = UIStackViewAlignmentCenter;
    _checkView.spacing = 5;
    
    [container addSubview:_checkView];
    
    _checkView.backgroundColor = [UIColor redColor];
    
    [_checkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(container).offset(-8);
        make.centerX.equalTo(container);
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapToMakeItDefault:)];
    [_checkView addGestureRecognizer:tapGesture];
    
    // delete button
    _deleteButton = [[FDDeleteButton alloc] init];
    _deleteButton.alpha = 0;
    [self.contentView addSubview:_deleteButton];
    
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.centerY.equalTo(container.mas_top);
        make.centerX.equalTo(container.mas_right);
    }];
    
    UITapGestureRecognizer *deleteGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteItem:)];
    [_deleteButton addGestureRecognizer:deleteGesture];
    
    // loading label
    _loadingLabel = [UILabel commonLableWithFontName:PFSCR FontSize:12 colorAlpha:1];
    _loadingLabel.text = @"正在加载";
    [container addSubview:_loadingLabel];
    [_loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(container);
        make.centerY.equalTo(container).mas_offset(10);
    }];
    _loadingLabel.alpha = 1;
}

- (void)deleteItem:(id)sender {
    [_delegate deleteCell:self];
}

- (void)didTapToMakeItDefault:(id)sender {
    [_delegate makeCellDefault:self];
}

- (void)configreCellWithData:(id)data {
    
    FDCity *city = data;
    
    _cityLabel.text = city.cityName;
    
    if (_delegate.isEditingCity) {
        _checkView.alpha = 1;
        _deleteButton.alpha = 1;
        
        _defaultImageView.alpha = 0;
        
        if (city.isDefaultCity) {
            _checkIcon.image = [UIImage imageNamed:CHECKEDICON];
            _checkLabel.text = @"默认";
            _deleteButton.alpha = 0;
        } else {
            _checkIcon.image = [UIImage imageNamed:UNCHECKEDICON];
            _checkLabel.text = @"设为默认";
        }
    } else {
        _checkView.alpha = 0;
        _deleteButton.alpha = 0;
        
        if (city.isDefaultCity) {
            _defaultImageView.alpha = 1;
        } else {
            _defaultImageView.alpha = 0;
        }
    }
    
    if (city.isCurrentLocation) {
        _positionImageView.alpha = 1;
    } else {
        _positionImageView.alpha = 0;
    }
    
    if (!city.saveTime) {
        _task = [FDUtils fetchDataWithCityCode:city.cityCode completionBlock:^(NSDictionary *weatherData) {
            [city configureWihtDictionary:weatherData];
            [self feedCellWithCity:city];
            _loadingLabel.alpha = 0;
        }];
    } else {
        if (city.isExpired) {
            _task = [FDUtils fetchDataWithCityCode:city.cityCode completionBlock:^(NSDictionary *weatherData) {
                [city configureWihtDictionary:weatherData];
                [self feedCellWithCity:city];
                _loadingLabel.alpha = 0;
            }];
        } else {
            [self feedCellWithCity:city];
            _loadingLabel.alpha = 0;
        }
    }
}

- (void)feedCellWithCity:(FDCity *)city {
    _tempLabel.text = [NSString stringWithFormat:@"%@/%@°", city.curr.tempLow, city.curr.tempHigh];
    _weatherLabel.text = [FDUtils weatherType:city.curr.weatherType.integerValue];
    
    NSDate *date = [NSDate date];
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSCalendarUnitHour fromDate:date];
    
    NSNumber *hour = @(comp.hour);
    
    NSNumber *sr = [FDUtils hourOfTime: city.sunRiseTime];
    NSNumber *ss = [FDUtils hourOfTime: city.sunFallTime];
    
    if ([hour integerValue] >= [sr integerValue] && [hour integerValue] <= [ss integerValue]) {
        _weatherIcon.image = [UIImage imageNamed: [NSString stringWithFormat:@"nd%@", city.curr.weatherType]];
    } else {
        _weatherIcon.image = [UIImage imageNamed: [NSString stringWithFormat:@"nn%@", city.curr.weatherType]];
        
        if ([UIImage imageNamed: [NSString stringWithFormat:@"nn%@", city.curr.weatherType]] == nil) {
            _weatherIcon.image = [UIImage imageNamed: [NSString stringWithFormat:@"nd%@", city.curr.weatherType]];
        } else {
            _weatherIcon.image = [UIImage imageNamed: [NSString stringWithFormat:@"nn%@", city.curr.weatherType]];
        }
    }
}

- (void)feedFakeData {
    _cityLabel.text = @"渝北";
    _weatherIcon.image = [UIImage imageNamed:@"nd1"];
    _tempLabel.text = @"12/24";
    _weatherLabel.text = @"多云";
}

// no need for this
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    return CGRectContainsPoint(UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(-20, 0, 0, -20)), point);
//}

@end
