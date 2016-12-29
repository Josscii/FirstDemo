//
//  WidgetDayCollectionViewCell.m
//  FirstDemo
//
//  Created by mxl on 16/12/27.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "WidgetDayCollectionViewCell.h"
#import "Masonry.h"
#import "FDConstants.h"
#import "WidgetCalendarModel.h"
#import "UIColor+FDColor.h"

@interface WidgetVocationView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation WidgetVocationView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.layer.cornerRadius = 5;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont fontWithName:PFSCM size:7];
    [self addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

@end

@interface WidgetDayCollectionViewCell ()

@property (nonatomic, strong) UILabel *solarDayLabel;
@property (nonatomic, strong) UILabel *lunarDayLabel;
@property (nonatomic, strong) WidgetVocationView *vocationView;
@property (nonatomic, strong) UIView *eventView;

@end

@implementation WidgetDayCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.contentView.layer.cornerRadius = 6;
    
    _solarDayLabel = [[UILabel alloc] init];
    _solarDayLabel.font = [UIFont fontWithName:SFDR size:20];
    [self.contentView addSubview:_solarDayLabel];
    
    [_solarDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(3);
        make.centerX.equalTo(self.contentView);
    }];
    
    _lunarDayLabel = [[UILabel alloc] init];
    _lunarDayLabel.font = [UIFont fontWithName:PFSCR size:10];
    [self.contentView addSubview:_lunarDayLabel];
    
    [_lunarDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_solarDayLabel.mas_bottom).offset(2);
        make.centerX.equalTo(_solarDayLabel);
    }];
    
    _eventView = [[UIView alloc] init];
    _eventView.layer.cornerRadius = 1.5f;
    [self.contentView addSubview:_eventView];
    
    [_eventView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lunarDayLabel.mas_bottom).offset(2);
        make.width.height.mas_equalTo(3);
        make.centerX.equalTo(self.contentView);
    }];
    
    _vocationView = [[WidgetVocationView alloc] init];
    [self.contentView addSubview:_vocationView];
    
    [_vocationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(10);
        make.top.right.equalTo(self.contentView);
    }];
}

- (void)configureCellWithData:(id)data index:(NSInteger)index {
    WidgetCalendarModel *model = data;
    
    _solarDayLabel.text = model.solarDay;
    _solarDayLabel.textColor = [UIColor wd_blackColor];
    
    _lunarDayLabel.text = model.lunarDay;
    _lunarDayLabel.textColor = [[UIColor wd_blackColor] colorWithAlphaComponent:0.6];
    
    if ([model.lunarDay containsString:@"月"]) {
        _lunarDayLabel.textColor = [UIColor wd_redColor];
    }
    
    if (model.festival) {
        _lunarDayLabel.text = model.festival.length <= 5 ? model.festival : [model.festival substringToIndex:5];
        _lunarDayLabel.textColor = [UIColor wd_blueColor];
    }
    
    if (model.jieqi) {
        _lunarDayLabel.text = model.jieqi;
        _lunarDayLabel.textColor = [UIColor wd_redColor];
    }
    
    if (model.vocation.integerValue == 1) {
        _vocationView.titleLabel.text = @"休";
        _vocationView.backgroundColor = [UIColor wd_blueColor];
    } else if (model.vocation.integerValue == 2) {
        _vocationView.titleLabel.text = @"班";
        _vocationView.backgroundColor = [UIColor wd_redColor];
    } else {
        _vocationView.titleLabel.text = @"";
        _vocationView.backgroundColor = [UIColor clearColor];
    }
    
    if (index == 0 || index == 6 || index == 7 || index == 13 || index == 14 || index == 20 || index == 21 || index == 27 || index == 28 || index == 34) {
        _solarDayLabel.textColor = [UIColor wd_redColor];
    }
    
    if (model.isLastOrNext) {
        _solarDayLabel.alpha = 0.6;
        _lunarDayLabel.alpha = 0.6;
        _vocationView.alpha = 0.6;
        _eventView.alpha = 0.6;
    }
    
    if (model.isToday) {
        _solarDayLabel.textColor = [UIColor whiteColor];
        _lunarDayLabel.textColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor wd_redColor];
    }
}

- (void)prepareForReuse {
    _solarDayLabel.alpha = 1;
    _lunarDayLabel.alpha = 1;
    _vocationView.alpha = 1;
    _eventView.alpha = 1;
    self.contentView.backgroundColor = nil;
}
@end
