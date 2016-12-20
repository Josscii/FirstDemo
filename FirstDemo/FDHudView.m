//
//  FDHudView.m
//  FirstDemo
//
//  Created by mxl on 16/12/20.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDHudView.h"
#import "Masonry/Masonry.h"

@interface FDHudView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation FDHudView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    // clear
    self.backgroundColor = [UIColor clearColor];
    
    // hub view
    UIView *hud = [[UIView alloc] init];
    hud.layer.cornerRadius = 5;
    hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self addSubview:hud];
    
    [hud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(40);
    }];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] init];
    [hud addSubview:_activityIndicator];
    
    [_activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(hud);
    }];
    
    [_activityIndicator startAnimating];
}

@end
