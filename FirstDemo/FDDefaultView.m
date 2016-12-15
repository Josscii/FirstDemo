//
//  FDDefaultView.m
//  FirstDemo
//
//  Created by mxl on 16/12/9.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDDefaultView.h"
#import "FDConstants.h"
#import "UIColor+FDColor.h"
#import "Masonry/Masonry.h"

@implementation FDDefaultView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"city-default"];
    
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UILabel *defaultLabel = [[UILabel alloc] init];
    defaultLabel.text = @"默认";
    defaultLabel.textColor = [UIColor backgroundColor];
    defaultLabel.font = [UIFont systemFontOfSize:10];
    
    defaultLabel.transform = CGAffineTransformMakeRotation(-M_PI_4);
    
    [self addSubview:defaultLabel];
    [defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self).offset(5);
    }];
}

@end
