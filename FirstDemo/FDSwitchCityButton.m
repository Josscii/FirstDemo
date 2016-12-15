//
//  FDSwitchCityButton.m
//  FirstDemo
//
//  Created by mxl on 16/12/6.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDSwitchCityButton.h"
#import "FDConstants.h"
#import "Masonry/Masonry.h"
#import "UIImageView+FDImageView.h"
#import "UILabel+FDLabel.h"

@implementation FDSwitchCityButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _positionImageView = [UIImageView shadowImageView];
    _positionImageView.image = [UIImage imageNamed:@"tq-view-local-icon"];
    //_positionImageView.userInteractionEnabled = NO;
    
    _cityLabel = [UILabel lowShadowLabelWithFontName:PFSCM FontSize:17];
    //_cityLabel.userInteractionEnabled = NO;
    
    _downImageView = [UIImageView shadowImageView];
    _downImageView.image = [UIImage imageNamed:@"nav-more-arrow-icon"];
    //_downImageView.userInteractionEnabled = NO;
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_positionImageView, _cityLabel, _downImageView]];
    
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFill;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 2;
    stackView.userInteractionEnabled = NO;
    
    [self addSubview:stackView];
    
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
