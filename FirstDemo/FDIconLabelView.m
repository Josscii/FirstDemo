
//
//  FDIconLabelView.m
//  FirstDemo
//
//  Created by mxl on 16/12/2.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDIconLabelView.h"
#import "FDConstants.h"
#import "UILabel+FDLabel.h"
#import "Masonry/Masonry.h"

@implementation FDIconLabelView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    _icon = [[UIImageView alloc] init];
    
    _label = [UILabel lowShadowLabelWithFontName:PFSCR FontSize:15.0f];
    _label.textColor = [UIColor whiteColor];
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_icon, _label]];
    
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFill;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 5.0;
    
    [self addSubview:stackView];
    
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
