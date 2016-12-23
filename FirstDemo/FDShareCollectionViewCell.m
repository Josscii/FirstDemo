//
//  FDShareCollectionViewCell.m
//  FirstDemo
//
//  Created by mxl on 16/12/23.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDShareCollectionViewCell.h"
#import "Masonry/Masonry.h"

@interface FDShareCollectionViewCell ()

@end

@implementation FDShareCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _shareCircleView = [[UIButton alloc] init];
    [_shareCircleView addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    _shareCircleView.layer.cornerRadius = 25;
    [self.contentView addSubview:_shareCircleView];
    
    [_shareCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.center.equalTo(self.contentView);
    }];
    
    _shareImageView = [[UIImageView alloc] init];
    [_shareCircleView addSubview:_shareImageView];
    
    [_shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_shareCircleView);
    }];
    
    _shareLabel = [[UILabel alloc] init];
    _shareLabel.textColor = [UIColor lightGrayColor];
    _shareLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_shareLabel];
    
    [_shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_shareImageView);
        make.top.equalTo(_shareCircleView.mas_bottom).offset(5);
    }];
}

- (void)share:(id)sender {
    [_delegate shareWithCell:self];
}

@end
