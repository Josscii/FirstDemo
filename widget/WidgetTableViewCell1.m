//
//  WidgetTableViewCell1.m
//  FirstDemo
//
//  Created by mxl on 16/12/27.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "WidgetTableViewCell1.h"
#import "Masonry.h"
#import "FDConstants.h"

@interface WidgetTableViewCell1 ()

@property (nonatomic, strong) UIImageView *locationImageView;

@end

@implementation WidgetTableViewCell1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
        [self feedFakeData];
    }
    return self;
}

- (void)setupView {
    _locationImageView = [[UIImageView alloc] init];
    _locationImageView.image = [UIImage imageNamed:@"tq-view-local-icon"];
    [self.contentView addSubview:_locationImageView];
    
    [_locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(9.1);
        make.left.equalTo(self.contentView).offset(0);
    }];
    
    _cityLabel = [[UILabel alloc] init];
    _cityLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    _cityLabel.font = [UIFont fontWithName:PFSCR size:13];
    _cityLabel.numberOfLines = 0;
    [self.contentView addSubview:_cityLabel];
    
    [_cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(8);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
        make.left.equalTo(_locationImageView.mas_right).offset(4);
    }];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    _timeLabel.font = [UIFont fontWithName:PFSCR size:13];
    [self.contentView addSubview:_timeLabel];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.centerY.equalTo(_cityLabel);
    }];
}

- (void)feedFakeData {
    _cityLabel.text = @"渝北区";
    _timeLabel.text = @"24分钟前发布";
}

@end
