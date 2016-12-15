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

#import "Masonry/Masonry.h"

#define UNCHECKEDICON @"weather-select-DC-normal-icon"
#define CHECKEDICON @"weather-select-DC-active-icon"

@interface FDEditCityCollectionViewCell ()

@property (nonatomic, strong) UIImageView *positionImageView;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UIImageView *weatherIcon;
@property (nonatomic, strong) UILabel *tempLabel;
@property (nonatomic, strong) UILabel *weatherLabel;

@property (nonatomic, strong) FDDefaultView *defaultImageView;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation FDEditCityCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self feedFakeData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configureEditingMode) name:@"FDShouldInavidateCellLayout" object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FDShouldInavidateCellLayout" object:nil];
}

- (void)setupView {
    self.layer.cornerRadius = 5;
    self.layer.shadowRadius = 2;
    self.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    
    // cityLabel
    _cityLabel = [UILabel commonLableWithFontName:PFSCR FontSize:15 colorAlpha:1];
    [self.contentView addSubview:_cityLabel];
    
    [_cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.centerX.equalTo(self.contentView);
    }];
    
    _positionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tq-view-local-icon"]];
    [self.contentView addSubview:_positionImageView];
    
    [_positionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_cityLabel);
        make.right.equalTo(_cityLabel.mas_left).offset(-3);
    }];
    
    UIView *separatorView = [[UIView alloc] init];
    [self.contentView addSubview:separatorView];
    
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cityLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
    }];
    
    separatorView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    
    _weatherIcon = [[UIImageView alloc] init];
    [self.contentView addSubview:_weatherIcon];
    
    [_weatherIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(separatorView.mas_bottom).offset(10);
    }];
    
    _tempLabel = [UILabel commonLableWithFontName:SFDR FontSize:13 colorAlpha:1];
    [self.contentView addSubview:_tempLabel];
    
    [_tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weatherIcon.mas_bottom).offset(8);
        make.centerX.equalTo(self.contentView);
    }];
    
    _weatherLabel = [UILabel commonLableWithFontName:PFSCR FontSize:13 colorAlpha:1];
    [self.contentView addSubview:_weatherLabel];
    
    [_weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tempLabel.mas_bottom).offset(3);
        make.centerX.equalTo(self.contentView);
    }];
    
    // defaultImageView
    _defaultImageView = [[FDDefaultView alloc] init];
    [self.contentView addSubview:_defaultImageView];
    
    [_defaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.contentView);
    }];
    
    _checkIcon = [[UIImageView alloc] init];
    _checkIcon.image = [UIImage imageNamed:UNCHECKEDICON];
    _checkIcon.userInteractionEnabled = YES;
    _checkLabel = [UILabel commonLableWithFontName:PFSCR FontSize:12 colorAlpha:1];
    _checkLabel.text = @"设为默认";
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_checkIcon, _checkLabel]];
    
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFill;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 5;
    
    [self.contentView addSubview:stackView];
    
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weatherLabel.mas_bottom).offset(8);
        make.centerX.equalTo(self.contentView);
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapToMakeItDefault:)];
    [stackView addGestureRecognizer:tapGesture];
    
    _deleteButton = [[FDDeleteButton alloc] init];
    [self addSubview:_deleteButton];
    
    _deleteButton.frame = CGRectMake(0, 0, 20, 20);
    _deleteButton.center = CGPointMake((SCREEN_WIDTH - 15 * 2 - 10 * 2) / 3, 0);
    
    UITapGestureRecognizer *deleteGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteItem:)];
    [_deleteButton addGestureRecognizer:deleteGesture];
}

- (void)deleteItem:(id)sender {
    [_delegate deleteCell:self];
}

- (void)didTapToMakeItDefault:(id)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:_indexPath.item forKey:@"defaultCityIndex"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FDShouldInavidateCellLayout" object:nil];
}

- (void)configureEditingMode {
    BOOL editingCity = [[NSUserDefaults standardUserDefaults] boolForKey:@"editingCity"];
    
    if (editingCity) {
        _checkLabel.alpha = 1;
        _checkIcon.alpha = 1;
        _deleteButton.alpha = 1;
        
        _defaultImageView.alpha = 0;
        
        NSInteger defaultIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"defaultCityIndex"];
        if (_indexPath.item == defaultIndex) {
            _checkIcon.image = [UIImage imageNamed:CHECKEDICON];
            _checkLabel.text = @"默认";
            _deleteButton.alpha = 0;
        } else {
            _checkIcon.image = [UIImage imageNamed:UNCHECKEDICON];
            _checkLabel.text = @"设为默认";
        }
    } else {
        _checkLabel.alpha = 0;
        _checkIcon.alpha = 0;
        _deleteButton.alpha = 0;
        
        NSInteger defaultIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"defaultCityIndex"];
        if (_indexPath.item == defaultIndex) {
            _defaultImageView.alpha = 1;
        } else {
            _defaultImageView.alpha = 0;
        }
    }
    
    if ([_cityLabel.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"location"]]) {
        _positionImageView.alpha = 1;
    } else {
        _positionImageView.alpha = 0;
    }
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    _indexPath = layoutAttributes.indexPath;
    
    [self configureEditingMode];
}

- (void)configreCellWithData:(id)data {
    
    NSString *cityName = data[@"c"];
    
    NSDictionary *curr = data[@"curr"];
    NSNumber *wt = curr[@"wt"];
    NSNumber *tl = curr[@"tl"];
    NSNumber *th = curr[@"th"];
    
    _cityLabel.text = cityName;
    _tempLabel.text = [NSString stringWithFormat:@"%@/%@°", tl, th];
    _weatherLabel.text = [FDUtils weatherType:wt.integerValue];
    
    NSNumber *ser = data[@"serverTime"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:ser.doubleValue];
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSCalendarUnitHour fromDate:date];
    
    NSNumber *hour = @(comp.hour);
    
    NSDictionary *sun = data[@"sun"];
    NSNumber *sr = [FDUtils hourOfTime: sun[@"sr"]];
    NSNumber *ss = [FDUtils hourOfTime: sun[@"ss"]];
    
    if ([hour integerValue] >= [sr integerValue] && [hour integerValue] <= [ss integerValue]) {
        _weatherIcon.image = [UIImage imageNamed: [NSString stringWithFormat:@"nd%@", curr[@"wt"]]];
    } else {
        _weatherIcon.image = [UIImage imageNamed: [NSString stringWithFormat:@"nn%@", curr[@"wt"]]];
        
        if ([UIImage imageNamed: [NSString stringWithFormat:@"nn%@", curr[@"wt"]]] == nil) {
            _weatherIcon.image = [UIImage imageNamed: [NSString stringWithFormat:@"nd%@", curr[@"wt"]]];
        } else {
            _weatherIcon.image = [UIImage imageNamed: [NSString stringWithFormat:@"nn%@", curr[@"wt"]]];
        }
    }
    
    if ([_cityLabel.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"location"]]) {
        _positionImageView.alpha = 1;
    } else {
        _positionImageView.alpha = 0;
    }
}

- (void)feedFakeData {
    _cityLabel.text = @"渝北";
    _weatherIcon.image = [UIImage imageNamed:@"nd1"];
    _tempLabel.text = @"12/24";
    _weatherLabel.text = @"多云";
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return CGRectContainsPoint(UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(-20, 0, 0, -20)), point);
}

@end
