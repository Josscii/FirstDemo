//
//  FDSunriseTableViewCell.m
//  FirstDemo
//
//  Created by mxl on 16/12/2.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDSunriseTableViewCell.h"
#import "FDSunriseView.h"
#import "Masonry/Masonry.h"
#include "FDConstants.h"
#import "UILabel+FDLabel.h"

@interface FDSunriseTableViewCell ()

@property (nonatomic, strong) FDSunriseView *sunriseView;
@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;

@end

@implementation FDSunriseTableViewCell

#pragma mark - 
#pragma mark - life cycle

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
    
    UIImageView *cloudImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tq-view-cloud-img"]];
    [self.contentView addSubview:cloudImageView];
    [cloudImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-35.0f);
        make.bottom.equalTo(self.contentView.mas_top).offset(50);
    }];
    
    UIImageView *hillImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tq-view-hill-img"]];
    [self.contentView addSubview:hillImageView];
    [hillImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-40);
    }];
    
    _sunriseView = [[FDSunriseView alloc] init];
    [self.contentView addSubview:_sunriseView];
    [_sunriseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 122.0f));
        make.bottom.equalTo(self.contentView).offset(-40.0f);
        make.centerX.equalTo(self.contentView);
    }];
    
    _infoLabel = [UILabel commonLableWithFontName:PFSCR FontSize:19 colorAlpha:0.6];
    [self.contentView addSubview:_infoLabel];
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(_sunriseView).offset(54.0f);
    }];
    
    _startTimeLabel = [UILabel commonLableWithFontName:SFDR FontSize:10 colorAlpha:1];
    [self.contentView addSubview:_startTimeLabel];
    [_startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sunriseView.mas_bottom).offset(9);
        make.left.equalTo(self.contentView).offset(32);
    }];
    
    _endTimeLabel = [UILabel commonLableWithFontName:SFDR FontSize:10 colorAlpha:1];
    [self.contentView addSubview:_endTimeLabel];
    [_endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sunriseView.mas_bottom).offset(9);
        make.right.equalTo(self.contentView).offset(-32);
    }];
}

- (void)animateSunRise {
    [_sunriseView animatedSunRise];
}

#pragma mark -
#pragma mark - feed data

- (void)feedCellWithData:(id)data {
    
    NSString *sr = data[@"sr"];
    NSString *ss = data[@"ss"];
    
    _startTimeLabel.text = sr;
    _endTimeLabel.text = ss;
    
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *currentYMD = [dateFormatter stringFromDate:now];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *startDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@", currentYMD, sr]];
    NSDate *endDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@", currentYMD, ss]];
    
    _sunriseView.currentTime = now;
    _sunriseView.startTime = startDate;
    _sunriseView.endTime = endDate;
    
    if ([now compare:endDate] == NSOrderedDescending) {
        _infoLabel.text = @"离日落还有0小时0分";
        return;
    }
    
    CGFloat timeInterval = [endDate timeIntervalSinceDate:now];
    
    long seconds = lround(timeInterval);
    
    long hour = seconds / 3600;
    long min = (seconds % 3600) / 60;
    
    _infoLabel.text = [NSString stringWithFormat:@"离日落还有%ld小时%ld分", hour, min];
}

- (void)feedFakeData {
    _infoLabel.text = @"离日落还有3小时45分";
    _startTimeLabel.text = @"05:58";
    _endTimeLabel.text = @"19:38";
}

@end
