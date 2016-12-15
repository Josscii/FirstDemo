//
//  FDDeleteButton.m
//  FirstDemo
//
//  Created by mxl on 16/12/8.
//  Copyright © 2016年 tbw. All rights reserved.
//

#import "FDDeleteButton.h"
#import "Masonry/Masonry.h"

@implementation FDDeleteButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = [UIImage imageNamed:@"weather-delete-city-icon"];
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
